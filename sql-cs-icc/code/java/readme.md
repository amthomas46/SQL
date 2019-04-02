## Getting Java running in SQL Server

Please refer to the [documentation](https://docs.microsoft.com/en-us/sql/advanced-analytics/java/extension-java?view=sqlallproducts-allversions) for up-to-date instructions on how to call Java programs from SQL Server.  

In the **java-project** folder, I included some of the code I used to build this project. I used [Eclipse](https://www.eclipse.org/) as my IDE. Once you add your Cognitive Services keys, you'll need to package the projects up, which you can do by exporting each project as a jar file. After you've done that, please refer to the docs on how to call/run it from SQL (as it is changing frequently). You can also check the SQL Notebook to see how I was able to do it with CTP 2.4.

> **Important Note**: I have removed my Cognitive Services API key from all the files, so none of them will run if you take them as-is. You'll need to add your key, re-compile the Java project, and export as an executable JAR file (you can do this by right-clicking on the project in Eclipse).