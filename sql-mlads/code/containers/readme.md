## Code to pull down and run the Cognitive Services container for LUIS

Please refer [here](https://docs.microsoft.com/en-us/azure/cognitive-services/luis/luis-container-howto) for complete and up-to-date instructions on how to do this. 

First, you need to export your LUIS model and store it on the Linux VM, or wherever you intend on calling it. You'll first need to [create a LUIS model using luis.ai and import the model](https://docs.microsoft.com/en-us/azure/cognitive-services/luis/luis-how-to-start-new-app#import-an-app-from-file) I provided in the `luis-model` folder. Finally, [publish the model](https://docs.microsoft.com/en-us/azure/cognitive-services/luis/luis-how-to-publish-app). Leave this window open, as you'll need some of the pieces of information soon.  

From the machine that you have SQL Server running, you'll want to mount the model file. [Full instructions here](https://docs.microsoft.com/en-us/azure/cognitive-services/luis/luis-container-howto), but the basic command is below.

```cmd
curl -X GET \
https://{AZURE_REGION}.api.cognitive.microsoft.com/luis/api/v2.0/package/{APPLICATION_ID}/slot/{APPLICATION_ENVIRONMENT}/gzip  \
 -H "Ocp-Apim-Subscription-Key: {AUTHORING_KEY}" \
 -o {APPLICATION_ID}_{APPLICATION_ENVIRONMENT}.gz
 ```

Once you have Docker set up on your device (follow the tutorial/references above), here are the two lines of code I ran in my Linux VM to get the LUIS container running:
```cmd
docker pull mcr.microsoft.com/azure-cognitive-services/luis:latest
```

```cmd
docker run --rm -it -p 5000:5000 --memory 4g --cpus 1 mcr.microsoft.com/azure-cognitive-services/sentiment Eula=accept Billing=https://southcentralus.api.cognitive.microsoft.com/text/analytics/v2.0  ApiKey=YourApiKeyHere
```

Finally, in your LUIS Java code sample, you'll need to comment out the API call to the LUIS service, and add the host and port where you are running your container. 

> Note: If you're interested in the Text Analytics API, check my other resource folder under `sql-cs`.




_I apologize for the brevity of these instructions. If you'd like further assistance, let me know._