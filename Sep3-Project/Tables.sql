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
    pestecides bool
);

create table Customer(
    phonenumber varchar(50) primary key references "user" (phonenumber),
    firstname varchar(50),
    lastname varchar(50),
    address varchar(50)
);

create table Review(
    reviewID serial primary key,
    text varchar(50),
    star varchar(50),
    farmerID varchar(50) references Farmer(phonenumber),
    customerID varchar(50) references Customer(phonenumber)
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
    date date,
    customerID varchar(50) references Customer(phonenumber)
);

create table Product(
    productID serial primary key,
    availability bool,
    amount int,
    type varchar(50),
    price int,
    pickedDate date,
    expirationDate date,
    farmerID varchar(50) references Farmer(phonenumber)
);

create table receipt(
    orderID int primary key references "order"(orderID),
    amount int,
    price int,
    paymentMethod varchar(50),
    paymentDate varchar(50),
    text varchar(100),
    farmerID varchar(50) references Farmer(phonenumber),
    customerID varchar(50) references Customer(phonenumber)
);

create table OrderItem(
    orderID int,
    productID int,
    amount int,
    primary key (orderID,productID),
    foreign key (orderID) references "order"(orderID),
    foreign key (productID) references Product(productID)
);