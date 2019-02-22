/* Split data into training and testing sets */
DROP PROCEDURE IF EXISTS PyTrainTestSplit;
GO

CREATE PROCEDURE [dbo].[PyTrainTestSplit] (@pct int)
AS

DROP TABLE IF EXISTS dbo.wine_sample_training
SELECT * into wine_sample_training FROM WineQuality.dbo.wine_data WHERE (ABS(CAST(BINARY_CHECKSUM(facidity)  as int)) % 100) < @pct

DROP TABLE IF EXISTS dbo.wine_sample_testing
SELECT * into wine_sample_testing FROM WineQuality.dbo.wine_data
WHERE (ABS(CAST(BINARY_CHECKSUM(facidity)  as int)) % 100) > @pct

GO

EXEC PyTrainTestSplit 75
GO

/* Create Model and where to store it */
DROP PROCEDURE IF EXISTS PyTrain;
GO

CREATE PROCEDURE [dbo].[PyTrain] (@trained_model varbinary(max) OUTPUT)
AS
BEGIN
EXEC sp_execute_external_script
  @language = N'Python',
  @script = N'
import numpy
import pickle
from sklearn.linear_model import LogisticRegression
from revoscalepy import RxLocalSeq, RxInSqlServer, rx_get_compute_context, rx_set_compute_context
from revoscalepy import rx_exec, rx_data_step
from microsoftml import rx_logistic_regression, rx_fast_trees
import pandas as pd

cols = InputDataSet.columns.drop(["quality", "color"])
ds = InputDataSet.drop("color",axis=1).apply(pd.to_numeric)
mod = rx_fast_trees("quality ~" + "+".join(cols), data=ds, method="regression")
trained_model = pickle.dumps(mod)
',
@input_data_1 = N'SELECT * FROM [WineQuality].[dbo].[wine_sample_training]
',
@input_data_1_name = N'InputDataSet',
@params = N'@trained_model varbinary(max) OUTPUT',
@trained_model = @trained_model OUTPUT;
END;
GO

DROP TABLE IF EXISTS dbo.wine_quality_models;
GO

CREATE TABLE dbo.wine_quality_models (
    model_name varchar(255),
    model varbinary(max)
);
GO

/* Train Model */
DECLARE @model VARBINARY(MAX);
EXEC PyTrain @model OUTPUT;
INSERT INTO dbo.wine_quality_models (model_name, model) VALUES('Pytrain_model', @model);
GO

DROP PROCEDURE IF EXISTS dbo.PredictQuality;
GO 


/* Create Store Procedure to Predict Quality*/ 
CREATE PROCEDURE [dbo].[PredictQuality] (@model varchar(50), @inquery nvarchar(max))
AS
BEGIN
DECLARE @lmodel2 varbinary(max) = (select model from dbo.wine_quality_models where model_name = @model);
EXEC sp_execute_external_script
  @language = N'Python',
  @script = N'
import pickle;
import numpy;
import pandas as pd
from sklearn import metrics
from microsoftml import rx_predict
ds = InputDataSet.drop("color",axis=1).apply(pd.to_numeric)
mod = pickle.loads(lmodel2)
X = InputDataSet[["facidity", "vacidity", "citric", "sugar", "chlorides", "fsulfur", "tsulfur", "density", "pH", "sulphates", "alcohol"]]
y = numpy.ravel(InputDataSet[["quality"]])
pred_list = rx_predict(model = mod, data = X, extra_vars_to_write=["quality_Pred"])

#OutputDataSet = pd.DataFrame({"quality": InputDataSet[["quality"]], "quality_Pred": round(pred_list,1)})
OutputDataSet = round(pred_list,1)
',	
  @input_data_1 = @inquery,
  @input_data_1_name = N'InputDataSet',
  @params = N'@lmodel2 varbinary(max)',
  @lmodel2 = @lmodel2
WITH RESULT SETS ((Score float));
END;


/* Execute Stored Procedure on unseen data */ 
DECLARE @query_string nvarchar(max)
  SET @query_string='
  select * from dbo.wine_sample_testing'
EXEC [dbo].[PredictQuality] 'Pytrain_model', @query_string;
