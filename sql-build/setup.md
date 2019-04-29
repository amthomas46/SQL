# setup

In this document, you'll find instructions on how to set up in order to be able to run through the Notebook in Azure Data Studio.  

> Note: These instructions assume basic experience with SQL Server, LUIS, Java, and Linux.

## 1: Deploy a SQL Server 2019 Big Data Cluster  

SQL Server 2019 Big Data Clusters are currently in a limited preview. You'll need to first sign up for the [Early Adoption Program (EAP) here](https://sqlservervnexteap.azurewebsites.net/). Within a few days, someone should reach out to you providing you information with how to get started.  

Once you receive the information from them, you can [use this quickstart to deploy a SQL Server Big Data Cluster](https://docs.microsoft.com/en-us/sql/big-data-cluster/quickstart-big-data-cluster-deploy?view=sqlallproducts-allversions). Don't forget to make sure you have the [required big data tools](https://docs.microsoft.com/en-us/sql/big-data-cluster/deploy-big-data-tools?view=sqlallproducts-allversions) first!  

Make sure you take note of the IP address and Port number for the SQL Server master instance, as well as the name of your Big Data Cluster.  

> Note: This takes some time to deploy, so you can continue to some of the other steps below while it's running.  

## 2: Sign up for the Cognitive Services used in the Azure portal

### Part A: Get an access key for the Text Analytics API

[Follow this guide](https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-access-key) to create a Text Analytics service in the Azure portal. You can use the free tier, but you won't be able to return results for all rows, as there is a limit for how many calls per second are permitted. If you want to return all the results, use the paid tier.  


### Part B: Get an access key for the LUIS API
In the same manner that you created a Text Analytics service and obtained the key, create a LUIS (Language Understanding Intelligent Service) service in the Azure portal and store the key.  

## 3: Clone or download the repository  

Clone the repository to the machine that you dpeloyed the cluster on / have Azure Data Studio running using `git clone https://github.com/amthomas46/SQL.git`. You can alternatively use the web interface to [download this repository](https://github.com/amthomas46/SQL). The folder relevant to these instructions is `sql-build`.  

## 4: Create, train, and publish your LUIS Model  

Next, you need to create, train, and publish your LUIS Model so you can call it in Java. Navigate to luis.ai and sign in using the same account you used in step 2 to create Azure resources.  

Once you're in, select "Create new app" and name it "DeliveryNotes", with culture set to English and an optional description.  

In the top right, select "MANAGE", and then in the left panel select "Versions". Next, select the "Import version" button and navigate to the `DeliveryNotes.json` file in this repository under **sql-build/code**. Name the version "0.2", and select "Done" to import the model. In the top right, you should now see a "Train" button with a red dot, select that to train the model. Then, select "Publish" and publish the model to the "Production" slot.  

Under "MANAGE" > "Keys and Endpoints", select the "Assign resource" button and add the LUIS service you created in step 2. Things you want to note for future reference:

- Authoring key
- Key 1 for the resource you just added (**not** the Stater Key Key 1)
- The location for the resource you just added (e.g. "centralus") (**not** the Starter Key location)  
- Under the "Application Information" tab on the left - the Application ID

Finally, select "Publish" again.  


## 5: Compile the Java applications

Ultimately, you need to add your respective keys/application information to the Sentiment Java program and the LUIS Java program. The Regex program doesn't require any keys and we've given the compiled `.jar` file to you.  

### Part A: Sentiment Sample

Using your Java IDE of choice (I use [eclipse](https://www.eclipse.org/downloads/)), you'll need to open the "Sentiment-noKeys" folder (from code folder), and then open the sentimentSample.java file and replace the part that says `YOURKEYHERE` with your Text Analytics API key. You'll also want to make sure the **region** in the host URL matches the region you deployed your Text Analytics API to. Save the file and compile the project. If you're using eclipse, you can right-click on the Sentiment folder, then select **Export > Runnable JAR file**. Set the Launch configuration to "Sentiment" and select an export location with the file ultimately being called "sentiment.jar". Be sure to check the box **Extract required libraries into generated JAR**.  

> Note: You may consider adding the jar file to the "code" folder that you cloned in Step 3. That will make your life easier later.

### Part B: LUIS Sample

In a similar manner, open the "LUIS-noKeys" folder (from code folder) in eclipse (or whatever you're using). You'll need to update the `appId` to match your LUIS application ID. You'll also need to replace the `accessKey` with your Key 1 from your LUIS application (see step 4 for details). Finally, if the location of your LUIS service in Azure is different from `centralus`, you'll need to update the `host` URL as well. Save the file. Compile the jar (details in Part A).  

## 6: Update the YAML file with your LUIS information  

In your cloned repository, under the code folder, open the `luis-cognitive-service.yaml` file with your favorite text ediotr and replace "YourAppIdHere" with your LUIS application ID (there are two occurrences), "YourKey1Here" with your Key 1, and "YourAuthoringKey" with your LUIS Authoring key. Refer to step 4 with details regarding how to find this information. Finally, make sure the region in the URL after `Billing` matches the region that you deployed your Azure service (it currently is set to `centralus`).  Save the YAML file.  

## 7: Move the files into the SQL Server Big Data Cluster master instance

In order to access the JARs, the YAML file, and restore our database into the cluster, we first have to move those files into the cluster. We can do that by using `kubectl cp` commands.   

Before we get into the terminal commands, unzip the `WideWorldImporters-201945-18-5-13.7z` using [7zip](WideWorldImporters-201945-18-5-13) so the .bak file is in the code folder directly.  

Now, open a terminal, and walk through the following steps.  

Navigate to the code folder of this repository in your local (may not be exact depending where you cloned the repository to).
```cmd
cd C:\Users\<user>\SQL\sql-build\code
```

Next, copy over the files that we'll need into the cluster.
```cmd
kubectl cp luis-cognitive-service.yaml <clusterName>/master-0:/home -c mssql-server
kubectl cp regex.jar <clusterName>/master-0:/home -c mssql-server
kubectl cp sentiment.jar <clusterName>/master-0:/home -c mssql-server
kubectl cp luis.jar <clusterName>/master-0:/home -c mssql-server
kubectl cp mssql_java_lang_extension.jar <clusterName>/master-0:/home -c mssql-server
kubectl cp WideWorldImporters-201945-18-5-13.bak <clusterName>/master-0:/var/opt/mssql/data -c mssql-server
```

If you want to confirm that your files are there, you can bash in to the cluster and check the /home folder contents and the /var/opt/mssql/data contents.
```cmd
kubectl exec master-0 --namespace <clusterName> -c mssql-server -it -- /bin/bash
```

## 8: Restore the modified WideWorldImporters database into the SQL Server master instance

Finally, we need to load data to analyze into the cluster. Note that this is a slightly modified database than the standard Wide World Importers set, so you have to use the .bak provided.  

Using SSMS or Azure Data Studio (or other methods you prefer), restore the database into your SQL Server Big Data Cluster.  

## 9: Open the Notebook in Azure Data Studio and get connected

In step 1, you should have installed Azure Data Studio and the SQL Server 2019 extension. If you didn't, go back and do that first.   

If this is your first time using Azure Data Studio, you may be prompted to add a new connection. If you aren't, select the "Connections" tab on the left panel, and select the "New Connection" button from the "Servers" pane in Azure Data Studio. Leave the defaults (i.e. SQL Server connection, SQL Login). For "Server", put the IP address of your master instance followed by `,31433`. Provide your SQL username and password for authentication. You should receive some confirmation that you're connected.  

Next, you need to open the repository folder within Azure Data Studio. This is similar to how you would open a folder in VSCode, if you're familiar with that. Else, select **File > Open Folder** and navigate to the `sql-build` folder in your local.  

Finally, open the `build.ipynb` file from within Azure Data Studio by selecting "Explorer" on the left panel and then the Notebook file. If this is your first time using Notebooks in Azure Data Studio, it may do some loading of things and then ask you to Reload Azure Data Studio.  

Once you're able to see the notebook, you'll need to connect it to your SQL Server master instance, by selecting the drop-down next to "Attach to" at the top of the Notebook.  

## Closing  

You're now ready (finally) to walk through the Notebook. There are additional steps within it, but the guidance in the Notebook should be enough.

> Tip: You'll have to update the LUIS Java program, recompile it, and move it into the cluster at a later point in the Notebook. You may want to leave the terminal and eclipse open.  

There are a lot of set up steps required, and some of them are non-trivial. This is a very 'light' guide, so if you run in to issues, try stackoverflow or filing an issue in this repository. 

