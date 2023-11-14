drop schema if exists SlaughterHouse cascade ;

create schema SlaughterHouse;

set schema 'slaughterhouse';

create table Animal(
    anm_id serial primary key ,
    weight double precision,
    dateOfDeath date,
    farm int

);

create table OneKindPackage(
    partType varchar(100),
    package_id serial primary key

);

insert into OneKindPackage(partType
) VALUES ('Leg');
insert into OneKindPackage(partType)
VALUES ('head');

create table HalfAnAnimalPackage(
    package_id serial primary key
);


insert into Animal(weight, dateOfDeath, farm)
VALUES (20,'2023/5/10',1 );
insert into Animal(weight, dateOfDeath, farm)
VALUES (50,'2023/6/10',1 );
insert into Animal(weight, dateOfDeath, farm)
VALUES (35,'2023/5/11',2 );


create table Tray(
    tray_id serial primary key ,
    maxWeight double precision

);

insert into Tray(tray_id,maxWeight)
VALUES (1,25);

create table AnimalPart(
    p_id serial primary key ,
    anm_pt_name varchar(100),
    weight double precision,
    anm_id int,
    tray_id int,
    OneKindPackege_id int,
    HalfAnAnimalPackage_id int,
    FOREIGN KEY (anm_id) references Animal(anm_id),
    FOREIGN KEY (tray_id) references Tray(tray_id),

    FOREIGN KEY (OneKindPackege_id) references OneKindPackage(package_id),
    FOREIGN KEY (HalfAnAnimalPackage_id) references HalfAnAnimalPackage(package_id)

);

insert into AnimalPart(anm_pt_name,weight,anm_id)
VALUES ('Leg',5,1);

insert into AnimalPart(anm_pt_name,weight, anm_id)
VALUES ('head',10,2);

insert into AnimalPart(anm_pt_name,weight,anm_id)
VALUES ('leg',5,1);




