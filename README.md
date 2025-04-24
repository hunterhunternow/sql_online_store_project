# Online Store SQL Portfolio Project

## Introduction / Goal

This project demonstrates core and advanced SQL skills by designing, populating, and querying a relational database for a simple online store using MySQL. The goal was to model customers, products, orders, and the relationships between them, and then extract meaningful insights using various SQL techniques. This project covers data definition, data manipulation, complex querying, and transaction management.

## Technologies Used

* **Database:** MySQL (Community Server 8.0.x)
* **Client/IDE:** MySQL Workbench (Version 8.0.x)
* **SQL Concepts Demonstrated:**
    * Data Definition Language (DDL): `CREATE TABLE`, Constraints (PK, FK, UNIQUE, NOT NULL, CHECK, DEFAULT), `ALTER TABLE`, Data Types.
    * Data Manipulation Language (DML): `INSERT INTO`, `UPDATE`, `DELETE`.
    * Querying: `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, Joins (`INNER`, `LEFT`), Aggregation (`COUNT`, `SUM`, `AVG`, `MAX`, `GROUP BY`).
    * Advanced: Subqueries, Common Table Expressions (CTEs), Window Functions (`LAG` with `OVER()`), Transactions (`BEGIN`, `COMMIT`, `ROLLBACK`, `SET SQL_SAFE_UPDATES`, `LAST_INSERT_ID()`).
    * Functions: Date (`DATE_FORMAT`, `NOW`, `CURDATE`, `DATE_SUB`), Conditional (`CASE`).
    * (Syntax for Views and Indexes was practiced but not implemented as separate project enhancements in this version).

## Schema Overview

The database consists of five main tables designed to capture the core entities and necessary logging:

* **`Customers`**: Stores information about registered customers (ID, Name, DOB, Email, Registration Date).
* **`Products`**: Stores information about items for sale (ID, Name, Description, Price, Stock).
* **`Orders`**: Stores header information about customer orders (ID, Customer Link, Date, Total Amount).
* **`OrderItems`**: Linking table detailing which products are included in which orders (ID, Order Link, Product Link, Quantity, Price at time of order).
* **`PriceLog`**: Stores a history of price changes for products (created for transaction example).

**Relationships:**
* A `Customer` can place multiple `Orders` (One-to-Many).
* An `Order` belongs to one `Customer`.
* An `Order` contains multiple `OrderItems` (One-to-Many).
* A `Product` can be in multiple `OrderItems`.
* Each `OrderItem` links one `Order` to one `Product` (resolving the Orders-Products Many-to-Many relationship).
* `PriceLog` entries link to one `Product`.

*(See the `schema.sql` file for the complete DDL statements).*

## Database Setup Instructions

1.  Ensure you have MySQL Server installed and running.
2.  Connect to your MySQL instance using a client like MySQL Workbench (as `root` or another user with appropriate privileges).
3.  Create the database: `CREATE DATABASE onlinestore_db;`
4.  Select the database: `USE onlinestore_db;`
5.  Run the script in **`schema.sql`** to create all the tables and constraints.
6.  Run the script in **`data_population.sql`** to populate the tables with sample data.
7.  (Optional) Execute the example transactions found in **`transactions.sql`** (note: these modify data).

*(The analytical queries are available for reference in `queries.sql`)*.

## Queries & Analysis

This section showcases various SQL queries used to extract insights from the database. The full queries are in the **`queries.sql`** file.

**1. Monthly Sales Trend**
* **Question:** What was the total sales amount for each month?
* **Technique:** `DATE_FORMAT`, `SUM`, `GROUP BY`, `ORDER BY`.
    ```sql
    SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS OrderMonth, SUM(TotalAmount) AS MonthlyTotal
    FROM Orders GROUP BY OrderMonth ORDER BY OrderMonth ASC;
    ```

**2. Highest Order Amount Per Month**
* **Question:** What was the highest single order amount in each month?
* **Technique:** `DATE_FORMAT`, `MAX`, `GROUP BY`, `ORDER BY`.
    ```sql
    SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS OrderMonth, MAX(TotalAmount) AS MaxOrderAmountInMonth
    FROM Orders GROUP BY OrderMonth ORDER BY OrderMonth ASC;
    ```

**3. Basic Order Statistics**
* **Question:** What are the total number of orders, total sales value, and average order value overall?
* **Technique:** Basic aggregate functions (`COUNT`, `SUM`, `AVG`).
    ```sql
    SELECT COUNT(OrderID) AS TotalOrders, SUM(TotalAmount) AS GrandTotalSales, AVG(TotalAmount) AS AverageOrderValue
    FROM Orders;
    ```

**4. Specific Period Orders (Jan 2025)**
* **Question:** Which orders (ID and amount) were placed in January 2025, ordered by highest amount?
* **Technique:** `WHERE` clause with date range filtering (`BETWEEN`), `ORDER BY`.
    ```sql
    SELECT OrderID, TotalAmount FROM Orders
    WHERE OrderDate BETWEEN '2025-01-01 00:00:00' AND '2025-01-31 23:59:59'
    ORDER BY TotalAmount DESC;
    ```

**5. Total Quantity Sold Per Product**
* **Question:** How many units of each product have been sold in total across all orders?
* **Technique:** `INNER JOIN` (`Products`, `OrderItems`), `SUM()` aggregation, `GROUP BY` product, `ORDER BY`.
    ```sql
    SELECT p.ProductName, SUM(oi.Quantity) AS TotalQSold
    FROM Products p INNER JOIN OrderItems oi ON p.ProductID = oi.ProductID
    GROUP BY p.ProductID, p.ProductName ORDER BY TotalQSold DESC;
    ```

**6. Month-over-Month Sales Growth %**
* **Question:** What was the percentage growth in sales compared to the previous month?
* **Technique:** CTEs, `DATE_FORMAT`, `SUM`, `GROUP BY`, `LAG` Window Function, `CASE`.
    ```sql
    WITH MonthlySalesData AS (
        SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS OrderMonth, SUM(TotalAmount) AS MonthlySales
        FROM Orders GROUP BY OrderMonth
    ), SalesWithLag AS (
        SELECT msd.*, LAG(MonthlySales, 1, NULL) OVER (ORDER BY OrderMonth ASC) AS PreviousMonthSales
        FROM MonthlySalesData msd
    )
    SELECT OrderMonth, MonthlySales, PreviousMonthSales,
           CASE WHEN PreviousMonthSales IS NULL OR PreviousMonthSales = 0 THEN NULL
                ELSE (MonthlySales - PreviousMonthSales) * 100.0 / PreviousMonthSales
           END AS MoM_Growth_Percent
    FROM SalesWithLag ORDER BY OrderMonth ASC;
    ```

## Transaction Examples

The **`transactions.sql`** file contains examples demonstrating how to use `BEGIN`, `COMMIT`, and `ROLLBACK` to ensure atomic operations for common tasks like placing an order, cancelling an order, and logging price changes.

```sql
-- Example: Placing an Order
BEGIN;
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES (NULL, 2, NOW(), 397.99);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, PricePerItem) VALUES (NULL, LAST_INSERT_ID(), 3, 1, 199.99);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, PricePerItem) VALUES (NULL, LAST_INSERT_ID(), 6, 2, 99.00);
UPDATE Products SET StockQuantity = StockQuantity - 1 WHERE ProductID = 3;
UPDATE Products SET StockQuantity = StockQuantity - 2 WHERE ProductID = 6;
COMMIT;
