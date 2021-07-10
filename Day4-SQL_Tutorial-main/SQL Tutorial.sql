# Creating a new database
create database Tutorial;

# Deleting /Dropping the database
drop database Tutorial;

# Creating a new table 
create table customers
(
customer_id int,
LastName varchar(255),
FirstName varchar(255),
Address varchar(255)
);

#dropping the table
drop table customers;

#inserting values
insert into customers(customer_id,LastName, FirstName, Address)
values(1, Sharma, Nischal, Jarkhand);
insert into customers
values(2, Shetty, Sumukh, Maharashtra);
insert into customers(customer_id, FirstName, Address)
values(3, Priyanka, Gujrath);
insert into customers(customer_id,LastName, FirstName, Address)
values(4, Tripathi, Rekha, UttarPradesh);
insert into customers
values(5, Pandit, Radhika, Karnataka);
insert into customers(customer_id,LastName, FirstName, Address)
values(6, Ali, Suhana, Kerala);

# another way to create 
create table cust_duplicate as 
select customer_id, FirstName
from customers;

select * from cust_duplicate;
select FirstName, LastName from customers;


#dropping the table
drop table cust_duplicate;



