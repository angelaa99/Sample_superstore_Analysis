SELECT *
FROM [Portfolio Project]..SuperstoreSales

--> Objective of the study: Understand which products, regions, categories and customer segments they should target or avoid

--> 1. What are the top 10 selling products in the superstore?

SELECT [Product Name], SUM(Sales) AS Sales
FROM [Portfolio Project]..SuperstoreSales
GROUP BY [Product Name]
ORDER BY Sales DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

--> 2. What are the top 10 profitable products in the superstore?

SELECT [Product Name], SUM(Profit) AS Profit
FROM [Portfolio Project]..SuperstoreSales
GROUP BY [Product Name]
ORDER BY Profit DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

-- Conclusion: The best selling and highest profitable products are Canon imageCLASS 2200 Advanced Copier and Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind

-- 3. Which product category is the best selling and the most profitable?
SELECT Category, SUM(Sales) AS Sales
FROM [Portfolio Project]..SuperstoreSales
GROUP BY Category
ORDER BY Sales DESC;

SELECT Category, SUM(Profit) AS Profit
FROM [Portfolio Project]..SuperstoreSales
GROUP BY Category
ORDER BY Profit DESC;
-- Conclusion: We noticed that Technology has contributed the highest sales and is the most profitable followed by Office Supplies,
-- but furniture has the generated higher sales than office supplies, although the profit is much lower than office supplies.

--> 4. Which Sub-category of products is the best selling and the most profitable?

SELECT [Sub-Category], SUM(Sales) AS Sales
FROM [Portfolio Project]..SuperstoreSales
GROUP BY [Sub-Category]
ORDER BY Sales DESC
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY;

SELECT [Sub-Category], SUM(Profit) AS Profit
FROM [Portfolio Project]..SuperstoreSales
GROUP BY [Sub-Category]
ORDER BY Profit DESC
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY;

-- Conclusion: Copiers is the most profitable, but phones is the best selling.

--> 5. Find in which region has sell the best and make most profit with the product:
-- 'Canon imageCLASS 2200 Advanced Copier'

SELECT DISTINCT Region, Country, COUNT(Region) AS 'Number of Stores'
FROM [Portfolio Project]..SuperstoreSales
GROUP BY Region, Country
-- The superstore located at four regions in United States respectively

SELECT Region, ROUND(AVG(Sales),2) AS Sales, ROUND(AVG(Profit),2) AS Profit
FROM [Portfolio Project]..SuperstoreSales
WHERE [Product Name] = 'Canon imageCLASS 2200 Advanced Copier'
GROUP BY Region
ORDER BY Sales DESC, Profit 

-- 'Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind'

SELECT Region, ROUND(AVG(Sales),2) AS Sales, ROUND(AVG(Profit),2) AS Profit
FROM [Portfolio Project]..SuperstoreSales
WHERE [Product Name] = 'Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind'
GROUP BY Region
ORDER BY Sales DESC, Profit 

-- It is observed that Profit in Central Region is negative, let's find out:

SELECT Region, ROUND(SUM(Sales),2) AS Sales, Discount, Quantity, ROUND(SUM(Profit),2) AS Profit
FROM [Portfolio Project]..SuperstoreSales
WHERE [Product Name] = 'Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind'
AND Region = 'Central'
GROUP BY Region, Discount, Quantity
ORDER BY Sales, Profit

-- The company loss when selling the product Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind
-- in Central as it makes 80% discount on 9 out of 12 quantity sold (i.e., 75%)

--> 6. Which region generates the most sales and profit?

SELECT Region, ROUND(SUM(Sales),2) AS Sales, ROUND(SUM(Profit),2) AS Profit
FROM [Portfolio Project]..SuperstoreSales
GROUP BY Region
ORDER BY Sales DESC, Profit DESC

-- The region in which generate the most sales are ranked West, East, Central and South respectively
-- However, Central region has the lowest profit as it makes a lot of big discount to its products sold

SELECT Region, ROUND(SUM(Sales),2) AS Sales, ROUND(SUM(Profit),2) AS Profit
FROM [Portfolio Project]..SuperstoreSales
GROUP BY Region
ORDER BY Profit DESC

--> 7. Which state generates the most sales and profit?

SELECT State, ROUND(SUM(Sales),2) AS Sales
FROM [Portfolio Project]..SuperstoreSales
GROUP BY State
ORDER BY Sales DESC

SELECT State, ROUND(SUM(Profit),2) AS Profit
FROM [Portfolio Project]..SuperstoreSales
GROUP BY State
ORDER BY Profit DESC

-- Conclusion: The state California and New York respectively earn the most profit, however Texas is ranked third of most sales generated,
-- but it ranked at the last of most profit due to a lot of discounts have been given. Please refer to below:

SELECT State, ROUND(SUM(Sales),2) AS Sales, Discount, SUM(Quantity) AS Quantity, ROUND(SUM(Profit),2) AS Profit
FROM [Portfolio Project]..SuperstoreSales
WHERE State = 'Texas'
GROUP BY State, Discount
ORDER BY Sales DESC, Profit

--> 8. What is the average profit margin for each product category?
SELECT Category, ROUND(AVG(Sales),2) AS Sales, ROUND(AVG(Profit),2) AS Profit, ROUND(AVG(Profit)/AVG(Sales),2) AS Margin
FROM [Portfolio Project]..SuperstoreSales
GROUP BY Category
ORDER BY Margin DESC

-- Conclusion: Office Supplies, Technology and Furniture respectively is the ranking for the average profit margin.

--> 9. Customers and Sales per segment

SELECT Segment, ROUND(COUNT(*) *100.0 / SUM(COUNT(*)) OVER(),2) AS SegmentPercent
FROM [Portfolio Project]..SuperstoreSales
GROUP BY Segment
ORDER BY SegmentPercent DESC

SELECT Segment, ROUND(SUM(Sales),2) AS Sales,
ROUND(SUM(Sales)/(SELECT SUM(Sales) FROM [Portfolio Project]..SuperstoreSales),2) AS SalesSegment
FROM [Portfolio Project]..SuperstoreSales
GROUP BY Segment
ORDER BY SalesSegment DESC

-- Conclusion: Consumer is the superstore's biggest customer segment and sales customer, followed by corporate and home office

--> 10. Creating view to store data for visualization

CREATE VIEW SampleSuperstoreSalesAnalysis AS
SELECT Segment, Country, State, Region, Category, [Sub-Category], [Product Name], Sales, Quantity, Discount, Profit
FROM [Portfolio Project]..SuperstoreSales