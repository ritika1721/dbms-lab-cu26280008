CREATE DATABASE labsheet_1;
USE labsheet_1
CREATE TABLE departments(
dept_id INT PRIMARY KEY,
dept_name VARCHAR(50)
);	
CREATE TABLE employees(
emp_id INT primary KEY,
first_name varchar(30),
salary decimal(10,2)
);
show tables;
create table projects(
project_id int primary key,
project_name varchar(100),
start_data date
);
create table audit_logs(
log_id int primary key,
action text,
created_at timestamp
);
create table products(
product_id int primary key,
product_name varchar(50),
is_available boolean
);
create table system_setting(
setting_id smallint primary key,
setting_key varchar(50),
setting_value varchar(100)
);
alter table employees
add column email varchar(100);
alter table products
drop column is_available
RENAME table departments to dept_units;
truncate table audit_logs;
CREATE table user_profiles(
user_id int primary key,
bio text,
profile_pic blob
);
create table ticket_orders(
ticket_id int primary key,
priority_level enum('low','medium','high')
);
alter table employees
modify column email varchar (150);
create table sensor_data(
read_id bigint primary key,
temprature float
);
alter table employees
rename column first_name to given_name;
alter table system_setting
drop primary key;
create table clients(
client_id int primary key,
registration_time time
);
alter table clients
add primary key (client_id);




use labsheet_1
21....
create table order_items(
order_id int,
item_id int,
quantity int,
unit_price decimal(8,2),
primary key (order_id,item_id)
);
22...
create table event_schedules(
event_id int,
venue_id int,
event_date date,
duration_hours tinyint,
primary key (event_id, venue_id)
);
23..
alter table employees
add column hire_date date,
add column is_active boolean;
24....
alter table employees
drop column email,
modify column salary decimal(12,2);
25....
alter table inventory
add primary key (warhouse_id,sku);
26....
alter table user_profiles
modify column bio mediumtext;
27...
alter table employees
add column middle_name varchar(30) 
after given_name;
28...
create table geolocations(
location_id int primary key,
latitude decimal(9,6),
longitude decimal(9,6)
);
29..
create table user_accounts(
user_id bigint primary key,
account_tye enum('standard','premium','admin'),
created_timestamp timestamp 
);
30..
create table device_logs(
log_id bigint primary key,
ip_address varchar(45),
payload longblob
);
31....
alter table order_items
drop primary key,
add column order_items_id int first,
add primary key (order_items_id);
32..
alter table projects
CHANGE column start_data
project_year year;
33..
create table documents_store(
doc_id int primary key,
doc_title varchar(255),
content longtext
);
34..
alter table documents_store
change column content doc_body longtext;
35..
create table emoloyees_archive like employees;
36..
drop table if exists
employees_archive;
37..
create table financial_ledger(
entry_id bigint primary key,
debit decimal (15,4),
credit decimal(15,4)
);
38...
alter table financial_ledger
add column transaction_date
datetime first;
39..
create table measurements (
sample_id int primary key,
value double
);
40..
create table app_users(
user_id int primary key,
status_code tinyint
);




