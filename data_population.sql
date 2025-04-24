# populate data

INSERT INTO Customers (CustomerID, FirstName, LastName, DOB, Email, RegistrationDate) VALUES
(NULL, 'Bob', 'Marley', '1945-02-06', 'bob@email.com', DATE_SUB(CURDATE(), INTERVAL 10 DAY)),
(NULL, 'Elvis', 'Presley', '1935-01-08', 'elvis@email.com', DATE_SUB(CURDATE(), INTERVAL 15 DAY)),
(NULL, 'Aretha', 'Franklin', '1942-03-25', 'aretha@email.com', DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(NULL, 'Jimi', 'Hendrix', '1942-11-27', 'jimi@email.com', DATE_SUB(CURDATE(), INTERVAL 30 DAY)),
(NULL, 'Freddie', 'Mercury', '1946-09-05', 'freddie@email.com', DATE_SUB(CURDATE(), INTERVAL 60 DAY)),
(NULL, 'Nina', 'Simone', '1933-02-21', 'nina@email.com', DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(NULL, 'Kurt', 'Cobain', '1967-02-20', 'kurt@email.com', DATE_SUB(CURDATE(), INTERVAL 100 DAY)),
(NULL, 'Amy', 'Winehouse', '1983-09-14', 'amy@email.com', DATE_SUB(CURDATE(), INTERVAL 200 DAY)),
(NULL, 'David', 'Bowie', '1947-01-08', 'bowie@email.com', CURDATE());


INSERT INTO Products (ProductID, ProductName, Description, Price, StockQuantity) VALUES
(NULL, 'Fender Stratocaster', 'Rock&Roll Guitar', 699.00, 6),
(NULL, 'Shure SM58', 'Dynamic Vocal Microphone', 99.00, 38),
(NULL, 'Focusrite Scarlett 2i2', '2-in/2-out USB Audio Interface', 199.99, 25),
(NULL, 'Boss Katana-50 Gen 3', '50W 1x12 Modeling Combo Amp', 299.99, 18),
(NULL, 'Fender Twin Reverb', 'Classic Tube Guitar Amplifier', 1499.99, 5),
(NULL, 'Shure SM57', 'Instrument/Vocal Dynamic Microphone', 99.00, 35),
(NULL, 'Boss DS-1', NULL, 59.99, 40),
(NULL, 'Audio-Technica AT2020', 'Cardioid Condenser Microphone', 99.00, 22),
(NULL, 'PreSonus AudioBox USB 96', '2x2 USB Audio Interface', 99.95, 30),
(NULL, 'Vox AC30 Custom', '30W Tube Guitar Combo Amp', 1349.00, 7),
(NULL, 'Fender Frontman 10G', '10W Practice Guitar Amp', 79.99, 33),
(NULL, 'Akai MPK Mini MK3', '25-Key USB MIDI Keyboard Controller', 119.00, 28),
(NULL, 'Ibanez Tube Screamer TS9', 'Overdrive Guitar Pedal', 99.99, 39),
(NULL, 'Yamaha HS5', 'Powered Studio Monitor (Single)', 199.99, 12),
(NULL, 'Fender Precision Bass', 'Classic Electric Bass Guitar', 899.99, 9),
(NULL, 'Sennheiser HD 280 Pro', 'Closed-Back Studio Headphones', 99.95, 26),
(NULL, 'Mogami Gold Instrument Cable', '10ft Guitar Cable', 44.95, 40),
(NULL, 'Hercules GS414B PLUS', 'Auto Grip Guitar Stand', 49.99, 31),
(NULL, 'Orange Micro Dark Head', '20W Hybrid Guitar Amp Head', 189.00, 14),
(NULL, 'TC Electronic Hall of Fame 2', 'Reverb Guitar Pedal', 149.00, 29),
(NULL, 'Universal Audio Apollo Twin X DUO', 'Thunderbolt Audio Interface Heritage Ed.', 999.00, 4);


INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(NULL, 5, DATE_SUB(NOW(), INTERVAL 5 DAY), 164.93), -- Freddie
(NULL, 5, NOW(), 59.99),                         -- Freddie
(NULL, 7, DATE_SUB(NOW(), INTERVAL 6 DAY), 99.00),  -- Kurt
(NULL, 1, DATE_SUB(NOW(), INTERVAL 1 MONTH), 743.95), -- Bob
(NULL, 6, DATE_SUB(NOW(), INTERVAL 6 YEAR), 99.00),  -- Nina
(NULL, 2, NOW(), 899.99),                         -- Elvis
(NULL, 3, DATE_SUB(NOW(), INTERVAL 2 DAY), 99.00),  -- Aretha
(NULL, 8, DATE_SUB(NOW(), INTERVAL 10 DAY), 99.95), -- Amy
(NULL, 9, DATE_SUB(NOW(), INTERVAL 1 DAY), 149.00), -- David
(NULL, 9, NOW(), 119.00),                         -- David
(NULL, 5, DATE_SUB(NOW(), INTERVAL 20 DAY), 199.99), -- Freddie
(NULL, 5, DATE_SUB(NOW(), INTERVAL 45 DAY), 99.99),  -- Freddie
# now add older orders
(NULL, 1, '2024-11-15 09:05:00', 99.00), 
(NULL, 4, '2024-11-28 14:15:20', 199.99),
(NULL, 2, '2024-12-05 11:00:00', 44.95), 
(NULL, 8, '2024-12-18 17:30:45', 299.85), 
(NULL, 5, '2025-01-05 10:00:00', 699.00), 
(NULL, 9, '2025-01-15 16:22:05', 99.99), 
(NULL, 3, '2025-01-25 12:00:00', 149.00), 
(NULL, 6, '2025-02-02 08:55:10', 59.99),  
(NULL, 1, '2025-02-14 19:01:50', 99.00),   
(NULL, 7, '2025-02-28 13:10:00', 299.99),  
(NULL, 4, '2025-03-05 11:45:00', 189.00),  
(NULL, 5, '2025-03-18 20:00:00', 99.98),  
(NULL, 9, '2025-03-28 09:12:15', 198.00);


INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, PricePerItem) VALUES
(NULL, 1, 7, 2, 59.99),  -- Order 1 (Freddie): 2x Boss DS-1
(NULL, 1, 17, 1, 44.95), -- Order 1 (Freddie): 1x Cable
(NULL, 2, 7, 1, 59.99),  -- Order 2 (Freddie): 1x Boss DS-1
(NULL, 3, 6, 1, 99.00),  -- Order 3 (Kurt): 1x SM57
(NULL, 4, 1, 1, 699.00), -- Order 4 (Bob): 1x Strat
(NULL, 4, 17, 1, 44.95), -- Order 4 (Bob): 1x Cable
(NULL, 5, 2, 1, 99.00),  -- Order 5 (Nina): 1x SM58
(NULL, 6, 15, 1, 899.99), -- Order 6 (Elvis): 1x P-Bass
(NULL, 7, 8, 1, 99.00),  -- Order 7 (Aretha): 1x AT2020
(NULL, 8, 16, 1, 99.95), -- Order 8 (Amy): 1x Headphones
(NULL, 9, 20, 1, 149.00), -- Order 9 (David): 1x Hall of Fame
(NULL, 10, 12, 1, 119.00), -- Order 10 (David): 1x MPK Mini
(NULL, 11, 3, 1, 199.99), -- Order 11 (Freddie): 1x Scarlett 2i2
(NULL, 12, 13, 1, 99.99), -- Order 12 (Freddie): 1x Tube Screamer
(NULL, 13, 6, 1, 99.00),    -- Order 13: 1x Shure SM57
(NULL, 14, 3, 1, 199.99),   -- Order 14: 1x Focusrite Scarlett 2i2
(NULL, 15, 17, 1, 44.95),   -- Order 15: 1x Mogami Cable
(NULL, 16, 16, 3, 99.95),   -- Order 16: 3x Sennheiser HD 280 Pro
(NULL, 17, 1, 1, 699.00),   -- Order 17: 1x Fender Stratocaster
(NULL, 18, 13, 1, 99.99),   -- Order 18: 1x Ibanez Tube Screamer
(NULL, 19, 20, 1, 149.00),  -- Order 19: 1x TC Hall of Fame 2
(NULL, 20, 7, 1, 59.99),    -- Order 20: 1x Boss DS-1
(NULL, 21, 8, 1, 99.00),    -- Order 21: 1x Audio-Technica AT2020 (Note: Using price 99.00)
(NULL, 22, 4, 1, 299.99),   -- Order 22: 1x Boss Katana-50
(NULL, 23, 19, 1, 189.00),  -- Order 23: 1x Orange Micro Dark
(NULL, 24, 18, 2, 49.99),   -- Order 24: 2x Hercules Stand
(NULL, 25, 6, 2, 99.00);    -- Order 25: 2x Shure SM57