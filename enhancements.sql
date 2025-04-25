-- ==========================================================================
-- Analytical Queries for Online Store Database
-- ==========================================================================

-- Query 1: Products over $100
-- Goal: List the ProductName and Price for all products that cost
--       more than $100. Order the results by price (highest first).
SELECT
    ProductName,
    ProductID,
    Price
FROM
    Products
WHERE
    Price > 100
ORDER BY
    Price DESC;

-- --------------------------------------------------------------------------

-- Query 2: Order Details with Customer Names
-- Goal: List the OrderID, OrderDate, and the FirstName and LastName
--       of the customer who placed each order.
SELECT
    o.OrderID,
    o.OrderDate,
    c.FirstName,
    c.LastName
FROM
    Orders o
INNER JOIN
    Customers c ON o.CustomerID = c.CustomerID; -- Join based on CustomerID

-- --------------------------------------------------------------------------

-- Query 3: Items in a Specific Order (OrderID 2)
-- Goal: List the ProductNames of all products included in OrderID 2.
SELECT
    p.ProductName
FROM
    Products p
INNER JOIN
    OrderItems oi ON p.ProductID = oi.ProductID -- Link products to order items
WHERE
    oi.OrderID = 2; -- Filter for the specific order

-- --------------------------------------------------------------------------

-- Query 4: Total Stock Quantity Per Product
-- Goal: Calculate the total StockQuantity available for each ProductName.
-- Note: Uses SUM() for practice, assumes stock might be tracked in multiple locations/batches per product name in a different schema.
SELECT
    ProductName,
    SUM(StockQuantity) AS TotalQuantity -- Calculate SUM per group
FROM
    Products
GROUP BY
    ProductName, ProductID -- Group by Name and PK for standard compliance
ORDER BY
    TotalQuantity DESC; -- Order by the calculated total quantity

-- --------------------------------------------------------------------------

-- Query 5: Total Spending Per Customer
-- Goal: Find the total amount spent by each customer. List the customer's Email
--       and their calculated TotalSpent. Order by total spent, highest first.
SELECT
    c.Email,
    SUM(o.TotalAmount) AS TotalSpent
FROM
    Customers c
INNER JOIN
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID, c.Email -- Group by unique customer identifiers
ORDER BY
    TotalSpent DESC;

-- --------------------------------------------------------------------------

-- Query 6: Products Never Ordered
-- Goal: Find the names (ProductName) of any products that have never been ordered.
-- Technique: LEFT JOIN finds all products, WHERE filters for those with no match in OrderItems.
SELECT
    p.ProductName
FROM
    Products p
LEFT JOIN
    OrderItems oi ON p.ProductID = oi.ProductID
WHERE
    oi.ProductID IS NULL; -- Keep rows where the right side of the join was NULL


-- ==========================================================================
-- Enhancements: Views
-- ==========================================================================
-- Views are stored SELECT queries that act like virtual tables,
-- primarily used to simplify complex query logic or control data access.

-- View 1: CustomerSpending
-- Goal: Show each customer's email and their total spending across all orders.
-- Then show the table sorted descending. 
CREATE VIEW CustomerSpending AS
SELECT
    c.Email,
    SUM(o.TotalAmount) AS TotalSpent
FROM
    Customers c
INNER JOIN
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID, c.Email;
	
SELECT * FROM CustomerSpending ORDER BY TotalSpent DESC;

-- View 2: NeverOrderedProducts
-- Goal: List the names of products that have never been ordered.
CREATE VIEW NeverOrderedProducts AS
SELECT
    p.ProductName
FROM
    Products p
LEFT JOIN
    OrderItems oi ON p.ProductID = oi.ProductID
WHERE
    oi.ProductID IS NULL;

SELECT * FROM NeverOrderedProducts;

-- ==========================================================================
-- Enhancements: Indexes
-- ==========================================================================
-- Indexes are created on table columns to speed up data retrieval operations
-- (SELECT queries, JOINs) at the cost of slightly slower data modification
-- (INSERT, UPDATE, DELETE) and extra storage space.

-- Index 1: On Orders table for Customer lookup
CREATE INDEX idx_orders_customerid ON Orders (CustomerID);

-- Index 2: On OrderItems table for Order lookup
CREATE INDEX idx_orderitems_orderid ON OrderItems (OrderID);

-- Index 3: On OrderItems table for Product lookup
CREATE INDEX idx_orderitems_productid ON OrderItems (ProductID);

-- ==========================================================================