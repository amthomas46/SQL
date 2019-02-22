## Getting Java running in SQL Server

Please refer to the [documentation](https://docs.microsoft.com/en-us/sql/advanced-analytics/java/extension-java?view=sqlallproducts-allversions) for up-to-date instructions on how to call Java programs from SQL Server.  

In the **java-project** folder, I included some of the code I used to build this project. I used [Eclipse](https://www.eclipse.org/) as my IDE. The SentimentAnalysis sample contains the base [Cognitive Services sample for Java](https://docs.microsoft.com/en-us/azure/cognitive-services/Text-Analytics/QuickStarts/Java), and then some messing around on my part. The SentimentSample contains the actual code I used for this project.  

In the **linux-files** folder, I included the files that were put into my Linux VM (RHEL) and then called from SQL Server.

> **Important Note**: I have removed my Cognitive Services API key from all the files, so none of them will run if you take them as-is. You'll need to add your key, re-compile the Java project, and export as an executable JAR file (you can do this by right-clicking on the project in Eclipse).