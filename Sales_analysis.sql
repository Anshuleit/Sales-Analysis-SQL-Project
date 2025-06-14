create database sales;
use sales;
create table customers ( c_id int primary key, name varchar(20), city varchar(20));
insert into customers values (1, "Alice", "Toronto"), (2, "Bob", "Vancouver"), (3, "Charlie", "Calgary");
create table products ( p_id int primary key, p_name varchar(20), price varchar(20));
insert into products values (101, "Laptop", 800), (102, "Mouse", 20), (103, "Headphone", 100);
create table orders ( o_id int primary key, cust_id int, foreign key (cust_id) references customers(c_id),  
					prod_id int, foreign key (prod_id) references products(p_id), quantity int default 1 , order_date int not null );
alter table orders
modify column order_date datetime;
insert into orders(o_id, cust_id, prod_id, quantity,order_date) values (1,1,101,1,curdate()),(2,2,102,2,curdate()), 
																		(3,1,103,1,curdate()), (4,3,101,1,curdate());
delete from orders where o_id=1;
select * from orders;

# Show each customer's name, product name, quantity, order date, and total amount.

select c.name as Name, p.p_name as Product, o.quantity as Quantity, o.order_date as Date, (p.price*o.quantity) as TotalAmount
from orders o
join customers c on c.c_id = o.cust_id
join products p on p.p_id = o.prod_id;

# List customers who spent more than ₹500
select c.name as Name, p.p_name as Product, o.quantity as Quantity, o.order_date as Date, (p.price*o.quantity) as TotalAmount
from orders o
join customers c on c.c_id = o.cust_id
join products p on p.p_id = o.prod_id where (p.price*o.quantity)>500;

# Show total revenue per city.
select c.city as city, sum(p.price*o.quantity) as Revenue
from orders o
join customers c on c.c_id = o.cust_id
join products p on p.p_id = o.prod_id group by c.city;

# List products sold more than once.
select  p_name as Most_Sold_Product, COUNT(*) AS Times_Sold
FROM orders o
JOIN products p ON o.prod_id = p.p_id
GROUP BY p.p_name
HAVING COUNT(*) > 1;

# Find orders made in the last 7 days.

SELECT *FROM orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

# What’s the total revenue?
select sum(p.price*o.quantity) as Revenue
from orders o
join customers c on c.c_id = o.cust_id
join products p on p.p_id = o.prod_id;

#Find customers who ordered the most expensive product.
with max_price as( select max(price) as max_price from products)
select c.name as CustomerName, p.p_name as ProductName, p.price as Price
from orders o
join customers c on c.c_id = o.cust_id
join products p on p.p_id = o.prod_id
join max_price mp on p.price= mp.max_price;
