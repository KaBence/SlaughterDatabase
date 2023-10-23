drop schema if exists hostelReservation cascade;

create schema if not exists hostelReservation;

set schema 'hostelreservation';

create domain stat as varchar(50) check ( value in ('Free','Reserved','Booked','Reserved and Booked' ));

create or replace function status()
    returns TRIGGER
    language plpgsql
as
    $$
    declare
        roomNumber int;
        reserved int;
        booked int;
        begin
            roomNumber=new.roomno;
            select count(*) into reserved from reservedby where roomNo=roomNumber and checkedIn=false;
            select count(*) into booked from reservedby where roomNo=roomNumber and checkedIn=true;
            if reserved > 0 then
                update room set status='Reserved' where roomNo=roomNumber;
            end if;
            if booked>0 then
                update room set status='Booked' where roomNo=roomNumber;
            end if;
            if booked>0 and reserved>0 then
                update room set status='Reserved and Booked' where roomNo=roomNumber;
            end if;
            return new;
        end;
    $$;



create table Room(
    roomNo int primary key ,
    noBeds int,
    size int,
    orientation varchar(20),
    internet boolean,
    bathroom boolean,
    kitchen boolean,
    balcony boolean,
    price int,
    status stat
);

insert into room (roomNo, noBeds, size, orientation, internet, bathroom, kitchen, balcony, price,status)
values (10,2,25,'West',true,true,false,false,300,'Free');

insert into room (roomNo, noBeds, size, orientation, internet, bathroom, kitchen, balcony, price,status)
values (20,1,18,'East',true,false,true,true,270,'Free');

insert into room (roomNo, noBeds, size, orientation, internet, bathroom, kitchen, balcony, price,status)
values (35,2,40,'West',true,true,true,true,500,'Free');

insert into room (roomNo, noBeds, size, orientation, internet, bathroom, kitchen, balcony, price,status)
values (40,3,30,'West',true,false,false,false,200,'Free');

create table "user"(
    username varchar(100) primary key,
    password varchar(100)
);

INSERT INTO "user"(username, password)
values('john@hotmail.com', 'k13579');

insert into "user" (username, password)
values ('Bob@gmail.com','6241');


insert into "user"(username, password)
values('sam@hotmail.com', 's098765');

insert into "user" (username, password)
values ('12345','54321');

insert into "user" (username, password)
values ('6258','6258');

insert into "user" (username, password)
values ('7894','6258');


create table Employee(
    username varchar(100) PRIMARY KEY,
    firstName varchar(100),
    lastName varchar(100),
    phoneNo varchar(20),
    position varchar(100),
   FOREIGN KEY (username) references "user" (username)
);

INSERT INTO Employee(username, firstName, lastName, phoneNo, position)
values('12345', 'Bob', 'Wick', 97531, 'manager');

insert into Employee(username, firstName, lastName, phoneNo, position)
values('6258', 'Dan', 'Nol', 004531323334, 'manager');

insert into Employee(username, firstName, lastName, phoneNo, position)
values('7894', 'Anne', 'Marie', 004510293847, 'Receptionist');

create table ReservedBy(
    roomNo int,
    username varchar(100),
    fromDate DATE,
    toDate DATE check ( ReservedBy.toDate >ReservedBy.fromDate),
    checkedIn boolean,
    PRIMARY KEY(roomNo,username,fromDate),
    FOREIGN KEY (roomNo) references Room(roomno),
    FOREIGN KEY (username) references "user"(username)
);

create or replace trigger changeStatus
    after insert
    on reservedby
    for each row
    execute function status();

INSERT INTO ReservedBy(roomNo, username, fromDate, toDate, checkedIn)
VALUES(10, 'john@hotmail.com','2023/4/10', '2023/4/15', true);

insert into reservedby (roomNo, username, fromDate, toDate, checkedIn)
values (40,'Bob@gmail.com','2023/3/30','2023/4/4',null);


create table Review(
    username varchar(100),
    reviewID serial primary key ,
    roomNo int,
    fromDate date,
    postedDate date,
    "comment" varchar(200),
    foreign key (username,roomNo,fromDate) references reservedby(username,roomNo,fromDate)
);

INSERT INTO Review(username, roomNo, fromDate, postedDate, comment)
VALUES('john@hotmail.com', 10, '2023/4/10', '2023/4/16', 'WoW');

insert into Review(username, roomNo, fromDate, postedDate, comment)
values ('Bob@gmail.com', 40, '2023/3/30', '2023/4/5', 'good establishment');

create table Customer(
    username    varchar(100) PRIMARY KEY,
    firstName   varchar(100),
    lastName    varchar(100),
    phoneNo     varchar(20),
    paymentInfo varchar(100),
    FOREIGN KEY (username) references "user"(username)
);

INSERT INTO Customer(username, firstName, lastName, phoneNo, paymentInfo)
VALUES('john@hotmail.com', 'John', 'Doe', 97531, 'PayPal');

insert into customer (username, firstName, lastName, phoneNo, paymentInfo)
values ('Bob@gmail.com','Bob','Bobbinson',52147,'Google pay');

insert into customer (username, firstName, lastName, phoneNo, paymentInfo)
values ('sam@hotmail.com','Sam','Jack',004509213476,'Mobile Pay');


CREATE FUNCTION delete_review() RETURNS trigger

    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE
    FROM review
    WHERE hostelReservation.review.username = old.username
      AND hostelReservation.review.roomno = old.roomno
      AND hostelReservation.review.fromdate = old.fromdate;
    RETURN old;
END;
$$;

CREATE TRIGGER delete_review
    BEFORE Delete
    on ReservedBy
    for each row
EXECUTE function delete_review();


CREATE FUNCTION delete_Customer() RETURNS trigger

    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE
    FROM customer
    WHERE hostelReservation.customer.username = old.username;
    RETURN old;
END;
$$;

CREATE TRIGGER delete_Customer
    BEFORE Delete
    on "user"
    for each row
EXECUTE function delete_Customer();