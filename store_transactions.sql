-- ==================================================================
-- Transaction Example 1: Placing a New Order (Customer 2)
-- ==================================================================
-- This transaction inserts an order, its items, and updates stock atomically.

BEGIN;

-- Step 1: Insert the main order record
-- TotalAmount = (1 * 199.99) + (2 * 99.00) = 397.99
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES (NULL, 2, NOW(), 397.99);

-- Step 2: Insert the first order item (Focusrite - ProductID 3)
-- Uses LAST_INSERT_ID() to get the OrderID generated above
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, PricePerItem)
VALUES (NULL, LAST_INSERT_ID(), 3, 1, 199.99);

-- Step 3: Insert the second order item (SM57s - ProductID 6)
-- LAST_INSERT_ID() still holds the correct OrderID for this transaction
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, PricePerItem)
VALUES (NULL, LAST_INSERT_ID(), 6, 2, 99.00);

-- Step 4: Update stock for ProductID 3
-- Note: Real applications should verify stock *before* this point within the transaction
UPDATE Products
SET StockQuantity = StockQuantity - 1
WHERE ProductID = 3;

-- Step 5: Update stock for ProductID 6
-- Note: Real applications should verify stock *before* this point within the transaction
UPDATE Products
SET StockQuantity = StockQuantity - 2
WHERE ProductID = 6;

-- Step 6: Commit if all steps succeeded
COMMIT;

-- ==================================================================
-- Transaction Example 2: Cancelling an Order (Order 3)
-- ==================================================================
-- This transaction deletes an order and its items, and restores product stock.

-- Informational Query (Run separately BEFORE the transaction to find details):
-- SELECT ProductID, Quantity FROM OrderItems WHERE OrderID = 3;
-- (Result showed ProductID 6, Quantity 1 needed restoring)

-- Temporarily disable safe update mode if needed for the DELETE FROM OrderItems
SET SQL_SAFE_UPDATES = 0;

BEGIN;

-- Step 1: Restore stock for items being cancelled (can be done anytime within transaction)
UPDATE Products
SET StockQuantity = StockQuantity + 1
WHERE ProductID = 6; -- Restoring 1 unit of ProductID 6

-- Step 2: Delete the order items first (due to Foreign Key constraints)
DELETE FROM OrderItems
WHERE OrderID = 3;

-- Step 3: Delete the order itself
DELETE FROM Orders
WHERE OrderID = 3;

-- Step 4: Commit if all steps succeeded
COMMIT;

-- Optional: Re-enable safe updates if desired for the rest of the session
-- SET SQL_SAFE_UPDATES = 1;

-- ==================================================================
-- Transaction Example 3: Updating Price with Audit Log (Product 2)
-- ==================================================================
-- This transaction updates a product's price AND logs the change.

-- Note: The CREATE TABLE PriceLog statement belongs in schema.sql
/*
CREATE TABLE PriceLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT REFERENCES Products(ProductID),
    OldPrice DECIMAL(10, 2),
    NewPrice DECIMAL(10, 2),
    ChangeTimestamp DATETIME DEFAULT NOW()
) ENGINE=InnoDB;
*/

BEGIN; -- Using standard uppercase

-- Step 1: Log the change (Using correct OldPrice from sample data)
INSERT INTO PriceLog (LogID, ProductID, OldPrice, NewPrice, ChangeTimestamp)
VALUES (NULL, 2, 99.00, 105.50, NOW()); -- Semicolon added

-- Step 2: Update the actual product price
UPDATE Products
SET Price = 105.50 -- Using consistent price value
WHERE ProductID = 2; -- Semicolon added

COMMIT; -- Using standard uppercase
-- ==================================================================