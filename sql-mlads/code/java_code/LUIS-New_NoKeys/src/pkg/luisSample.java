package pkg;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;

// This sample uses the Apache HTTP client from HTTP Components (http://hc.apache.org/downloads.cgi)

// You need to add the following Apache HTTP client libraries to your project:
// httpclient-4.5.3.jar
// httpcore-4.4.11.jar
// commons-logging-4.0.6.jar

import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import com.microsoft.sqlserver.javalangextension.PrimitiveDataset;
import com.microsoft.sqlserver.javalangextension.AbstractSqlServerExtensionExecutor;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.ListIterator;


import java.util.regex.*;

class Document {
	public int id;
    public String text;

    public Document(int inIds, String text){
        this.id = inIds;
        this.text = text;
    }
}
class Documents {
    public List<Document> documents;

    public Documents() {
        this.documents = new ArrayList<Document>();
    }
    public void add(int inIds, String text) {
        this.documents.add (new Document (inIds, text));
    }
}


public class luisSample extends AbstractSqlServerExtensionExecutor {
    // Replace the accessKey string value with your valid access key.
    static String accessKey = "YourKey";
    static String appId = "YourAppID";
    
    
    
    static String host = "https://centralus.api.cognitive.microsoft.com";
    //static String host = "http://172.16.1.9:5000";
    //static String host = "http://0.0.0.0:5000";
    static String path = "/luis/v2.0/apps/";
    
    public static void main(String[] args) {
    	PrimitiveDataset input = new PrimitiveDataset();
    	
    	input.addColumnMetadata(0, "id", java.sql.Types.INTEGER, 0,0);
    	input.addColumnMetadata(1, "text", java.sql.Types.NVARCHAR, 0,0);
    	
    	String[] inputText = {"Deliver to Atlanta from Los Angeles Tuesday at 4PM", "Arrives in New York from Seattle Monday at noon"};
    	int[] inputId = {1,2};
    	
    	input.addIntColumn(0, inputId, null);
    	input.addStringColumn(1, inputText);
    	
    	LinkedHashMap<String, Object> params = new LinkedHashMap<String,Object>();
    	
    	luisSample obj = new luisSample();
    	PrimitiveDataset output = obj.execute(input , params);

    }
    
    public luisSample() {
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
        LinkedList<String> outOrigin = new LinkedList<String>();
        LinkedList<String> outDestination = new LinkedList<String>();
        LinkedList<String> outDatetime = new LinkedList<String>();

        // Evaluate each row
        for(int i = 0; i < rowCount; i++) {
            String res = null;
            String resOrigin = null;
            String resDestination = null;
            String resDateTime = null;
        	try {
        		Documents documents = new Documents ();
	            documents.add(inIds[i], inValues[i]);
				//Documents documents = new Documents ();
	            //documents.add(inputRow.id, inputRow.text);
				res = getEntities(documents);
				resOrigin = getFromLocation(res);
				resDestination = getToLocation(res);
				resDateTime = getDateTime(res);
				outIds.add(inIds[i]);
				outValues.add(inValues[i]);
				outOrigin.add(resOrigin);
				outDestination.add(resDestination);
				outDatetime.add(resDateTime);
			} catch (Exception e) {
				// Auto-generated catch block
				e.printStackTrace();
			}
        }

        int outputRowCount = outValues.size();

        int[] idOutputCol = new int[outputRowCount];
        String[] valueOutputCol = new String[outputRowCount];
        String[] originOutputCol = new String[outputRowCount];
        String[] destinationOutputCol = new String[outputRowCount];
        String[] datetimeOutputCol = new String[outputRowCount];

        // Convert the list of output columns to arrays
        outValues.toArray(valueOutputCol);
        outOrigin.toArray(originOutputCol);
        outDestination.toArray(destinationOutputCol);
        outDatetime.toArray(datetimeOutputCol);

        ListIterator<Integer> it = outIds.listIterator(0);
        int rowId = 0;

        //System.out.println("Output data:");
        while (it.hasNext()) {
            idOutputCol[rowId] = it.next().intValue();

           System.out.println("ID: " + idOutputCol[rowId] + " Entry: " + valueOutputCol[rowId] +
            		" Origin: " + originOutputCol[rowId] +
            		" Destination: " + destinationOutputCol[rowId] +
            		" DateTime: " + datetimeOutputCol[rowId]);
            rowId++;
        }

        // Construct the output dataset
        PrimitiveDataset output = new PrimitiveDataset();

        output.addColumnMetadata(0, "ID", java.sql.Types.INTEGER, 0, 0);
        output.addColumnMetadata(1, "Text", java.sql.Types.NVARCHAR, 0, 0);
        output.addColumnMetadata(2, "Origin", java.sql.Types.NVARCHAR, 0, 0);
        output.addColumnMetadata(3, "Destination", java.sql.Types.NVARCHAR, 0, 0);
        output.addColumnMetadata(4, "DateTime", java.sql.Types.NVARCHAR, 0, 0);
        
        output.addIntColumn(0, idOutputCol, null);
        output.addStringColumn(1, valueOutputCol);
        output.addStringColumn(2, originOutputCol);
        output.addStringColumn(3, destinationOutputCol);
        output.addStringColumn(4, datetimeOutputCol);

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
    
    public static String getEntities(Documents documents) 
    {
    	
    	String text = new Gson().toJson(documents);
        HttpClient httpclient = HttpClients.createDefault();

        try
        {
            URIBuilder endpointURLbuilder = new URIBuilder(host + path + appId + "?");
            // query text
            endpointURLbuilder.setParameter("q", text);
            // create URL from string
            URI endpointURL = endpointURLbuilder.build();
            // create HTTP object from URL
            HttpGet request = new HttpGet(endpointURL);
            // set key to access LUIS endpoint
            request.setHeader("Ocp-Apim-Subscription-Key", accessKey);
            // access LUIS endpoint - analyze text
            HttpResponse response = httpclient.execute(request);
            // get response
            HttpEntity entity = response.getEntity();
            String entities = EntityUtils.toString(entity);
            return entities;
        }

        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }
		return null;
    }
    
    public static String getDateTime(String jsonLine) {
    	try {
        JsonElement jelement = new JsonParser().parse(jsonLine);
        JsonObject  jobject = jelement.getAsJsonObject();
        JsonArray jarray = jobject.getAsJsonArray("entities");
        jobject = jarray.get(2).getAsJsonObject();
        jobject = jobject.getAsJsonObject("resolution");
        jarray = jobject.getAsJsonArray("values");
        jobject = jarray.get(1).getAsJsonObject();
        String result = jobject.get("value").getAsString();
        return result;
        
    } catch (Exception e) {
		String result = "Unknown";
		return result;
	}
    }
    
    
    public static String getToLocation(String jsonLine) {
    	try {
        JsonElement jelement = new JsonParser().parse(jsonLine);
        JsonObject  jobject = jelement.getAsJsonObject();
        JsonArray jarray = jobject.getAsJsonArray("entities");
        jobject = jarray.get(0).getAsJsonObject();
        String result = jobject.get("entity").getAsString();
        return result;
        
    } catch (Exception e) {
		String result = "Unknown";
		return result;
	}
    }
    
    public static String getFromLocation(String jsonLine) {
    	try {
            JsonElement jelement = new JsonParser().parse(jsonLine);
            JsonObject  jobject = jelement.getAsJsonObject();
            JsonArray jarray = jobject.getAsJsonArray("entities");
            jobject = jarray.get(1).getAsJsonObject();
            String result = jobject.get("entity").getAsString();
            return result;
            
        } catch (Exception e) {
    		String result = "Unknown";
    		return result;
    	}
    }
}