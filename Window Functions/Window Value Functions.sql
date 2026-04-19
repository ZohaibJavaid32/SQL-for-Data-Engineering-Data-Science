use SalesDB;

-- Analyze month-over-month performance by finding percentage change in sales between
-- current and previous months.

SELECT 
*,
CurrentMonthSales - PreviousMonthSales AS MoMChange,
ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)/PreviousMonthSales * 100 ,2) AS Mom_Percentage
FROM (
	SELECT 
		MONTH(OrderDate) OrderMonth,
		SUM(Sales) CurrentMonthSales,
		LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PreviousMonthSales
	FROM sales.Orders
	GROUP BY MONTH(OrderDate)
) t


-- Rank Customer Loyality by ranking customers based on average days between their orders.

SELECT 
	CustomerID, 
	AVG(DaysUntilNextOrder) AvgDays,
	RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder),99999)) RankAvg
FROM
(
	SELECT OrderID,
		   CustomerID,
		   OrderDate CurrOrder,
		   LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
		   DATEDIFF(day, OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
	FROM sales.Orders
) t
GROUP BY CustomerID;



-------------------------- FIRST_VALUE() / LAST_VALUE() ----------------------

-- Find highest and lowest sales.

SELECT 
	OrderId,
	ProductId,
	OrderDate,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductId ORDER BY Sales ASC)  LowestSales,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductId ORDER BY Sales  
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales
FROM Sales.Orders;

