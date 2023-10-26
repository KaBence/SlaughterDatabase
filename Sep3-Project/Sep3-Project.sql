drop schema if exists distributionsystem cascade ;

create schema DistributionSystem;

set schema 'distributionsystem';

create table testtable(
    id SERIAL PRIMARY KEY,
    string_test  varchar(100) not null
);