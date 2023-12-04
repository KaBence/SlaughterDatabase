drop schema if exists distributionsystem cascade ;

create schema DistributionSystem;

set schema 'distributionsystem';

create table "user"(
    phonenumber varchar(50) primary key,
    password varchar(50)
);

create table Farmer(
    phonenumber varchar(50) primary key references "user" (phonenumber),
    firstname varchar(50),
    lastname varchar(50),
    address varchar(50),
    pestecides bool,
    farmName varchar(50),
    rating double precision
);

create table Customer(
    phonenumber varchar(50) primary key references "user" (phonenumber),
    firstname varchar(50),
    lastname varchar(50),
    address varchar(50)
);

create table "order"(
    orderID serial primary key,
    orderGroup int,
    status varchar(50),
    "date" date,
    customerID varchar(50) references Customer(phonenumber)
);

create table Product(
    productID serial primary key,
    availability bool,
    amount double precision,
    "type" varchar(50),
    price double precision,
    pickedDate date,
    expirationDate date,
    farmerID varchar(50) references Farmer(phonenumber)
);

create table Receipt(
    orderID int references "order"(orderID),
    processed bool,
    status varchar(50),
    price double precision,
    paymentMethod varchar(50),
    paymentDate date,
    text varchar(100),
    farmerID varchar(50) references Farmer(phonenumber),
    customerID varchar(50) references Customer(phonenumber),
    primary key (orderID,farmerID,customerID,processed)
);

create table OrderItem(
    orderID int,
    productID int,
    amount double precision,
    primary key (orderID,productID),
    foreign key (orderID) references "order"(orderID),
    foreign key (productID) references Product(productID)
);

create table Review(
    text varchar(50),
    star double precision,
    farmerID varchar(50) references Farmer(phonenumber),
    customerID varchar(50) references Customer(phonenumber),
    orderId int references "order"(orderID),
    primary key (farmerID,customerID)
);

create table Comment(
    commentID serial primary key,
    text varchar(100),
    farmerID varchar(50),
    customerID varchar(50),
    username varchar(50) references "user"(phonenumber),
    FOREIGN KEY (farmerID,customerID) references review(farmerid,customerid)
);

 CREATE OR REPLACE FUNCTION update_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.amount <= 0 or new.expirationdate< current_date THEN
        NEW.availability := FALSE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_availability
BEFORE INSERT OR UPDATE ON Product
FOR EACH ROW
EXECUTE FUNCTION update_availability();

/*
select \"order\".orderID,p.productID,OrderItem.amount,p.type,p.price,f.farmName from orderitem join \"order\" o on o.orderID = orderitem.orderID join product p on orderitem.productID = p.productid join farmer f on f.phonenumber = p.farmerid where o.orderid=1;

select OrderItem.orderID,p.productID,orderitem.amount,p.type,p.price,farmName from orderitem join distributionsystem.product p on orderitem.productID = p.productid join distributionsystem.product p2 on orderitem.productID = p2.productid join distributionsystem.farmer f on f.phonenumber = p.farmerid join "order" o on o.orderID = orderitem.orderID where o.orderGroup=1;

/*
WITH RankedReceipts AS (
    SELECT
        orderID,
        farmerID,
        customerID,
        processed,
        status,
        price,
        paymentMethod,
        paymentDate,
        text,
        ROW_NUMBER() OVER (PARTITION BY orderID ORDER BY processed DESC) AS row_num
    FROM Receipt
)
SELECT
    orderID,
    farmerID,
    customerID,
    processed,
    status,
    price,
    paymentMethod,
    paymentDate,
    text
FROM RankedReceipts
WHERE row_num = 1 AND processed = false;

select * from receipt where customerid='0000' and orderID=(select orderID from "order" where orderGroup=322);

select * from receipt join "order" o on o.orderID = receipt.orderID where Receipt.customerID='0000' and o.orderGroup=322;

select o.orderID,p.productID,OrderItem.amount,p.type,p.price,f.farmName from orderitem
    join "order" o on o.orderID = orderitem.orderID
    join product p on orderitem.productID = p.productid
    join farmer f on f.phonenumber = p.farmerid
    where o.orderGroup=322;


insert into receipt (orderID, processed, status, price, paymentMethod, paymentDate, text, farmerID, customerID)
values ();
*/