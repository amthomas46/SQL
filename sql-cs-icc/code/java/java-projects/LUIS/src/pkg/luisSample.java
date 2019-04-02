package pkg;

// This sample uses the Apache HTTP client from HTTP Components (http://hc.apache.org/downloads.cgi)

// You need to add the following Apache HTTP client libraries to your project:
// httpclient-4.5.3.jar
// httpcore-4.4.11.jar
// commons-logging-4.0.6.jar

import java.net.URI;
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

class Document {
	public String id;
    public String text;

    public Document(String id, String text){
        this.id = id;
        this.text = text;
    }
}
class Documents {
    public List<Document> documents;

    public Documents() {
        this.documents = new ArrayList<Document>();
    }
    public void add(String id, String text) {
        this.documents.add (new Document (id, text));
    }
}

public class luisSample {
	
    //For local testing:
    public static String[] inputDataCol1 = new String[] { "1", "2", "3" };
    public static String[] inputDataCol2 = new String[] { "headed to houston from Detroit Sunday 12 PM", "from: new york. To: atlanta Day: Monday 3PM", "Seattle to san francisco tues 5pm" };

    public static boolean[][] inputNullMap = new boolean[1][1];
    //Required: Output data columns returned back to SQL Server
    public static String[] outputDataCol1;
    public static String[] outputDataCol2;
    public static String[] outputDataCol3;
    public static String[] outputDataCol4;
    public static String[] outputDataCol5;
    //Required: Output null map. Is populated with true or false values to indicate nulls
    public static boolean[][] outputNullMap;
    //Optional: This is only required if parameters are passed with @params
    // from SQL Server in sp_execute_external_script
    public static int numberOfRows ;    
    public static short numberOfOutputCols;
    // Replace the accessKey string value with your valid access key.
    static String accessKey = "YourKeyHere";    
    static String host = "https://YourLocationHere.api.cognitive.microsoft.com";
    //static String host = "http://172.16.1.4:5000";
    static String path = "/luis/v2.0/apps/";
    static String appId = "YourAppIdHere";

    
    //The method we will be calling from SQL Server
    public static void main(String[] args) {
    	analyzeSentence();
    }
    
    public static void analyzeSentence() {
        if (inputDataCol1.length == 0) {
            return;
        }
        //Using a stream to "loop" over the input data inputDataCol1.length. You can also use a for loop for this.
        final List<InputRow> inputDataSet = IntStream.range(0, inputDataCol1.length)
                .mapToObj(i -> new InputRow(inputDataCol1[i], inputDataCol2[i]))
                .collect(Collectors.toList());
        List<OutputRow> outputDataSet = new LinkedList<OutputRow>();
        //Since we don't have any null values, we will put all values in the outputNullMap to false
        inputDataSet.forEach(inputRow -> {
            String res = null;
            String resOrigin = null;
            String resDestination = null;
            String resDateTime = null;
			try {
				Documents documents = new Documents ();
	            documents.add(inputRow.id, inputRow.text);
				res = getEntities(documents);
				resOrigin = getFromLocation(res);
				resDestination = getToLocation(res);
				resDateTime = getDateTime(res);
			} catch (Exception e) {
				e.printStackTrace();
			}
            outputDataSet.add(new OutputRow(inputRow.id, inputRow.text, resOrigin, resDestination, resDateTime));
            
        });
        
        //Set the number of rows and columns we will be returning
        numberOfRows = outputDataSet.size(); 
        numberOfOutputCols = 5;

        outputDataCol1 = new String[numberOfRows]; // ID column
        outputDataCol2 = new String[numberOfRows];
        outputDataCol3 = new String[numberOfRows];
        outputDataCol4 = new String[numberOfRows]; 
        outputDataCol5 = new String[numberOfRows]; 
        outputNullMap = new boolean[numberOfOutputCols][numberOfRows];

        //Since we don't have any null values, we will put all values in the outputNullMap to false
        IntStream.range(0, numberOfRows).forEach(i -> {
            final OutputRow outputRow = outputDataSet.get(i);
            outputDataCol1[i] = outputRow.id;
            outputDataCol2[i] = outputRow.entry;
            outputDataCol3[i] = outputRow.origin;
            outputDataCol4[i] = outputRow.destination;
            outputDataCol5[i] = outputRow.datetime;
            
            outputNullMap[0][i] = false;
            outputNullMap[1][i] = false;
            outputNullMap[2][i] = false;
            outputNullMap[3][i] = false;
            outputNullMap[4][i] = false;
        });
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
        jobject = jarray.get(0).getAsJsonObject();
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
        jobject = jarray.get(1).getAsJsonObject();
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
        jobject = jarray.get(2).getAsJsonObject();
        String result = jobject.get("entity").getAsString();
        return result;
        
    } catch (Exception e) {
		String result = "Unknown";
		return result;
	}
    }
}