USE StudentDemo;
GO

SELECT * FROM Student;
GO

SELECT Email, ClassID FROM Student s
INNER JOIN Class c ON s.StudentID = c.StudentID;
GO

INSERT INTO Student (StudentID, FirstName, LastName, Email, Age, Photo, Child)
VALUES (3, 'Jane', 'Doe', 'jane.doe@company.com', 42, NULL, 1);

SELECT Email, ClassID FROM Student s
LEFT OUTER JOIN Class c ON s.StudentID = c.StudentID
WHERE ClassID IS NOT NULL;
GO

SELECT DISTINCT Email FROM Student s
LEFT OUTER JOIN Class c ON s.StudentID = c.StudentID;
GO

SELECT Email, COUNT(ClassID) AS CourseCount FROM Student s
LEFT OUTER JOIN Class c ON s.StudentID = c.StudentID
GROUP BY Email;
GO

SELECT Email, (Age / 2) AS CalcField FROM Student;
GO

SELECT FirstName, LastName,
       ISNULL(LoginID, 'adventure-works\guest') AS UserName
FROM Person.Person p LEFT OUTER JOIN HumanResources.Employee e
ON p.BusinessEntityID = e.BusinessEntityID;
GO

SELECT 'Qty: ' + STR(OrderQty) FROM Production.WorkOrder
ORDER BY WorkOrderID;
GO

SELECT 'Qty: ' + TRIM(STR(OrderQty) + ' Pieces     '), LTRIM(STR(StockedQty)) FROM Production.WorkOrder
ORDER BY WorkOrderID;
GO

SELECT FirstName, LastName, EmailAddress,
       LEFT(EmailAddress, 4), RIGHT(EmailAddress, 3),
       SUBSTRING(EmailAddress, 1, 4)
FROM Person.Person p LEFT OUTER JOIN Person.EmailAddress e
ON p.BusinessEntityID = e.BusinessEntityID;
GO

SELECT FirstName, LastName, EmailAddress,
       SUBSTRING(EmailAddress, 1, CHARINDEX('@', EmailAddress) - 1)
FROM Person.Person p LEFT OUTER JOIN Person.EmailAddress e
ON p.BusinessEntityID = e.BusinessEntityID;
GO

SELECT FirstName, LastName, EmailAddress,
       SUBSTRING(EmailAddress, 1, PATINDEX('%[0-9]%', EmailAddress) - 1)
FROM Person.Person p LEFT OUTER JOIN Person.EmailAddress e
ON p.BusinessEntityID = e.BusinessEntityID;
GO

SELECT CONCAT(FirstName, ' ', LastName) AS FullName, EmailAddress
FROM Person.Person p LEFT OUTER JOIN Person.EmailAddress e
ON p.BusinessEntityID = e.BusinessEntityID
WHERE LEN(EmailAddress) >= 49;
GO

SELECT FirstName FROM Person.Person
WHERE CHARINDEX(' ', FirstName) > 0;

SELECT LEFT(FirstName, CHARINDEX(' ', FirstName) - 1),
       SUBSTRING(FirstName,
                CHARINDEX(' ', FirstName) + 1,
                CHARINDEX(' ', FirstName,
                    CHARINDEX(' ', FirstName) + 1) -
                CHARINDEX(' ', FirstName) + 1)
FROM Person.Person
WHERE CHARINDEX(' ', FirstName) > 0;

SELECT '123' AS String, CAST('123' AS INT) + 34 AS Number;
SELECT '123' AS String, CONVERT(INT, '123') + 34 AS Number;

SELECT CONCAT(CONVERT(VARCHAR, GETDATE(), 107), ' ',
       CONVERT(VARCHAR, GETDATE(), 14)) AS CurrentDate;

SELECT OrderDate FROM Purchasing.PurchaseOrderHeader
WHERE YEAR(OrderDate) = 2011 AND MONTH(OrderDate) BETWEEN 4 AND 12;

SELECT DATEPART(week, OrderDate) FROM Purchasing.PurchaseOrderHeader;

SELECT FirstName, IIF(FirstName = 'David', 'FOUND', '') AS DavidFound
FROM Person.Person
ORDER BY DavidFound DESC;

SELECT FirstName, IIF(FirstName = 'David', LastName, '') AS DavidFound
FROM Person.Person
ORDER BY DavidFound DESC;

SELECT FirstName,
       IIF(FirstName = 'David', IIF(LastName = 'Yang', LastName, ''), '') AS DavidFound
FROM Person.Person
ORDER BY DavidFound DESC;

SELECT FirstName,
       IIF(FirstName = 'David' AND LastName = 'Yang', LastName, '') AS DavidFound
FROM Person.Person
ORDER BY DavidFound DESC;

SELECT CHOOSE(EmailPromotion, 'Send Email', 'Snail Mail') AS Email
FROM Person.Person
WHERE EmailPromotion > 0;

SELECT OrderDate, MONTH(OrderDate),
        CHOOSE(MONTH(OrderDate),
            'Q1', 'Q1', 'Seminar', 'Q2', 'Q2', 'Q2',
            'Q3', 'Q3', 'Q3', 'Release', 'Q4', 'Q4')
        AS Quarters
FROM Sales.SalesOrderHeader
WHERE MONTH(OrderDate) > 8 AND MONTH(OrderDate) < 12
ORDER BY Quarters DESC;

SELECT CustomerID, StoreID,
       CASE StoreID
           WHEN 934 THEN 'HEAD'
           WHEN 1028 THEN 'REMOTE'
           ELSE ''
        END
FROM Sales.Customer
ORDER BY CustomerID;

SELECT CustomerID, StoreID,
       CASE
           WHEN StoreID > 500 AND StoreID < 1000 THEN 'HEAD'
           WHEN StoreID >= 1000 THEN 'REMOTE'
           ELSE ''
        END
FROM Sales.Customer
ORDER BY CustomerID;

SELECT COALESCE(Title, MiddleName, FirstName) AS PreferredName FROM Person.Person;
SELECT ISNULL(COALESCE(Title, MiddleName), 'No Preference') AS PreferredName FROM Person.Person;

SELECT OrderDate, TotalDue,
       (SELECT (SubTotal + TaxAmt + Freight) AS Total FROM Sales.SalesOrderHeader
        WHERE SalesOrderID = s.SalesOrderID) AS CalculatedTotal
FROM Sales.SalesOrderHeader s;

SELECT OrderDate, TotalDue, (SubTotal + TaxAmt + Freight) AS Total
FROM Sales.SalesOrderHeader s;

SELECT OrderDate,
       (SELECT AverageRate FROM Sales.CurrencyRate
           WHERE CurrencyRateID = s.CurrencyRateID)
FROM Sales.SalesOrderHeader s;

SELECT OrderDate, AverageRate FROM Sales.SalesOrderHeader s
LEFT JOIN Sales.CurrencyRate
ON s.CurrencyRateID = CurrencyRate.CurrencyRateID;

SELECT * FROM Person.Person
WHERE EXISTS(SELECT * FROM Sales.Customer WHERE PersonID = BusinessEntityID);
