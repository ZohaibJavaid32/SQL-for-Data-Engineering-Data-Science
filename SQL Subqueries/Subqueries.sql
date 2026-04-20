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


