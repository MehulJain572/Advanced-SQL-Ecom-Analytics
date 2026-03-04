create database ecommerce;
use ecommerce;

--creating products table:
create table products(
    product_id int PRIMARY key,
    name varchar(100),
    category varchar(50),
    price decimal(10,2)
);

--users table:
create table users(
    user_id int PRIMARY KEY,
    name varchar(100),
    join_date date
);

--orders table:
create table orders(
    order_id int PRIMARY KEY,
    user_id int,
    product_id int,
    order_date date,
    quantity int,
    Foreign Key (user_id) REFERENCES users(user_id),
    Foreign Key (product_id) REFERENCES products(product_id)
);

--inserting sample data in the tables:
insert into products values(1,'laptop','electronics',800),(2,'mouse','electronics',20),(3,'t-shirt','apparel',25),(4,'jeans','apparel',50),
(5,'coffee maker','home',100);

insert into users values(101,'aditya','2023-01-10'),(102,'sanya','2023-02-15'),(103,'mehul','2023-03-20');

insert into orders values(1,101,1,'2023-05-01',1),(2,102,2,'2023-05-05',2),(3,101,3,'2023-06-01',3),(4,103,5,'2023-06-15',1),
(5,102,4,'2023-07-01',1);

#QUESTION 1 : WHO ARE THE TOP-SPENDING CUSTOMERS?
select users.name, sum(products.price * orders.quantity) as total_spent from users 
join orders on users.user_id=orders.user_id join products on orders.product_id=products.product_id
group by users.name order by total_spent DESC;

#QUESTION 2: WHAT IS THE MOST EXPENSIVE PRODUCT IN EACH CATEGORY:
with category_ranks as(
    select name,category,price, rank() over(PARTITION BY category order by price desc) as product_rank from products
)
select name,category,price from category_ranks where product_rank=1;

#QUESTION 3: WHICH USERS HAVE REGISTERED BUT NEVER PLACED AN ORDER?
SELECT users.name FROM users LEFT JOIN orders ON users.user_id = orders.user_id WHERE orders.order_id IS NULL;

#QUESTION 4: WHICH CATEGORY HAS MADE THE MOST MONEY? :
select products.category, sum(products.price*orders.quantity)as total_revenue from products join orders on orders.product_id=products.product_id
group by products.category order by total_revenue desc limit 1;

