package pkg;


//import java.util.LinkedList; 
//import java.util.List;
//import java.util.stream.Collectors;
//import java.util.stream.IntStream;
import java.io.*;
import java.net.*;
import java.util.*;
//import javax.net.ssl.HttpsURLConnection;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import com.microsoft.sqlserver.javalangextension.PrimitiveDataset;
import com.microsoft.sqlserver.javalangextension.AbstractSqlServerExtensionExecutor;

class Document {
	public int id;
	public String language = "en";
    public String text;
    public Document(int id, String language, String text){
        this.id = id;
        this.language = language;
        this.text = text;
    }
}
class Documents {
    public List<Document> documents;

    public Documents() {
        this.documents = new ArrayList<Document>();
    }
    public void add(int id, String language, String text) {
        this.documents.add (new Document (id, language, text));
    }
}

public class sentimentSample extends AbstractSqlServerExtensionExecutor {
    //private Pattern expr;
    public static String language = "en";
    // Replace the accessKey string value with your valid access key.
    static String accessKey = "YourKey";    
    static String host = "https://southcentralus.api.cognitive.microsoft.com";
    //static String host = "http://0.0.0.0:5000";
    static String path = "/text/analytics/v2.0/sentiment";
    
    public static void main(String[] args) {
    	PrimitiveDataset input = new PrimitiveDataset();
    	
    	input.addColumnMetadata(0, "id", java.sql.Types.INTEGER, 0,0);
    	input.addColumnMetadata(1, "text", java.sql.Types.NVARCHAR, 0,0);
    	
    	
    	String[] inputText = {"I love java", "I hate you"};
    	int[] inputId = {1,2};
    	
    	
    	input.addIntColumn(0, inputId, null);
    	input.addStringColumn(1, inputText);
    	
    	LinkedHashMap<String, Object> params = new LinkedHashMap<String,Object>();
    	
    	//params.put("regexExpr", "[Jj]ava");
    	
    	sentimentSample obj = new sentimentSample();
    	PrimitiveDataset output = obj.execute(input , params);

    }
    
    public sentimentSample() {
        // Setup the expected extension version, and class to use for input and output dataset
        executorExtensionVersion = SQLSERVER_JAVA_LANG_EXTENSION_V1;
        executorInputDatasetClassName = PrimitiveDataset.class.getName();
        executorOutputDatasetClassName = PrimitiveDataset.class.getName();
    }
    
    public PrimitiveDataset execute(PrimitiveDataset input , LinkedHashMap<String, Object> params) {
        // Validate the input parameters and input column schema
        validateInput(input , params);

        int[] inIds = input.getIntColumn(0);
        String[] inValues = input.getStringColumn(1);
        int rowCount = inValues.length;

        /*String regexExpr = (String)params.get("regexExpr");
        expr = Pattern.compile(regexExpr);

        System.out.println("regex expression: " + regexExpr); */

        // Lists to store the output data
        LinkedList<Integer> outIds = new LinkedList<Integer>();
        LinkedList<String> outValues = new LinkedList<String>();
        LinkedList<String> outSentiment = new LinkedList<String>();

        // Evaluate each row
        for(int i = 0; i < rowCount; i++) {
        	String res = null;
            String jsonResult = null;
        	try {
        		Documents documents = new Documents ();
	            documents.add(inIds[i], language, inValues[i]);
				res = GetSentiment(documents);
				jsonResult = getScore(res);
				outIds.add(inIds[i]);
				outValues.add(inValues[i]);
				outSentiment.add(jsonResult);
			} catch (Exception e) {
				// Auto-generated catch block
				e.printStackTrace();
			}
        }

        int outputRowCount = outValues.size();

        int[] idOutputCol = new int[outputRowCount];
        String[] valueOutputCol = new String[outputRowCount];
        String[] sentimentOutputCol = new String[outputRowCount];

        // Convert the list of output columns to arrays
        outValues.toArray(valueOutputCol);
        outSentiment.toArray(sentimentOutputCol);

        ListIterator<Integer> it = outIds.listIterator(0);
        int rowId = 0;

        //System.out.println("Output data:");
        while (it.hasNext()) {
            idOutputCol[rowId] = it.next().intValue();

            //System.out.println("ID: " + idOutputCol[rowId] + " Value: " + valueOutputCol[rowId] +
            		//" Sentiment: " + sentimentOutputCol[rowId]);
            rowId++;
        }

        // Construct the output dataset
        PrimitiveDataset output = new PrimitiveDataset();

        output.addColumnMetadata(0, "ID", java.sql.Types.INTEGER, 0, 0);
        output.addColumnMetadata(1, "Text", java.sql.Types.NVARCHAR, 0, 0);
        output.addColumnMetadata(2, "Sentiment", java.sql.Types.NVARCHAR, 0, 0);

        output.addIntColumn(0, idOutputCol, null);
        output.addStringColumn(1, valueOutputCol);
        output.addStringColumn(2, sentimentOutputCol);

        return output;
    }

    private void validateInput(PrimitiveDataset input, LinkedHashMap<String, Object> params) {


        // The expected input schema should be at least 2 columns, (INTEGER, STRING)
        if (input.getColumnCount() < 2) {
            throw new IllegalArgumentException("Unexpected input schema, schema should be an (INTEGER, NVARCHAR or VARCHAR)");
        }

        // Check that the input column types are expected
        if (input.getColumnType(0) != java.sql.Types.INTEGER &&
                (input.getColumnType(1) != java.sql.Types.VARCHAR && input.getColumnType(1) == java.sql.Types.NVARCHAR )) {
            throw new IllegalArgumentException("Unexpected input schema, schema should be an (INTEGER, NVARCHAR or VARCHAR)");
        }
    }
    
    public static String GetSentiment (Documents documents) throws Exception {
        String text = new Gson().toJson(documents);
        byte[] encoded_text = text.getBytes("UTF-8");

        URL url = new URL(host+path);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "text/json");
        connection.setRequestProperty("Ocp-Apim-Subscription-Key", accessKey);
        connection.setDoOutput(true);
        
        DataOutputStream wr = new DataOutputStream(connection.getOutputStream());
        wr.write(encoded_text, 0, encoded_text.length);
        wr.flush();
        wr.close();

        StringBuilder response = new StringBuilder ();
        BufferedReader in = new BufferedReader(
        new InputStreamReader(connection.getInputStream()));
        String line;
        while ((line = in.readLine()) != null) {
            response.append(line);
        }
        in.close();

        return response.toString();
    }
    
    public static String prettify(String json_text) {
        JsonParser parser = new JsonParser();
        JsonObject json = parser.parse(json_text).getAsJsonObject();
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        return gson.toJson(json);
    }
    
    public static String getScore(String jsonLine) {
        JsonElement jelement = new JsonParser().parse(jsonLine);
        JsonObject  jobject = jelement.getAsJsonObject();
        JsonArray jarray = jobject.getAsJsonArray("documents");
        jobject = jarray.get(0).getAsJsonObject();
        String result = jobject.get("score").getAsString();
        return result;
    }
}