## SQL Server ML Services End-to-End - code sample

### Python 
In order to set this up, you'll need to restore from the `WineQuality.bak` file. You'll also need to [configure SQL Server ML Services](https://docs.microsoft.com/en-us/sql/advanced-analytics/install/sql-machine-learning-services-windows-install?view=sql-server-2017) on whatever device you want to run this sample on.  

You can then either run through the .ipynb file or the .sql file to create and train the model.  

### Azure and R
In order to set this up, you'll need to restore from the `WineQuality.bak` file into a new instance of Azure SQL DB. By sending an email to SqlDbML@microsoft.com with your server name, you can enable ML Services with R. You'll want to make sure you have a Gen5 instance of Azure SQL DB. For more info on the differences between on-prem and Azure for ML, see [here](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-machine-learning-services-differences).

You can then run through the `sql-r-azure.md` file in your R IDE of choice and SSMS.


