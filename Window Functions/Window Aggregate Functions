USE SalesDB;


--------------------- COUNT() ----------------------

-- find total number of Orders.
-- find total number of orders by each customers.
-- provide details such as orderid , order date.
SELECT OrderID,
	   OrderDate,
	   CustomerID,
	   COUNT(*) OVER() TotalOrders,
	   COUNT(*) OVER(PARTITION BY CustomerID) OrdersByCustomers
FROM sales.Orders;



-- Find total customers. Provide all customer details.

SELECT *,
COUNT(*) OVER() TotalCustomers,
COUNT(1) OVER() TotalCustomerOne,
COUNT(Score) OVER() TotalScores,  -- data quality check.
COUNT(LastName) OVER() TotalLastName
FROM sales.Customers


-- check duplicate rows in orders table.

SELECT OrderID,
	   COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM sales.Orders;

SELECT * 
FROM (
	SELECT OrderID,
		   COUNT(*) OVER (PARTITION BY OrderID) CheckPK
	FROM sales.OrdersArchive
) t WHERE CheckPK > 1


--------------------- SUM() ----------------------

-- find total sales , total sales by each product , provide details.

SELECT OrderID,
	   OrderDate,
	   Sales,
	   ProductID,
	   SUM(Sales) OVER(PARTITION BY ProductID) SalesByProducts,
	   SUM(Sales) OVER() TotalSales
FROM sales.Orders;

-- find percentage contribution of each product's sales to the total sales.
SELECT OrderID,
	   ProductID,
	   Sales,
	   SUM(Sales) OVER() TotalSales,
	   ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() * 100 ,2) PercentageOfTotal
FROM sales.orders;

--------------------- AVG() ----------------------
-- Find avg sales , avg sales for each product
SELECT OrderID,
	   ProductID,
	   Sales,
	   AVG(Sales) OVER() AvgSales,
	   AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProduct
FROM sales.Orders;

-- Find Average Scores of Customers. Also find customerID and Last name.

SELECT CustomerID, 
	   Score,
	   LastName,
	   COALESCE(Score , 0) CustomerScore,
	   AVG(COALESCE(Score , 0)) OVER() AvgScoreWithoutNulls
FROM sales.Customers;

-- Find all orders where sales are higher than the avg sales across all orders.

SELECT * 
FROM
(SELECT OrderID,
	ProductID,
	Sales,
	AVG(sales) OVER() AvgSales
FROM sales.orders) t
WHERE sales > AvgSales;

-------------------------- MIN / MAX ----------------------

SELECT OrderID,
	   ProductID,
	   OrderDate,
	   Sales,
	   MIN(Sales) OVER() MinSales,
	   MAX(Sales) OVER() MaxSales,
	   MIN(Sales) OVER(PARTITION BY ProductID) MinSalesPerProduct,
	   MAX(Sales) OVER(PARTITION BY ProductID) MaxSalesPerProduct
FROM sales.Orders;

SELECT ProductID,MIN(Sales)
FROM sales.Orders
GROUP BY ProductID; 


-- Employees having highest salaries.

SELECT * 
FROM
(SELECT EmployeeID,
	   CONCAT(FirstName ,' ', LastName) AS FullName,
	   Salary,
	   MAX(Salary) OVER () HighestSalary
FROM sales.Employees) t
WHERE Salary = HighestSalary;


-- Find Deviation of each sales from  both highest and minimum sales

SELECT OrderID,
	   Sales,
	   MIN(Sales) OVER() MinSales,
	   MAX(Sales) OVER() MaxSales,
	   Sales - MIN(Sales) OVER() DeviationFromMin,
	   MAX(Sales) OVER() - Sales DeviationFromMax
FROM sales.Orders;


-- Calculate moving average of sales for each product over time.
-- Calculate moving average of sales for each product over time including next order.
SELECT OrderID,
	   ProductID,
	   OrderDate,
	   Sales,
	   AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	   AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	   AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) MovingAvg
FROM sales.Orders;



