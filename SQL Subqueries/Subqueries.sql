use SalesDB;

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
