drop schema if exists distributionsystem cascade ;

create schema DistributionSystem;

set schema 'distributionsystem';

create table "user"(
    phonenumber varchar(50) primary key,
    password varchar(50),
    active bool
);

create table Farmer(
    phonenumber varchar(50) primary key references "user" (phonenumber),
    firstname varchar(50),
    lastname varchar(50),
    address varchar(50),
    pestecides bool,
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
    farmerID varchar(50) references Farmer(phonenumber),
    customerID varchar(50) references Customer(phonenumber)
);

create table "order"(
    orderID serial primary key,
    status varchar(50),
    "date" date,
    customerID varchar(50) references Customer(phonenumber)
);

create table Product(
    productID serial primary key,
    availability bool,
    amount double precision,
    type varchar(50),
    price double precision,
    pickedDate date,
    expirationDate date,
    farmerID varchar(50) references Farmer(phonenumber)
);

create table receipt(
    orderID int references "order"(orderID),
    amount double precision,
    price double precision,
    paymentMethod varchar(50),
    paymentDate date,
    text varchar(100),
    farmerID varchar(50) references Farmer(phonenumber),
    customerID varchar(50) references Customer(phonenumber),
    primary key (orderID,farmerID,customerID)
);

create table OrderItem(
    orderID int,
    productID int,
    amount double precision,
    primary key (orderID,productID),
    foreign key (orderID) references "order"(orderID),
    foreign key (productID) references Product(productID)
);