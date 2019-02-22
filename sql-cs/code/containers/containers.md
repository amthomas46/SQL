## Code to pull down and run the Cognitive Services container for Text Analytics Sentiment

Please refer [here](https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-install-containers) for complete and up-to-date instructions on how to do this. 

Once you have Docker set up on your device (follow the tutorial/references above), here are the two lines of code I ran in my Linux VM to get the container running:

```cmd
docker pull mcr.microsoft.com/azure-cognitive-services/sentiment:latest
```

Refer to the documentation reference above, but the above line pulls down the **sentiment** image from Azure Cognitive Services.  

Next, you have to actually run the container and set up billing. Make sure your Billing URL matches the one shown in the portal.

```cmd
docker run --rm -it -p 5000:5000 --memory 4g --cpus 1 mcr.microsoft.com/azure-cognitive-services/sentiment Eula=accept Billing=https://southcentralus.api.cognitive.microsoft.com/text/analytics/v2.0  ApiKey=YourApiKeyHere
```