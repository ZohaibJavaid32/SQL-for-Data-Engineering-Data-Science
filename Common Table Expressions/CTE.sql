use SalesDB;


-- Step: 1 Find total sales per customer. 
-- Step: 2 Find the last order date for each customer. (Mutiple CTE)
-- Step: 3 Rank Customers based on Total Sales Per Customer. (Nested CTE)
-- Step: 4 Segment Customers Based on their Total Sales.
WITH CTE_Total_Sales AS
(
	SELECT
		CustomerID,
		SUM(Sales) AS Total_Sales
	FROM sales.Orders
	GROUP BY CustomerID
)
,  CTE_Last_Order AS
(
	SELECT 
		CustomerID,
		MAX(OrderDate) AS Last_Order 
	FROM sales.Orders
	GROUP BY CustomerID
)
, CTE_Customer_Rank AS
(
	SELECT 
		CustomerID,
		Total_Sales,
		RANK() OVER(ORDER BY Total_Sales) Customer_Rank
	FROM CTE_Total_Sales
)
, CTE_Customer_Segments AS 
(
	SELECT 
		CustomerID,
		CASE WHEN Total_Sales > 100 THEN 'High'
			 WHEN Total_Sales > 80 THEN	  'Medium'
		     ELSE 'Low'
		END CustomerSegments
	FROM CTE_Total_Sales
)



SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.Total_Sales,
	clo.Last_Order,
	ccr.Customer_Rank,
	ccs.CustomerSegments
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts 
	ON c.CustomerID = cts.CustomerID
LEFT JOIN CTE_Last_Order clo
	ON c.CustomerID = clo.CustomerID
LEFT JOIN CTE_Customer_Rank ccr
	ON c.CustomerID = ccr.CustomerID
LEFT JOIN CTE_Customer_Segments ccs
	ON ccs.CustomerID = c.CustomerID;


-- Generate a Sequence of Numbers between 1 and 20. (Recursive Query)

WITH Series AS 
(
    -- Anchor Query
	SELECT 
		1 AS MyNumber
	UNION ALL 
	-- Recurisve Query 
	SELECT 
		MyNumber + 1 
	FROM Series 
	WHERE MyNumber < 20
)

SELECT * 
FROM Series
OPTION (MAXRECURSION 1000); 


-- Show Employee hirarchy by showing each employee's level within organization.

WITH CTE_Emp_Hirarchy AS 
(
	--Anchor Query 
	SELECT 
		EmployeeID,
		FirstName,
		ManagerID,
		1 AS Level
	FROM Sales.Employees
	WHERE ManagerID IS NULL
	UNION ALL
	-- Recursive Query 
	SELECT 
		e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		Level + 1
	FROM Sales.Employees AS e
	INNER JOIN CTE_Emp_Hirarchy ceh 
		ON e.ManagerID = ceh.EmployeeID
)
SELECT * FROM CTE_Emp_Hirarchy;