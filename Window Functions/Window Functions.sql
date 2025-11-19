use SalesDB;

-- Total sales across all orders
SELECT SUM(Sales) FROM sales.Orders;


-- Total sales for each product.


SELECT ProductID,
	   SUM(sales) as TotalSales
FROM sales.Orders
GROUP BY ProductID;


-- Total sales for each product with order id and order date

-- GROUP BY will not work here becuase it will destroy our aggregations. So Window functions comes into action.

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	SUM(sales) OVER(PARTITION BY ProductID) as TotalSalesByProduct
FROM sales.Orders;


-- Total sales across all orders.
-- Total Sales across each products.
-- Additionally  provide order id , order date

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	sales,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct
FROM sales.Orders


-- Total sales for each combo of product and order status

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	SUM(sales) OVER(PARTITION BY ProductID) as SalesByProduct,
	SUM(sales) OVER(PARTITION BY ProductID , OrderStatus) AS SalesByProductsAndStatus
FROM sales.Orders;


-- Rank each order based on sales from highest to lowest

SELECT 
	OrderID,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) AS RankedBySales
FROM sales.Orders



-------------------- Frame Clause --------------------

SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	SUM(sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales
FROM Sales.Orders

-- NOTE : Order by always uses Frame clause


-- Ranks customers by total sales (usage of GROUP BY and Window Funcs)

-- S-1 --> GROUP BY 
-- S-2 --> Window Functions
SELECT 
	CustomerID,
	SUM(sales) AS TotalSales,
	RANK() OVER(ORDER BY SUM(sales) DESC) RankCustomers
FROM sales.Orders
GROUP BY CustomerID;



SELECT * FROM sales.Orders;



SELECT 
    CustomerID,
    Sales,
    ROW_NUMBER() OVER(ORDER BY Sales DESC) AS RowNum,
    RANK() OVER(ORDER BY Sales DESC) AS SalesRank,
    DENSE_RANK() OVER(ORDER BY Sales DESC) AS DenseSalesRank,
    NTILE(4) OVER(ORDER BY Sales DESC) AS SalesQuartile,
    ROUND(PERCENT_RANK() OVER(ORDER BY Sales DESC), 3) AS PercentRankVal,
    ROUND(CUME_DIST() OVER(ORDER BY Sales DESC), 3) AS CumeDistVal
FROM sales.Orders;
