-- Advanced Query Challenge #1: Monthly Sales Trend
-- Goal: Calculate the total sales amount (TotalAmount from the Orders table) for each month.
-- Output: Display the month (in 'YYYY-MM' format) and the corresponding total sales amount
-- for that month. Order the results chronologically by month.

SELECT
    DATE_FORMAT(OrderDate, '%Y-%m') AS OrderMonth, -- Using '%Y-%m' for 4-digit year
    SUM(TotalAmount) AS MonthlyTotal
FROM
    Orders
GROUP BY
    OrderMonth -- Group by the alias defined in SELECT (MySQL allows this)
ORDER BY
    OrderMonth ASC; -- Explicit ASC for chronological order

-- ----------------------------------------------------------

-- Exercise: Show the highest order amount for each month
-- (Based on user's previous query "Exercise 2")

SELECT
    DATE_FORMAT(OrderDate, '%Y-%m') AS OrderMonth, -- Using '%Y-%m' for consistency
    MAX(TotalAmount) AS MaxOrderAmountInMonth -- Changed MAX to uppercase, better alias
FROM
    Orders
GROUP BY
    OrderMonth -- Group by month to find the max within that month
ORDER BY
    OrderMonth ASC; -- Order chronologically

-- ----------------------------------------------------------

-- Orders Table Query Challenge #1: Basic Order Statistics
-- Goal: Calculate a few overall statistics for all the orders in the table.
-- Output: Display three values in a single row: TotalOrders, GrandTotalSales, AverageOrderValue.

SELECT
    COUNT(OrderID) AS TotalOrders,        -- Changed Count to COUNT
    SUM(TotalAmount) AS GrandTotalSales, -- Added space before AS
    AVG(TotalAmount) AS AverageOrderValue  -- Changed avg to AVG
FROM
    Orders;

-- ----------------------------------------------------------

-- Orders Table Query Challenge #2: Specific Period Orders
-- Goal: Find the OrderID and TotalAmount for all orders placed during January 2025.
-- Output: List the OrderID and TotalAmount for matching orders. Order by TotalAmount highest first.

SELECT
    OrderID,
    TotalAmount
FROM
    Orders
WHERE
    OrderDate BETWEEN '2025-01-01 00:00:00' AND '2025-01-31 23:59:59'
    -- could also use this (less efficient): DATE_FORMAT(OrderDate, '%Y-%m') = '2025-01'
	-- or this:
    -- WHERE OrderDate >= '2025-01-01 00:00:00' AND OrderDate < '2025-02-01 00:00:00'
ORDER BY
    TotalAmount DESC;

-- ----------------------------------------------------------

-- JOIN Query Challenge: Total Quantity Sold Per Product
-- Goal: Calculate the total quantity sold for each product across all orders.
-- Output: Display ProductName and TotalQuantitySold, ordered highest first.

SELECT
    p.ProductName,
    SUM(oi.Quantity) AS TotalQSold
FROM
    Products p
INNER JOIN
    OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY
    p.ProductID, p.ProductName -- Corrected: Group by PK and selected non-aggregated column for standard compliance
ORDER BY
    TotalQSold DESC; -- Added missing ORDER BY clause from original challenge requirement

-- ----------------------------------------------------------
-- Query: Calculate Month-over-Month Sales Growth Percentage
-- Purpose: Calculates the percentage change in total sales amount
--          (from the Orders table) compared to the previous month.
-- Techniques: CTEs, DATE_FORMAT, SUM/GROUP BY, LAG Window Function, CASE.

WITH MonthlySalesData AS (
    -- CTE 1: Aggregate total sales for each month (formatted as 'YYYY-MM').
    SELECT
        DATE_FORMAT(OrderDate, '%Y-%m') AS OrderMonth,
        SUM(TotalAmount) AS MonthlySales
    FROM
        Orders
    GROUP BY
        OrderMonth -- Group by the calculated month alias (supported in MySQL)
),
SalesWithLag AS (
    -- CTE 2: Retrieve monthly sales from CTE 1 and add the previous month's
    -- sales using the LAG() window function.
    SELECT
        msd.*, -- Select all columns from the previous CTE (OrderMonth, MonthlySales)
        LAG(MonthlySales, 1, NULL) OVER (ORDER BY OrderMonth ASC) AS PreviousMonthSales
        -- LAG looks back 1 row based on OrderMonth order. NULL default for the first month.
    FROM
        MonthlySalesData msd
)
-- Final SELECT: Calculate the percentage change using data from the SalesWithLag CTE.
SELECT
    OrderMonth,
    MonthlySales,
    PreviousMonthSales,
    CASE
        -- Handle cases where previous month data is unavailable or zero to avoid errors.
        WHEN PreviousMonthSales IS NULL OR PreviousMonthSales = 0 THEN NULL
        -- Standard percentage change formula: ((Current - Previous) / Previous) * 100
        ELSE (MonthlySales - PreviousMonthSales) * 100.0 / PreviousMonthSales
    END AS MoM_Growth_Percent -- Alias for the final calculated column
FROM
    SalesWithLag -- Query data from the second CTE
ORDER BY
    OrderMonth ASC; -- Display results chronologically

-- ----------------------------------------------------------
