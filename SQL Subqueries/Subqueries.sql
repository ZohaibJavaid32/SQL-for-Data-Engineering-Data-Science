use SalesDB;


-------------------------- Subqueries in FROM Clause ------------------------------
-- Find product that have the price higher than the average price of all products.

SELECT *
FROM(
	SELECT 
	ProductID,
	Price,
	AVG(Price) OVER() AvgPrice
	FROM sales.Products) AS t            -- necessary to give Alias IN SQL Server.
WHERE price > AvgPrice;


-- Rank Customers Based On Total Amount of Sales

SELECT *,
RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
FROM
(
	SELECT 
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
	) AS t


-------------------------- Subqueries in SELECT Clause ------------------------------

-- Show productID , names , prices and total number of orders.

SELECT 
	ProductID,
	Product,
	price,
	(SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders  -- Only Scalar Subquery is allowed here.
FROM sales.Products;



-------------------------- Subqueries in JOIN Clause ------------------------------

-- show all customer details and find total orders of each customer.

SELECT 
	c.*,
	o.TotalOrders
FROM sales.customers c
LEFT JOIN
(
	SELECT 
		customerID, 
		COUNT(OrderID) AS TotalOrders 
	FROM sales.orders
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID;

-------------------------- Subqueries in WHERE Clause ------------------------------

-- Find products having price higher than the average price of all products.

SELECT
	ProductID, 
	Price
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products);


-------------------------- Subqueries in IN Operator ------------------------------

-- show details of orders made by customers in Germany

SELECT *
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany');


-------------------------- Subqueries in ANY Operator ------------------------------

-- Find female employees with salaries greater than male employees
SELECT * FROM Sales.Employees
WHERE Gender = 'F' 
AND Salary > ANY(SELECT Salary FROM Sales.Employees WHERE Gender = 'M');


-------------------------- Subqueries in ALL Operator ------------------------------

-- find female employees whose salaries are greated than every male employees.

SELECT * FROM Sales.Employees
WHERE Gender = 'F' 
AND Salary > ALL(SELECT Salary FROM Sales.Employees WHERE Gender = 'M');


