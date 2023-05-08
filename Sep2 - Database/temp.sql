create schema hostelReservation;

set schema 'hostelreservation';

create table temp(
    test varchar(50)
);

create table Room(
    roomNo int,
    noBeds int,
    size int,
    orientation varchar(20),
    internet boolean,
    bathroom boolean,
    kitchen boolean,
    balcony boolean,
    price int
);

