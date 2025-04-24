
#now we start creating the online store database
CREATE TABLE Customers (
	CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DOB DATE NULL, #saying NULL means that we allow NULL, not enforce it
    Email VARCHAR(255) UNIQUE NOT NULL,
    RegistrationDate DATE NOT NULL DEFAULT(CURDATE()) #CURDATE gives the current date
) ENGINE = InnoDB;

CREATE TABLE Products (
	ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(255) NOT NULL,
    Description TEXT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0) NOT NULL,
    StockQuantity INT CHECK (StockQuantity >= 0) NOT NULL DEFAULT 0 
) ENGINE = InnoDB;

CREATE TABLE Orders (
	OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL REFERENCES Customers(CustomerID),
    OrderDate DATETIME NOT NULL DEFAULT(CURDATE()),
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount>=0)
) ENGINE = InnoDB;

CREATE TABLE OrderItems (
	OrderItemID INT NOT NULL PRIMARY KEY auto_increment,
    OrderID INT NOT NULL REFERENCES Orders(OrderID),
    ProductID INT NOT NULL REFERENCES Products(ProductID),
    Quantity INT NOT NULL CHECK (Quantity>0),
    PricePerItem DECIMAL(10,2) NOT NULL CHECK(PricePerItem >= 0)
) ENGINE = InnoDB;

# This table logs price changes
CREATE TABLE PriceLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT REFERENCES Products(ProductID),
    OldPrice DECIMAL(10, 2),
    NewPrice DECIMAL(10, 2),
    ChangeTimestamp DATETIME DEFAULT NOW()
) ENGINE=InnoDB;

# DESCRIBE Products;