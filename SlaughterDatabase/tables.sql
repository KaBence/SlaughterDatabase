drop schema if exists SlaughterHouse cascade ;

create schema SlaughterHouse;

set schema 'SlaughterHouse';

create table Animal(
    anm_id serial primary key ,
    weight double precision,
    dateOfDeath date,
    farm int

);
insert into Animal(weight, dateOfDeath, farm)
VALUES (20,'2023/5/10',1 );
insert into Animal(weight, dateOfDeath, farm)
VALUES (50,'2023/6/10',1 );
insert into Animal(weight, dateOfDeath, farm)
VALUES (35,'2023/5/11',2 );

create table AnimalPart(
    p_id serial primary key ,
    anm_pt_name varchar(100),
    weight double precision,
    anm_id int,
    FOREIGN KEY (anm_id) references Animal(anm_id)

);

insert into AnimalPart(anm_pt_name,weight,anm_id)
VALUES ('Leg',5,1);

insert into AnimalPart(anm_pt_name,weight, anm_id)
VALUES ('head',10,2);

insert into AnimalPart(anm_pt_name,weight,anm_id)
VALUES ('leg',5,1);

create table Tray(
    tray_id serial primary key ,
    anm_pt_name varchar(100),
    maxWeight double precision,
    p_id int,
    FOREIGN KEY (p_id) references AnimalPart(p_id),
    FOREIGN KEY (anm_pt_name) references AnimalPart(anm_pt_name)
);

insert into Tray( anm_pt_name,tray_id,maxWeight, p_id)
VALUES ('head',1,25,2);

insert into Tray( anm_pt_name,tray_id,maxWeight, p_id)
VALUES ('leg',1,25,1);
 insert into Tray(anm_pt_name,tray_id, maxWeight, p_id) VALUES ('leg',2,20,3);

create table OneKindPackage(
    partType varchar(100),
    package_id serial primary key ,
    tray_id int,
    FOREIGN KEY (tray_id) references Tray(tray_id),
    FOREIGN KEY (partType) references Tray(anm_pt_name)
);

insert into OneKindPackage(partType
) VALUES ('Leg');
insert into OneKindPackage(partType)
VALUES ('head');

create table HalfAnAnimalPackage(
    package_id serial primary key ,
    tray_id int,
    FOREIGN KEY (tray_id) references Tray(tray_id)
);