CREATE database sakila;
USE  sakila;
create table Sales(Order_Number int, Customer_Key int,Store_Key int,Product_Key int	,
Line_Item int, Quantity int,Order_Date date, Delivery_Date date, Currency_Code varchar(15));
create table Stores(StoreKey int,Country varchar(30),State varchar(30),Square_Meters float,
Open_Date date);
CREATE TABLE ExchangeRates (
    Date DATE,
    Currency VARCHAR(3),
    Exchange FLOAT
);


select * from Sales;
select * from Product;
select * from Stores;
select * from ExchangeRates;
CREATE TABLE Product (
    ProductKey INT,
    UnitCostUSD FLOAT,
    UnitPriceUSD FLOAT,
    SubcategoryKey INT,
    ProductName VARCHAR(100),
    Brand VARCHAR(30),
    Color VARCHAR(30),
    Subcategory VARCHAR(40),
    Category VARCHAR(30)
);

ALTER TABLE Product
ADD COLUMN Profit DECIMAL(10,2);

describe Product;
select * from Customers;
create table Customers(CustomerKey int, ZipCode int, Gender varchar(8),	Name varchar(30),
City varchar(30),State varchar(25),Country varchar(30),	Continent varchar(30),Birthday date);
SHOW CREATE TABLE Customers;
ALTER TABLE Customers MODIFY State VARCHAR(50);
ALTER TABLE Customers MODIFY City VARCHAR(50);
alter table Product add column Profit decimal(10,2);
alter table Sales drop column Profit;
select *  from Product;
select * from Sales;
select * from customers;
select * from Stores;
select * from ExchangeRates;
-- SQL QUERIES  monthly sales trends over different years
SELECT 
    YEAR(Delivery_Date) AS Year,
    MONTH(Delivery_Date) AS Month,
    SUM(Quantity) AS TotalSales
FROM 
    Sales
GROUP BY 
    YEAR(Delivery_Date),
    MONTH(Delivery_Date)
ORDER BY 
    Year,
    Month;


SELECT
    Month,
    SUM(CASE WHEN Year = 2018 THEN TotalSales ELSE 0 END) AS Sales_2018,
    SUM(CASE WHEN Year = 2019 THEN TotalSales ELSE 0 END) AS Sales_2019,
    SUM(CASE WHEN Year = 2020 THEN TotalSales ELSE 0 END) AS Sales_2020,
    SUM(CASE WHEN Year = 2021 THEN TotalSales ELSE 0 END) AS Sales_2021
FROM (
    SELECT 
        YEAR(Delivery_Date) AS Year,
        MONTH(Delivery_Date) AS Month,
        SUM(Quantity) AS TotalSales -- Ensure 'Quantity' is the correct column for sales amount
    FROM 
        Sales
    GROUP BY 
        YEAR(Delivery_Date),
        MONTH(Delivery_Date)
) AS MonthlySales
GROUP BY 
    Month
ORDER BY 
    Month;

-- SQL QUERY BASED ON PRODUCT

SELECT 
    Category,
    AVG(UnitCostUSD) AS AverageUnitCost,
    AVG(UnitPriceUSD) AS AverageUnitPrice
FROM 
    Product
GROUP BY 
    Category;
--   Most Expensive and Cheapest Products

-- Most expensive product
SELECT 
    ProductName,
    UnitPriceUSD
FROM 
    Product
ORDER BY 
    UnitPriceUSD DESC
LIMIT 1;

-- Cheapest product
SELECT 
    ProductName,
    UnitPriceUSD
FROM 
    Product
ORDER BY 
    UnitPriceUSD ASC
LIMIT 1;

-- top 5 most expensive p roducts and least expensive products
(
    SELECT 
        'Most Expensive' AS PriceType,
        ProductName,
        UnitPriceUSD
    FROM 
        Product
    ORDER BY 
        UnitPriceUSD DESC
    LIMIT 10
)
UNION ALL
(
    SELECT 
        'Cheapest' AS PriceType,
        ProductName,
        UnitPriceUSD
    FROM 
        Product
    ORDER BY 
        UnitPriceUSD ASC
    LIMIT 5
);

-- SQL QUERIES FOR CUSTOMER
-- counting by gender
SELECT 
    Gender,
    COUNT(*) AS NumberOfCustomers
FROM 
    Customers
GROUP BY 
    Gender;
-- counting by country
SELECT 
    Country,
    COUNT(*) AS NumberOfCustomers
FROM 
    Customers
GROUP BY 
    Country;
-- Top 5 Countries with the Most Customers
SELECT 
    Country,
    COUNT(*) AS NumberOfCustomers
FROM 
    Customers
GROUP BY 
    Country
ORDER BY 
    NumberOfCustomers DESC
LIMIT 5;

-- AGE DISTRIBUTION OF CUSTOMERS

SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) < 20 THEN 'Under 20'
        WHEN TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) BETWEEN 21 AND 30 THEN '21-30'
        WHEN TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) BETWEEN 31 AND 40 THEN '31-40'
        WHEN TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) BETWEEN 41 AND 50 THEN '41-50'
        ELSE '51 and above'
    END AS AgeGroup,
    COUNT(*) AS NumberOfCustomers
FROM 
    Customers
GROUP BY 
    AgeGroup;
-- Customer Purchase Frequency
SELECT 
    Customer_Key,
    
    COUNT(Order_Number) AS NumberOfOrders,
    COUNT(DISTINCT DATE(Order_Date)) AS DaysActive
FROM 
    Sales
GROUP BY 
    Customer_Key
ORDER BY 
    NumberOfOrders DESC;


-- SQL Queries for Exchange rate by Currency
SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    Currency,
    AVG(Exchange) AS AverageExchangeRates
FROM 
    ExchangeRates
GROUP BY 
    YEAR(Date),
    MONTH(Date),
    Currency
ORDER BY 
    Year, Month, Currency;

