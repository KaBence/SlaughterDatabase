create schema if not exists hostelReservation;

set schema 'hostelreservation';

create table Room(
    roomNo int primary key ,
    noBeds int,
    size int,
    orientation varchar(20),
    internet boolean,
    bathroom boolean,
    kitchen boolean,
    balcony boolean,
    price int
);

insert into room (roomNo, noBeds, size, orientation, internet, bathroom, kitchen, balcony, price)
values (10,2,25,'West',true,true,false,false,300);

insert into room (roomNo, noBeds, size, orientation, internet, bathroom, kitchen, balcony, price)
values (20,1,18,'East',true,false,true,true,270);

create table "user"(
    username varchar(100) primary key,
    password int
);

create table Employee(
    username varchar(100) PRIMARY KEY,
    firstName varchar(100),
    lastName varchar(100),
    phoneNo varchar(20),
    position varchar(100),
   FOREIGN KEY (username) references "user" (username)
);

create table ReservedBy(
    roomNo int,
    username varchar(100),
    fromDate DATE,
    toDate DATE,
    checkedIn boolean,
    PRIMARY KEY(roomNo,username,fromDate),
    FOREIGN KEY (roomNo) references Room(roomno),
    FOREIGN KEY (username) references "user"(username)
);


create table Review(
    username varchar(100),
    reviewID serial primary key ,
    roomNo int,
    fromDate date,
    postedDate date,
    "comment" varchar(200),
    foreign key (username,roomNo,fromDate) references reservedby(username,roomNo,fromDate)
);

create table Customer(
    username    varchar(100) PRIMARY KEY,
    firstName   varchar(100),
    lastName    varchar(100),
    phoneNo     varchar(20),
    paymentInfo varchar(100),
    FOREIGN KEY (username) references "user"(username)
);
