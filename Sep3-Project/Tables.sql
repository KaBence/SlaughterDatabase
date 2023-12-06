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
    orderID int references "order"(orderID),
    primary key (farmerID,customerID,orderID)
);

create table Comment(
    commentID serial primary key,
    text varchar(100),
    farmerID varchar(50),
    customerID varchar(50),
    orderID int,
    username varchar(50) references "user"(phonenumber),
    FOREIGN KEY (farmerID,customerID,orderID) references review(farmerID,customerID,orderID)
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

-- Create a trigger function to update the farmer's rating
CREATE OR REPLACE FUNCTION update_farmer_rating()
RETURNS TRIGGER AS $$
BEGIN
    -- Calculate the new rating based on the average of stars in reviews
    UPDATE Farmer
    SET rating = (
        SELECT AVG(star)
        FROM Review
        WHERE farmerID = NEW.farmerID
    )
    WHERE phonenumber = NEW.farmerID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger that fires after an INSERT or UPDATE on the Review table
CREATE TRIGGER update_farmer_rating_trigger
AFTER INSERT OR UPDATE ON Review
FOR EACH ROW
EXECUTE FUNCTION update_farmer_rating();