/*
This script came from Erin Stellato. I created none of it :-)

1. Command palette (CTRL + SHIFT + P)
    Theme to get to color theme
        download additional themes from the extenion gallery (e.g. Atom One Dark Theme, HCQ (High Color Queries))
    Keyboard shortcuts
        can also click on settings gear to get there
        customize shortcuts to something else
        download the SSMS Keymap extension to map them to be the same as SSMS
         ALT + selection to edit multiple lines at once in SSMS … 
            use alt-shift-left_mouse in ADS/VS Code

2. Command Terminal
    From View menu, or CTRL + `
    Can use sqlcmd (and the new sqlcmd), powershell, etc.
        winget install sqlcmd
        sqlcmd --help
        sqlcmd query "SELECT name FROM sys.databases" 
        

3. Connections view
    Have some already registered
        note recent connections vs saved connections
    Create groups and color code
    Azure
        connect to account
        view different subscriptions
        create connection

4. Object Explorer
    Group by schema
    Create new table

5. Open a folder of scripts

5. Query editor
    New query
    Write a query, have ability to use Intellisense; have snippets also, CREATE and then snippets pop up
    Result set, can save as CSV, excel, JSON, XML, etc.
    Go to explorer, view timeline, file save history
    Execution Plans
        Estimated vs. actual
        Top Operations
        Compare plans

6. Notebooks
    Create new notebook
    Export existing text and queries as new notebook
    Jupyter book - a bunch of notebooks gathered together

7. Deployment (menu has moved to File -> New Deployment!)
    SQL, Azure DB, etc.

8. Source control
    GitHub integration
    Codespaces
    Schema compare

9. Extension marketplace
    Query History - Query History is initially as a tab in the tab panel, which is toggled by the View: Toggle Panel or Query History: Focus on Query History View command
    Sanddance - visualizer 
        SELECT *
        FROM WideWorldImportersB.Sales.Orders
    Additional data platforms - PG, MySQL, Kusto
    sql projects; schema compare!
    Profiler
    Flat file import
    Admin pack
    Agent


*/
