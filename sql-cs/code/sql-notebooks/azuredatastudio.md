## Running SQL Notebooks in Azure Data Studio

> **Important Note**: Using the SQL Kernel in notebooks is an insider build technically, not a stable release, but Azure Data Studio is open-source. Documentation and bugs fixes are not in. You can report any issues, bugs, or feedback [here](https://github.com/Microsoft/azuredatastudio/issues).

You can download Azure Data Studio (ADS) from [here](https://docs.microsoft.com/en-us/sql/azure-data-studio/download?view=sql-server-2017) on Windows, macOS, or Linux.  

Once installed, you'll want to go into the extension tab (looks just like VSCode because it's built on VSCode!). From there, you *should* have a recommended "SQL Server 2019 (Preview)" extension available. Install it and close and open ADS.

Next, select `CTRL` + `SHIFT` + `P` on Windows or `COMMAND` + `SHIFT` + `P` on macOS to open the command palette. From there, type `user settings` and select `Preferences: Open User Settings`.  

Search for `sql kernel` and use the pencil button on the left to change `"notebook.sqlKernelEnabled"` to `true`. Save the file. Then, close and open ADS.

Open ADS again. Next, open the "JavaLinuxCogServices.ipynb" file in this folder by selecting **File > Open Folder** and navigating to the folder you saved the notebook. It will prompt you to download some dependencies. Accept it and wait. It can take a few minutes. It should prompt you to reload, and you will need to open the file again.  

From there, you'll have to connect "Kernel" as "SQL" and attach it to a SQL Server instance that has the WWI database (I've included a bak in the sql folder).  

Now, you should be able to connect and run the cells in your SQL Server instance. I recommend just restoring the [WideWorldImporters dataset](https://github.com/Microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers), and then adding a simple table with some reviews or free-form text for sentiment analysis. Unfortunately, that isn't built in to the WWI set.

