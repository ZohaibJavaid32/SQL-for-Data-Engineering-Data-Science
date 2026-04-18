use SalesDB;


---------------------------------- ROW_NUMBER, ROW , DENSE_RANK 
SELECT 
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRank_Row,
	RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank,
	DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_DenseRank
FROM Sales.Orders;


-- Find top highest sales for each product.

SELECT * 
FROM 
(
	SELECT 
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
	FROM sales.Orders) t
WHERE RankByProduct = 1;

-- Lowest 2 Customers based on total sales.

SELECT * 
FROM
(
	SELECT 
		CustomerID,
		SUM(Sales) TotalSales,
		ROW_NUMBER() OVER (ORDER BY SUM(Sales)) RankCustomers 
	FROM Sales.Orders
	GROUP BY CustomerID
) t
WHERE RankCustomers <=2;


-- Assign unique IDs to rows of order archive table.

SELECT 
	ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID,
	*
FROM Sales.OrdersArchive;

-- identify duplicates and return clean data.

SELECT * FROM 
(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
		* 
	FROM Sales.OrdersArchive
) t
WHERE rn = 1;


----------------------------- NTILE() ----------------------------

SELECT 
	OrderID,
	Sales,
	NTILE(4) OVER(ORDER BY Sales DESC) FourBucket,
	NTILE(3) OVER(ORDER BY Sales DESC) ThreeBucket,
	NTILE(2) OVER(ORDER BY Sales DESC) TwoBucket,
	NTILE(1) OVER(ORDER BY Sales DESC) OneBucket
FROM Sales.Orders


-- Segment Orders into 3 Categories : high , medium , low

SELECT *,
CASE WHEN Buckets = 1 THEN 'High'
	 WHEN Buckets = 2 THEN 'Medium'
	 WHEN Buckets = 3 THEN 'Low'
END SalesSegmentations
FROM
(
	SELECT 
		OrderID,
		Sales,
		NTILE(3) OVER(ORDER BY Sales DESC) Buckets
	FROM Sales.Orders
) t


-- Divide orders in 2 groups to export data

SELECT 
NTILE(2) OVER(ORDER BY OrderID) Buckets,
*
FROM Sales.Orders;


------------------------------- CUME_DIST() ----------------------------

-- find products with highest 40 percent of the prices.

SELECT *,
CONCAT(DistRank * 100 , '%') DistRankPercentage
FROM
(SELECT 
	product,
	Price,
	CUME_DIST() OVER (ORDER BY Price) DistRank
FROM Sales.Products) t
WHERE DistRank <=0.4;


SELECT *,
CONCAT(DistRank * 100 , '%') DistRankPercentage
FROM
(SELECT 
	product,
	Price,
	PERCENT_RANK() OVER (ORDER BY Price) DistRank
FROM Sales.Products) t
WHERE DistRank <=0.4;


