/*New query
    Write a query, have ability to use Intellisense; have snippets also, CREATE and then snippets pop up
    Result set, can save as CSV, excel, JSON, XML, etc.
    Go to explorer, view timeline, file save history
    Execution Plans
        Estimated vs. actual
        Top Operations
        Compare plans
        */
SELECT ProductID, 
  SUM(LineTotal) AS TotalsOfLine, 
  SUM(UnitPrice) AS TotalsOfPrice, 
  SUM(UnitPriceDiscount) AS TotalsOfDiscount
FROM SalesLT.SalesOrderDetail SOrderDet
INNER JOIN SalesLT.SalesOrderHeader SalesOr ON SOrderDet.SalesOrderID = SalesOr.SalesOrderID
WHERE PurchaseOrderNumber LIKE 'PO%'
GROUP BY ProductID

