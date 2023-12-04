set schema 'distributionsystem';

-- Delete all rows and restart the serial sequences for all tables
TRUNCATE TABLE Comment,Review,orderitem,receipt,product,"order",customer,farmer,"user" RESTART IDENTITY;

-- Insert dummy data into "user" table
INSERT INTO "user" (phonenumber, password) VALUES
('0000', '0000'),
('12345', '12345'),
('farmer', '0000'),
('cust', '0000'),
('1111','1111');

-- Insert dummy data into Farmer table
INSERT INTO Farmer (phonenumber, firstname, lastname, address, pestecides, farmName, rating) VALUES
('0000', 'John', 'Doe', 'Dapper', true, 'Dapper Dell', 4.5),
('farmer', 'Jane', 'Smith', 'Farm', false, 'Krusty Krab', 3.8),
('1111', 'Marnie', 'Lewis', 'Cindersap Forest', true, 'Marnie"s Ranch', 3.8);

-- Insert dummy data into Customer table
INSERT INTO Customer (phonenumber, firstname, lastname, address) VALUES
('12345', 'Alice', 'Johnson', 'Via'),
('cust', 'Bob', 'Williams', 'Kamtjatka');

-- Insert dummy data into "order" table
INSERT INTO "order" (orderGroup, status, "date", customerID) VALUES
(1, 'Pending', '2023-12-03', '12345'),
(2, 'Shipped', '2023-12-02', 'cust');

-- Insert dummy data into Product table
INSERT INTO Product (availability, amount, "type", price, pickedDate, expirationDate, farmerID) VALUES
(true, 100, 'Potato', 5.99, '2023-12-01', '2024-01-01', '0000'),
(true, 500, 'Potato', 3.49, '2023-11-30', '2023-12-03', 'farmer'),
(true, 75, 'Tomato', 2.49, '2023-12-01', '2023-12-15', '0000'),
(true, 90, 'Leek', 1.99, '2023-12-03', '2023-12-12', 'farmer'),
(true, 80, 'Corn', 2.79, '2023-12-01', '2023-12-10', 'farmer'),
(true, 70, 'Corn', 1.59, '2023-12-04', '2023-12-20', '0000'),
(true, 50, 'Onion', 2.29, '2023-12-05', '2023-12-22', 'farmer'),
(true, 80, 'Cabbage', 2.49, '2023-12-02', '2023-12-18', '0000'),
(true, 70, 'Cucumber', 1.59, '2023-12-03', '2023-12-12', 'farmer'),
(true, 90, 'Tomato', 2.79, '2023-12-04', '2023-12-20', 'farmer'),
(true, 60, 'Leek', 3.29, '2023-12-05', '2023-12-22', '0000'),
(true, 100, 'Apples', 4.99, '2023-12-06', '2023-12-25', 'farmer'),
(true, 80, 'Mushrooms', 3.99, '2023-12-08', '2023-12-28', 'farmer'),
(true, 60, 'Cherries', 5.99, '2023-12-09', '2023-12-24', '0000'),
(true, 70, 'Onion', 1.79, '2023-12-10', '2023-12-26', 'farmer'),
(true, 90, 'Pumpkin', 3.49, '2023-12-11', '2023-12-29', '0000'),
(true, 100, 'Strawberries', 6.99, '2023-12-12', '2023-12-31', 'farmer'),
(true, 75, 'Carrot', 2.49, '2023-12-13', '2023-12-15', '0000'),
(true, 85, 'Beetroot', 1.89, '2023-12-14', '2023-12-17', 'farmer'),
(true, 80, 'Potato', 1.29, '2023-12-15', '2023-12-31', '1111'),
(true, 70, 'Cabbage', 2.99, '2023-12-16', '2023-12-30', '1111'),
(true, 60, 'Cucumber', 3.49, '2023-12-17', '2023-12-28', '1111'),
(true, 50, 'Tomato', 1.79, '2023-12-18', '2023-12-25', '1111'),
(true, 90, 'Leek', 4.99, '2023-12-19', '2023-12-24', '1111'),
(true, 85, 'Apples', 2.29, '2023-12-20', '2023-12-29', '1111'),
(true, 75, 'Corn', 2.79, '2023-12-21', '2023-12-26', '1111'),
(true, 65, 'Mushrooms', 3.99, '2023-12-22', '2023-12-22', '1111'),
(true, 80, 'Cherries', 1.79, '2023-12-23', '2023-12-27', '1111'),
(true, 70, 'Onion', 4.99, '2023-12-24', '2023-12-28', '1111'),
(true, 90, 'Pumpkin', 2.29, '2023-12-14', '2023-12-20', '1111'),
(true, 100, 'Strawberries', 2.79, '2023-12-26', '2023-12-31', '1111'),
(true, 75, 'Carrot', 3.99, '2023-12-27', '2023-12-31', '1111');

-- Insert dummy data into Receipt table
INSERT INTO Receipt (orderID, processed, status, price, paymentMethod, paymentDate, text, farmerID, customerID) VALUES
(1, false, 'Pending', 5.99, 'Credit Card', '2023-12-03', 'Payment pending for Order 1', '0000', '12345'),
(2, true, 'Accepted', 3.49, 'PayPal', '2023-12-02', 'Payment received for Order 2', 'farmer', 'cust');

-- Insert dummy data into OrderItem table
INSERT INTO OrderItem (orderID, productID, amount) VALUES
(1, 1, 20),
(2, 2, 10);

-- Insert dummy data into Review table
INSERT INTO Review (text, star, farmerID, customerID, orderId) VALUES
('Great products!', 5.0, '0000', '12345', 1),
('Fast shipping!', 4.0, 'farmer', 'cust', 2);

-- Insert dummy data into Comment table
INSERT INTO Comment (text, farmerID, customerID,orderid, username) VALUES
('I love the vegetables from Dapper Dell!', '0000', '12345',1 ,'12345'),
('The fruit quality from Krusty Krab is excellent!', 'farmer', 'cust',2 ,'cust');
