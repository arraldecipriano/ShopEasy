-- AdventureWorksDW2022 bak file, downloaded from https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms
-- Updated the file using this script https://github.com/techtalkcorner/SampleDemoFiles/blob/master/Database/AdventureWorks/Update_AdventureWorksDW_Data.sql
-- Selected all columns I wanted, transformed the data and exported the query results as CSV files in order to create a Power BI dashboard

-- Calendar table
SELECT
	DateKey,
	FullDateAlternateKey AS Date, -- Date column
	EnglishDayNameOfWeek AS Day, -- Day Column
	EnglishMonthName AS Month, -- Month column
	LEFT(EnglishMonthName, 3) AS MonthShort, 
	-- Another month column, diplayed as Jan, Feb, Mar, etc
	MonthNumberOfYear AS MonthN, -- Month column, displayed as  number
	CalendarQuarter AS Quarter, -- Quarter of year column
	CalendarYear AS Year -- Year column
FROM DimDate
WHERE
	CalendarYear >= 2021; -- Filtering out all years previous to 2021

--------------------------------------------------------------------

-- Customer table
SELECT
	c.CustomerKey AS CustomerKey, -- CustomerKey column from DimCustomer
	c.FirstName FirstName, -- FirstName column from DimCustomer
	c.LastName LastName, -- LastName column from DimCustomer
	c.FirstName + ' ' + LastName AS FullName, 
	-- FullName column, concatenating FirstName and LastName from DimCustomer 
	CASE
		c.Gender WHEN 'M' THEN 'Male'
				 WHEN 'F' THEN 'Female'
	END AS Gender, 
	-- Reformating the Gender column using a CASE expression
	c.DateFirstPurchase AS FirstPurchaseDate,
	g.City AS CustomerCity
FROM DimCustomer AS c -- Aliasing the table for easy reference
	LEFT JOIN DimGeography AS g
		ON g.GeographyKey = c.GeographyKey 
		-- Joining the two tables on GeographyKey column
ORDER BY
	CustomerKey ASC; -- Ascending order by CustomerKey

--------------------------------------------------------------------

-- Products table
SELECT
	p.ProductKey, -- ProductKey column (primary key)
	p.ProductAlternateKey AS ProductItemCode, -- ProductItemName column
	p.EnglishProductName AS ProductName, -- ProductName column
	ps.EnglishProductSubcategoryName AS ProductSubCategory, -- ProductSubCategory column
	pc.EnglishProductCategoryName AS ProductCategory, -- ProductCategory column
	p.Color AS ProductColor, -- ProductColor column
	p.Size AS ProductSize, -- ProductSize column
	p.ProductLine AS ProductLine, -- ProductLine column
	p.ModelName AS ProductModel, -- ProductModel column
	p.EnglishDescription AS ProductDescription, -- ProductDescription column
	ISNULL(p.Status, 'Outdated') AS ProductStatus 
	-- ProductStatus column, replacing NULL values with 'Outdated'
FROM DimProduct AS p
LEFT JOIN DimProductSubcategory AS ps
	ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS pc
	ON ps.ProductSubcategoryKey = pc.ProductCategoryKey
ORDER BY
	p.ProductKey ASC;

--------------------------------------------------------------------

-- Sales table
SELECT
	ProductKey,
	OrderDateKey,
	DueDateKey,
	ShipDateKey,
	CustomerKey,
	SalesOrderNumber,
	SalesAmount
FROM FactInternetSales
WHERE
	LEFT(OrderDateKey, 4) >= YEAR(GETDATE()) - 3 
	-- Used this to filter out dates before the year 2021. YEAR(GETDATE()) 
	-- gets current year and substract 2 from it. 2024 - 3 = 2021
ORDER BY
	OrderDateKey ASC;

--------------------------------------------------------------------