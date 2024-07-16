-- Checking the details of my database table
 SELECT 
      [Order_ID]
      ,[Order_Date]
      ,[Ship_Date]
      ,[Ship_Mode]
      ,[Customer_ID]
      ,[Customer_Name]
      ,[Segment]
      ,[Country]
      ,[City]
      ,[State]
      ,[Postal_Code]
      ,[Region]
      ,[Product_ID]
      ,[Category]
      ,[Sub_Category]
      ,[Product_Name]
      ,[Sales]
      ,[Quantity]
      ,[Discount]
      ,[Profit]
  FROM [SuperstoreSalesAnalysis].[dbo].[Superstore ]


			--SALES PERFROMANCE ANALYSIS

--The product categories and the amount of sales generated
SELECT 
	Category, SUM(Sales) AS sales_generated
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	Category
ORDER BY 
	sales_generated DESC;

--The sales generated per state
SELECT 
	State, SUM(Sales) AS price_of_sales
FROM
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	State
ORDER BY 
	price_of_sales DESC;

--The top 10 customers with the highest sales volume
SELECT 
	TOP (10) [Customer_ID]
	Customer_name, Customer_ID, SUM(Quantity) AS quantity_purchased
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY
	Customer_name, Customer_ID
ORDER  BY 
	quantity_purchased DESC;

--Yearly sales trend
SELECT 
    LEFT(Order_date, 4) AS Year, SUM(Sales) AS Total_Sales
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
WHERE
	Order_date LIKE '2014%' 
	 OR Order_date LIKE '2015%' 
	 OR Order_date LIKE '2016%' 
	 OR Order_date LIKE '2017%'
GROUP BY
	LEFT([Order_date], 4);


			--	PROFITABILITY INSIGHTS

--Profit margins for categories
SELECT 
	Category, SUM(profit) AS profit_realised
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY  
	Category
ORDER BY 
	profit_realised DESC;

--Profitability per state
SELECT
	State, SUM(Profit) As profits_acquired
FROM
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	State
ORDER BY
	profits_acquired DESC;

--Products that are sold at a loss
SELECT
*
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
WHERE 
	profit < 0
ORDER BY
	PROFIT

--yearly profit trend
SELECT 
    LEFT(Order_date, 4) AS Year,
    SUM(Profit) AS Total_Profit
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
WHERE Order_date LIKE '2014%' 
		OR Order_date LIKE '2015%' 
		OR Order_date LIKE '2016%' 
		OR Order_date LIKE '2017%'
GROUP BY 
	LEFT([Order_date], 4);


			--CUSTOMER BEHAVIOR AND SEGMENTATION

--Customers with the highest sales
SELECT 
	TOP (10) [Customer_name]
	 Customer_name, Customer_ID, Segment, SUM(Sales) AS sales_made
FROM
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	Customer_name, Customer_ID, Segment
ORDER  BY
	sales_made DESC;

--The top 10 customers with the highest sales volume
SELECT
	TOP (10) [Customer_name]
	Customer_name, Customer_ID, SUM(Quantity) AS quantity_purchased
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	Customer_name, Customer_ID
ORDER  BY 
	quantity_purchased DESC;

--Customers with that made the highest profit
SELECT
	TOP (10) [Customer_name]
	 Customer_name, Customer_ID, SUM(Profit) AS profit_made
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	Customer_name, Customer_ID
ORDER  BY 
	profit_made DESC;

--Order value per segment
SELECT
Segment, AVG(Sales)  
FROM
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
Group By
	Segment;

--Order value per State
SELECT
	State, AVG(Sales) As order_value
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
Group By 
	State
Order by  
	order_value DESC;

--The return purchases for customers
SELECT 
    Customer_ID, COUNT(Order_ID) AS Total_Orders
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	Customer_ID
ORDER BY 
	Total_Orders DESC;

--Quantity sold per segment
SELECT
	Segment, SUM(Quantity) AS quantity_sold
FROM
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	Segment
Order By
	quantity_sold DESC;


			--Operational Efficiency

--Preferred shipping mode
SELECT
	Ship_mode, COUNT(Order_id) aS number_of_orders
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
Group By 
	ship_mode
order by
	number_of_orders DESC;

--Average shipment timeline per category
SELECT 
    Category, AVG (DATEDIFF(DAY, Order_Date, Ship_Date)) AS Days_To_Ship
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY
	Category

-- Indiviual shipment timeline
SELECT 
    Category, DATEDIFF(DAY, Order_Date, Ship_Date) AS Days_To_Ship
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY
	Category, Order_Date, Ship_Date
ORDER BY
	Days_To_Ship DESC;


			--	PRODUCT PERFORMANCE AND INVENTORY MANAGEMENT

--Best selling products per category
SELECT 
	Sub_Category, SUM(Quantity) As quantity_sold
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	Sub_Category
ORDER BY 
	quantity_sold DESC; 

--Highest sales per sub_category
SELECT 
Sub_Category, SUM(Sales) As sales_made
FROM
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	Sub_Category
ORDER BY 
	sales_made DESC; 

--Highest profits per sub_category
SELECT 
	Sub_Category, SUM(Profit) As profit_acquired
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	Sub_Category
ORDER BY
	profit_acquired DESC; 

--Products sales per region
SELECT
	Category,State, SUM(Quantity) As quantity_sold
FROM 
	[SuperstoreSalesAnalysis].[dbo].[Superstore]
GROUP BY 
	State, Category
ORDER BY
	quantity_sold DESC; 

--States highly ranked per units sold in each category

With Ranked_sales AS(
	SELECT Category, State, SUM(Quantity) AS quantity_Sold,
		ROW_NUMBER() OVER(PARTITION BY Category ORDER BY SUM(Quantity)DESC) AS Rank
	FROM
		[SuperstoreSalesAnalysis].[dbo].[Superstore]
	GROUP BY
		Category, State
)
		SELECT
			Category, State, Quantity_Sold
		FROM
			Ranked_Sales
		WHERE 
			Rank = 1 or Rank = 2 or Rank = 3
		ORDER BY 
			Category;

--States poorly ranked per units sold in each category
With Ranked_sales AS(
	SELECT Category, State, SUM(Quantity) AS quantity_Sold,
		ROW_NUMBER() OVER(PARTITION BY Category ORDER BY SUM(Quantity)) AS Rank
	FROM 
		[SuperstoreSalesAnalysis].[dbo].[Superstore]
	GROUP BY
		Category, State
)
		SELECT
			Category, State, Quantity_Sold
		FROM
			Ranked_Sales
		WHERE
			Rank = 1 or Rank = 2 or Rank = 3
		ORDER BY
			Category;


															--THE END