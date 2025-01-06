/*
Description: Coursera Capstone
Author: alpacajue
Last Updated: 2025-01-06
*/

-- create database
drop database if exists little_lemon;
create database if not exists little_lemon;
use little_lemon;

-- create tables
drop table if exists customers, booking, staff, menu, orders, order_items;
create table if not exists customers (
	customer_id int auto_increment primary key,
    name varchar(100) not null,
    phone varchar(20) not null,
    email varchar(100)
    );
create table if not exists booking (
	booking_id int auto_increment primary key,
    customer_id int not null,
    booking_date date not null,
    booking_time time not null,
    table_number int not null,
    status enum('active','canceled','completed') default 'active',
    foreign key (customer_id) references customers(customer_id)
	);
create table if not exists staff (
	staff_id int auto_increment primary key,
    name varchar(100) not null,
    role enum('waiter','chef','manager','host') not null,
    phone varchar(20),
    email varchar(100)
    );
create table if not exists menu (
	item_id int auto_increment primary key,
    item_name varchar(100) not null,
    category enum('appetizer','main','dessert','drink') not null,
    price decimal(7,2) not null,
    quantity int default 0
    );
create table if not exists orders (
	order_id int auto_increment primary key,
    booking_id int not null,
    order_time datetime default current_timestamp,
    status enum('pending','preparing','served','cancelled') default 'pending',
    foreign key (booking_id) references booking(booking_id)
    );
create table if not exists order_items (
	order_item_id int auto_increment primary key,
    order_id int not null,
    menu_item_id int not null,
    quantity int not null default 1,
    price decimal(7,2) not null,
    foreign key (order_id) references orders(order_id),
    foreign key (menu_item_id) references menu(item_id)
	);
show tables;

-- insert sample data
insert into customers (name,phone,email) values
  ('Alice', '123456789', 'alice@example.com'),
  ('Bob',   '987654321', 'bob@example.com');
insert into booking (customer_id, booking_date, booking_time, table_number) values
  (1, '2025-01-10', '18:30:00', 5),
  (2, '2025-01-10', '19:00:00', 3);
insert into staff (name, role, phone, email) values
  ('Chris', 'MANAGER', '555-1001', 'chris@littlelemon.com'),
  ('David', 'WAITER',  '555-1002', 'david@littlelemon.com');
insert into menu (item_name, category, price, quantity) values
  ('Greek Salad', 'APPETIZER', 6.50, 50),
  ('Grilled Chicken', 'MAIN', 12.00, 30),
  ('Chocolate Cake', 'DESSERT', 5.50, 20),
  ('Lemonade', 'DRINK', 3.00, 40);
insert into orders (booking_id) values
  (1),
  (1);
insert into order_items (order_id, menu_item_id, quantity, price) values
  (5, 1, 2, 10.00);

-- create stored procedures
-- addingbooking()
delimiter $$
create procedure addbooking(
	in p_customer_id int,
    in p_booking_date date,
    in p_booking_time time,
    in p_table_number int
    )
begin
	insert into booking(customer_id, booking_date, booking_time, table_number)
    values (p_customer_id, p_booking_date, p_booking_time, p_table_number);
    select last_insert_id() as new_booking_id;
end $$
delimiter ;
select * from booking;
call addbooking(1, '2025-01-10', '18:30:00', 5);

-- managebooking()
delimiter $$
create procedure managebooking(
	in p_customer_id int,
    in p_booking_date date,
    in p_booking_time time,
    in p_table_number int
    )
begin
	declare existing_count int default 0;
    select count(*)
    into existing_count
    from booking
    where booking_date=p_booking_date
		and booking_time=p_booking_time
        and table_number=p_table_number
        and status='active';
	
    if existing_count>0 then
		select concat('table',p_table_number,' is NOT available at ',p_booking_time) as message;
	else
		insert into booking (customer_id, booking_date, booking_time, table_number)
        values (p_customer_id, p_booking_date, p_booking_time, p_table_number);
	
		select last_insert_id() as new_booking_id,
				concat('Booking created successfully at table ', p_table_number) as message;
	end if;
end $$
delimiter ; 
select * from booking;
call managebooking(1, '2025-01-10', '19:00:00', 5);

-- update booking()
delimiter $$
create procedure updatebooking(
	in p_booking_id int,
    in p_new_date date,
    in p_new_time time,
    in p_new_table int
    )
begin
	if (select count(*) from booking where booking_id=p_booking_id)=0 then
		select concat('No booking found with ID= ',p_booking_id) as message;
	else
		update booking
        set booking_date=p_new_date,
			booking_time=p_new_time,
            table_number=p_new_table
		where booking_id=p_booking_id;
        select concat('Booking ',p_booking_id,' updated successfully.') as message;
	end if;
end $$
delimiter ;
select * from booking where booking_id=10;
call updatebooking(10, '2025-01-15', '20:00:00', 8);

-- cancelbooking()
delimiter $$
create procedure cancelbooking(
	in p_booking_id int
	)
begin
	if (select count(*) from booking where booking_id=p_booking_id)=0 then
		select concat('No booking found with id=', p_booking_id) as message;
	else
		update booking
        set status='canceled'
        where booking_id=p_booking_id;
	select concat('Booking',p_booking_id,' has been canceled.') as message;
    end if;
end $$
delimiter ;
select * from booking where booking_id=10;
call cancelbooking(10);

-- maxquantity()
delimiter $$
create procedure getmaxquantity()
begin
	select item_id, item_name, quantity
    from menu
    order by quantity desc
    limit 1;
end $$
delimiter ;
call getmaxquantity();

-- check query
select b.booking_id, c.name, b.booking_date, b.booking_time, b.table_number
from booking b
join customers c on b.customer_id=c.customer_id;