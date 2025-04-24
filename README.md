# Online Store SQL Portfolio Project

## Introduction / Goal

This project demonstrates core and advanced SQL skills by designing, populating, and querying a relational database for a simple online store. The goal was to model customers, products, orders, and the relationships between them, and then extract meaningful insights using various SQL techniques learned in MySQL. This project covers data definition, data manipulation, querying (simple to complex), and database enhancements like views, indexes, and transactions.

## Technologies Used

* **Database:** MySQL (Community Server 8.0.x)
* **Client/IDE:** MySQL Workbench (Version 8.0.x)
* **SQL Concepts:**
    * Data Definition Language (DDL): `CREATE TABLE`, Constraints (PK, FK, UNIQUE, NOT NULL, CHECK, DEFAULT), `ALTER TABLE`, Data Types (`INT`, `VARCHAR`, `TEXT`, `DATE`, `DATETIME`, `DECIMAL`).
    * Data Manipulation Language (DML): `INSERT INTO`, `UPDATE`, `DELETE`.
    * Querying: `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, Joins (`INNER`, `LEFT`, Self Join), Aggregation (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `GROUP BY`, `HAVING`).
    * Advanced: Subqueries, Common Table Expressions (CTEs), Window Functions (`LAG`, `SUM`, `AVG`, `RANK`, `ROW_NUMBER` with `OVER()`, Frame Clauses), Views (`CREATE VIEW`), Indexes (`CREATE INDEX`, `EXPLAIN`), Transactions (`BEGIN`, `COMMIT`, `ROLLBACK`, `SET SQL_SAFE_UPDATES`, `LAST_INSERT_ID()`).
    * Functions: Date (`DATE_FORMAT`, `NOW`, `CURDATE`, `DATE_SUB`), String (`CONCAT`), Conditional (`CASE`).

## Schema Overview

The database consists of five main tables designed to capture the core entities and necessary logging:

* **`Customers`**: Stores information about registered customers.
    * `CustomerID` (PK): Unique identifier for each customer.
    * `FirstName`, `LastName`: Customer's name.
    * `DOB`: Date of birth.
    * `Email` (UNIQUE): Customer's unique email address.
    * `RegistrationDate`: When the customer registered.

* **`Products`**: Stores information about the items available for sale.
    * `ProductID` (PK): Unique identifier for each product.
    * `ProductName`: Name of the product.
    * `Description`: Detailed description.
    * `Price`: Current price of the product.
    * `StockQuantity`: Current number of units in stock.

* **`Orders`**: Stores information about individual orders placed by customers.
    * `OrderID` (PK): Unique identifier for each order.
    * `CustomerID` (FK): Links to the `Customers` table.
    * `OrderDate`: The date and time the order was placed.
    * `TotalAmount`: The total calculated amount for the order.

* **`OrderItems`**: A linking table detailing which products are included in which orders.
    * `OrderItemID` (PK): Unique identifier for each line item within an order.
    * `OrderID` (FK): Links to the `Orders` table.
    * `ProductID` (FK): Links to the `Products` table.
    * `Quantity`: The number of units of the specific product ordered.
    * `PricePerItem`: The price of the product at the time the order was placed.

* **`PriceLog`**: Stores a history of price changes for products (created for transaction example).
    * `LogID` (PK): Unique identifier for the log entry.
    * `ProductID` (FK): Links to the `Products` table.
    * `OldPrice`, `NewPrice`: The price before and after the change.
    * `ChangeTimestamp`: When the price change was logged.

**Relationships:**
* A `Customer` can place multiple `Orders`.
* An `Order` belongs to exactly one `Customer`.
* An `Order` can contain multiple `OrderItems`.
* A `Product` can be part of multiple `OrderItems`.
* Each `OrderItem` links one `Order` to one `Product`.
* `PriceLog` entries link to a `Product`.

*(See the `schema.sql` file for the complete DDL statements).*

## Database Setup Instructions

1.  Ensure you have MySQL Server installed and running.
2.  Connect to your MySQL instance using a client like MySQL Workbench (as `root` or another user with appropriate privileges).
3.  Create the database: `CREATE DATABASE onlinestore_db;`
4.  Select the database: `USE onlinestore_db;`
5.  Run the script in **`schema.sql`** to create all the tables and constraints.
6.  Run the script in **`data_population.sql`** to populate the tables with sample data.
7.  (Optional) Run the script in **`enhancements.sql`** to create the views and indexes.
8.  (Optional) Run the script in **`transactions.sql`** to execute the example transactions (note: these modify data).

## Queries & Analysis

This section showcases various SQL queries used to extract insights from the database. The full queries are in the **`queries.sql`** file.

*(Note: Keep the Query sections as drafted in the previous response (`model_36` or your edited version), ensuring the query code blocks are correctly formatted within the ```sql ... ``` markdown).*

**Example Query Structure:**

**1. Monthly Sales Trend**
* **Question:** What was the total sales amount for each month?
* **Technique:** `DATE_FORMAT`, `SUM`, `GROUP BY`, `ORDER BY`.
    ```sql
    -- Paste corrected SQL query here
    SELECT
        DATE_FORMAT(OrderDate, '%Y-%m') AS OrderMonth,
        SUM(TotalAmount) AS MonthlyTotal
    FROM Orders
    GROUP BY OrderMonth
    ORDER BY OrderMonth ASC;
    ```
*(Repeat this structure for all your analytical queries)*

## Enhancements

The following enhancements were implemented to improve usability and demonstrate advanced concepts. The code is in the **`enhancements.sql`** and **`transactions.sql`** files.

* **Views:** Created to simplify common complex queries.
    * `CustomerSpending`: Provides total amount spent per customer email.
        ```sql
        -- Paste CREATE VIEW CustomerSpending here...
        CREATE VIEW CustomerSpending AS
        SELECT c.Email, SUM(o.TotalAmount) AS TotalSpent
        FROM Customers c
        INNER JOIN Orders o ON c.CustomerID = o.CustomerID
        GROUP BY c.CustomerID, c.Email;
        ```
    * `NeverOrderedProducts`: Lists products never ordered.
        ```sql
        -- Paste CREATE VIEW NeverOrderedProducts here...
        CREATE VIEW NeverOrderedProducts AS
        SELECT p.ProductName
        FROM Products p
        LEFT JOIN OrderItems oi ON p.ProductID = oi.ProductID
        WHERE oi.ProductID IS NULL;
        ```

* **Indexes:** Added to common foreign key and filter columns to improve query performance (essential for larger datasets).
    ```sql
    -- Paste CREATE INDEX statements here...
    CREATE INDEX idx_orders_customerid ON Orders (CustomerID);
    CREATE INDEX idx_orderitems_orderid ON OrderItems (OrderID);
    CREATE INDEX idx_orderitems_productid ON OrderItems (ProductID);
    CREATE INDEX idx_products_author ON Products (Author); -- Example if relevant
    ```

* **Transactions:** Demonstrated atomic operations for placing an order, cancelling an order, and updating a price while logging, ensuring data integrity using `BEGIN`, `COMMIT`, `ROLLBACK`.
    ```sql
    -- Paste BEGIN...COMMIT block for placing an order here...
    BEGIN;
    INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES (NULL, 2, NOW(), 397.99);
    INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, PricePerItem) VALUES (NULL, LAST_INSERT_ID(), 3, 1, 199.99);
    INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, PricePerItem) VALUES (NULL, LAST_INSERT_ID(), 6, 2, 99.00);
    UPDATE Products SET StockQuantity = StockQuantity - 1 WHERE ProductID = 3;
    UPDATE Products SET StockQuantity = StockQuantity - 2 WHERE ProductID = 6;
    COMMIT;
    ```
    *(Consider adding the Cancel Order and Price Log transaction examples as well for completeness)*

## Conclusion

This project served as a practical application of various SQL concepts within a MySQL environment, covering database design, data manipulation, complex querying, and basic enhancements like views, indexes, and transactions.
