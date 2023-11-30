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

create table Review(
    text varchar(50),
    star double precision,
    farmerID varchar(50) references Farmer(phonenumber),
    customerID varchar(50) references Customer(phonenumber),
    primary key (farmerID,customerID)
);

create table Comment(
    commentID serial primary key,
    text varchar(100),
    farmerID varchar(50),
    customerID varchar(50),
    FOREIGN KEY (farmerID,customerID) references review(farmerid,customerid)
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

/*
create or replace function avl()
    returns TRIGGER
    language plpgsql
as
    $$
    declare
        prod int;
        am int;
    begin
        prod=new.productid;
        am= new.amount;
        if am<=0 then
            update product set availability=false where productid=prod;
        end if;

        /*update product set availability=false where new.expirationDate>now() and productid=prod;*/
        return new;
    end;
    $$;

create or replace trigger changeAvl
    after update
    on product
    for each row
    execute function avl();

update product set amount=0 where productID=1;

 */

 CREATE OR REPLACE FUNCTION update_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.amount <= 0 THEN
        NEW.availability := FALSE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_availability
BEFORE UPDATE ON Product
FOR EACH ROW
EXECUTE FUNCTION update_availability();
