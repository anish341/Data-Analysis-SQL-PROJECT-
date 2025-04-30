
create database onlinebookstore ;

---- Swith to the database /c onlineBookstore;

--create Tables

Drop table if exists books;

create table books(
Book_ID int PRimary key,
Title varchar(100),
Author varchar(1000),
Genre varchar(50),
Published_Year int,
Price numeric(10,2),
Stock int
);

drop table if exists customers;

create table Customers(
Customer_ID int not null primary key,
Name varchar(100),
Email varchar(100),
Phone varchar(15),
City varchar(100),
Country varchar(150)

);

drop table if exists orders;

create table orders(
Order_ID int primary key,
Customer_ID int references  customers(customer_id),
Book_ID int references	books(book_id),
Order_Date date,
Quantity int not null,
Total_Amount numeric(10,2)

);


--- Retrieve all query 
select * from  books;

select * from [Customers (1)];

select * from orders;

--1 Retrieve the all books in the " fiction" genre;
select * 
from 
	books
where 
	Genre ='Fiction'

--2.FIND BOOKS PUBLISHED AFTER THE YEAR 1950;
select * 
from 
	books 
where 
	Published_Year>1950;

--3.LIST ALL CUSTOMER FROM THE CANADA;
select * 
from 
	[Customers (1)]
where 
	Country ='canada'

--4.SHOW ORDER PLACED IN NOVEMBER 2023;
select *
from
	orders
where
	order_date between '2023-11-01' and '2023-11-30'


--5.RETRIEVE THE TOTAL STOCK OF BOOKS AVAILABLE;
select 
	sum(stock) 
as 
	total_stock 
from 
	books

--6.FIND THE DETAILS OF THE MOST EXPENSIVE BOOK;
select top 5 *  
from
	books
order by 
	price 
desc ;

--7.SHOW ALL THE TOTAL CUSTOMERS WHO ORDERED MORE THAN I QUANTITY OF A BOOK
select *
from 
	orders
where
	quantity>1;

--8.RETRIEVE ALL ORDER WHERE THE TOTAL AMOUNT EXCEEDS $20;
select * 
from 
	orders 
where 
	total_amount>20;

--9.LIST ALL GENRES AVAILABLE IN THE BOOKS TABLE;
select distinct 
	genre 
from
	books;

--10.FIND THE BOOKS WITH THE LOWEST STOCK;
select top 3 * 
from
	books 
order by 
	stock ;

--11.CALCULATE THE TOTAL REVENUE GENERATED FROM ALL ORDERS;
select sum(total_amount) as revenue 
from 
	orders 

--ADVANCED QUESTIONS;

--RETRIEVE THE TOTAL NUMBER OF BOOKS SOLID FOR EACH GENRE;
select * from orders

select b.Genre, sum(o.quantity) as tota_books_solid 
from 
	orders o 
join 
	books b on o.book_id =b.Book_ID
group by
	b.Genre;

-- FIND THE AVERAGE PRICE OF BOOKS IN THE "FANTASY" GENRE;
select avg(price)as average_price 
from 
	books
where
	genre ='fantasy'

--LIST CUATOMERS WHO HAVE PLACED AT LEAST 2 ORDERS;
select o.Customer_ID,c.Name, count(o.Order_ID)as order_count 
from
	orders o
JOIN 
	[Customers (1)] c on o.customer_id =c.Customer_ID
group by
	o.Customer_ID ,c.Name
having 
	count(order_id)>=2;

-- FIND THE MOST FREQUENTLY ORDERED BOOK;
select top 2 b.Book_ID, b.Title,count(o.order_id) as order_count
from
	orders o
join
	books b on o.Book_ID =b.Book_ID
group by
	b.book_id , b.Title
order by 
	order_count desc 

--SHOW THE TOP 3 MOST EXPENSIVE BOOKS OF 'FANTASY' GENRE;
select top 3* 
from 
	books 
where 
	genre ='fantasy'
order by 
	price desc 

--RETRIEVE THE TOTAL QUANTITY OF BOOKS SOLD BY EACH AUTHOR ;
select b.author, sum(o.quantity) as total_books_slod
from 
	orders o
join
	books b on o.Book_ID =b.Book_ID
group by
	b.Author

--LIST THE CITIES WHERE CUSTOMERS WHO SPENT OVER $30 ARE LOCATED ;
select distinct c.city,total_amount  
from 
	orders o
join
	[Customers (1)] c on o.Customer_ID =c.Customer_ID
where 
	o.Total_Amount> 30;

--FIND THE CUSTOMERS WHO SPENT THE MOST ON ORDERS;
select c.Customer_ID,c.Name, sum(o.total_amount)as total_spent 
from 
	orders o
join 
	[Customers (1)] c on c.Customer_ID =o.Customer_ID
group by
	c.Customer_ID ,c.name
order by 
	total_spent desc

--CACULATE THE STOCK REMAINING AFTER FULFILLING ALL ORDERS;
SELECT 
    b.Book_ID, 
    b.Title, 
    b.Stock, 
    COALESCE(SUM(o.Quantity), 0) AS order_quantity,
	b.Stock -COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM 
    books b
LEFT JOIN 
    orders o ON b.Book_ID = o.Book_ID
GROUP BY  
    b.Book_ID, b.Title, b.Stock
ORDER BY  b.Book_ID;
