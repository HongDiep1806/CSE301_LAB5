use salemanagerment;
-- 1. Display the clients (name) who lives in same city.
select * from clients
where city in (select city 
from clients
group by city
having count(*) >=2)
order by city;
-- 2. Display city, the client names and salesman names who are lives in “Thu Dau Mot” city.
select distinct 'Thu Dau Mot' as city, c.client_name,s.salesman_name 
from clients c left join salesman s 
on c.city = s.city
where c.city ='Thu Dau Mot' or s.city = 'Thu Dau Mot';
-- 3. Display client name, client number, order number, salesman number, and product number for each 
-- order.
select c.Client_Name,c.Client_Number,so.Order_Number,ss.Salesman_Number,sod.Product_Number from salesorder so left join clients c
on so.client_number = c.client_number
left join salesman ss on so.Salesman_Number = ss.Salesman_Number
left join salesorderdetails sod on so.Order_Number = sod.Order_Number;
-- 4. Find each order (client_number, client_name, order_number) placed by each client.
select s.Client_Number,c.Client_Name,s.Order_Number from salesorder s left join clients c
on s.Client_Number = c.Client_Number;
-- 5. Display the details of clients (client_number, client_name) and the number of orders which is paid by 
-- them.
select s.Client_Number,c.Client_Name,count(s.Order_Number) as numOfOrder from salesorder s inner join clients c
on s.Client_Number = c.Client_Number
where c.Amount_Paid >0
group by c.Client_Number,c.Client_Name;
-- 6. Display the details of clients (client_number, client_name) who have paid for more than 2 orders.
select s.Client_Number,c.Client_Name from salesorder s inner join clients c
on s.Client_Number = c.Client_Number
where c.Amount_Paid >0
group by c.Client_Number,c.Client_Name
having count(s.Order_Number)> 2;
-- 7. Display details of clients who have paid for more than 1 order in descending order of client_number.
select s.Client_Number,c.Client_Name from salesorder s inner join clients c
on s.Client_Number = c.Client_Number
where c.Amount_Paid >0
group by c.Client_Number,c.Client_Name
having count(s.Order_Number)> 1
order by c.Client_Number desc;
-- 8. Find the salesman names who sells more than 20 products.
select ss.Salesman_Name from salesman ss inner join salesorder so
on ss.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod
on sod.Order_Number = so.Order_Number
group by ss.Salesman_Name
having sum(sod.Order_Quality) > 20;
-- 9. Display the client information (client_number, client_name) and order number of those clients who 
-- have order status is cancelled.
select c.Client_Number,c.Client_Name, so.Order_Number from clients c inner join salesorder so
on c.Client_Number = so.Client_Number
where so.Order_Status = 'Cancelled';
-- 10. Display client name, client number of clients C101 and count the number of orders which were 
-- received “successful”.
select c.Client_Name,c.Client_Number,count(*) as numOfOrder 
from clients c inner join salesorder so
on c.Client_Number = so.Client_Number
where c.Client_Number = 'C101' AND so.Order_Status = 'Successful';
-- 11. Count the number of clients orders placed for each product.
select sod.Product_Number,count(*) as numOfClientOrder from salesorderdetails sod inner join salesorder so
on sod.Order_Number = so.Order_Number
group by sod.Product_Number;
-- 12. Find product numbers that were ordered by more than two clients then order in descending by product 
-- number.
select sod.Product_Number,count(*) as numOfClients from salesorderdetails sod inner join salesorder so
on sod.Order_Number = so.Order_Number
group by sod.Product_Number
having numOfClients > 2
order by sod.Product_Number desc;
-- 13. Find the salesman’s names who is getting the second highest salary.
select Salesman_Name from salesman where Salesman_Number = 
(select Salesman_Number from salesman
order by Salary desc
limit 1
offset 1);
-- 14. Find the salesman’s names who is getting second lowest salary.
select Salesman_Name from salesman
where Salary = 
(select distinct salary from salesman
order by Salary
limit 1 offset 1);
-- 15. Write a query to find the name and the salary of the salesman who have a higher salary than the 
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary > ALL (
    SELECT Salary
    FROM Salesman
    WHERE Salesman_Number = 'S001'
);
-- 16. Write a query to find the name of all salesman who sold the product has number: P1002.
select ss.Salesman_Name from salesman ss inner join salesorder so 
on ss.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
where sod.Product_Number = 'P1002';
-- 17. Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”.
select ss.Salesman_Name from salesman ss
inner join salesorder so
on ss.Salesman_Number = so.Salesman_Number
where so.Client_Number = 'C108' and so.Delivery_Status = 'Delivered';
-- 18. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal 
-- to 5.
select p.Product_Name from salesorderdetails sod inner join product p 
on sod.Product_Number = p.Product_Number
where sod.Order_Quality = 5;
-- 19. Write a query to find the name and number of the salesman who sold pen or TV or laptop.
select distinct ss.Salesman_Name, ss.Salesman_Number from salesman ss inner join salesorder so
on ss.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p
on sod.Product_Number = p.Product_Number
where Product_Name in ('TV','Pen','Laptop');
-- 20. Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand
-- more than 50.
select distinct ss.Salesman_Name from salesman ss inner join salesorder so
on ss.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p
on sod.Product_Number = p.Product_Number
where p.Cost_Price < 800 and p.Quantity_On_Hand > 50;
-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average 
-- salary.
with averageSa as (select avg(salary) as aver from salesman)
select Salesman_Name,Salary from salesman
where Salary > (select aver from averageSa);
-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the 
-- average amount paid.
with avgamount as (select avg(Amount_Paid) as aver from clients)
select Client_Name,Amount_Paid from clients 
where Amount_Paid > (select aver from avgamount );
-- 23. Find the product price that was sold to Le Xuan.
select p.Cost_Price from salesorder so inner join salesorderdetails sod
on so.Order_Number= sod.Order_Number
inner join clients c
on c.Client_Number = so.Client_Number
inner join product p 
on p.Product_Number = sod.Product_Number
where c.Client_Name = 'Le Xuan';
-- 24. Determine the product name, client name and amount due that was delivered.
select p.Product_Name,c.Client_Name,c.Amount_Due from clients c inner join salesorder so
on c.Client_Number = so.Client_Number
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p 
on p.Product_Number = sod.Product_Number
where so.Delivery_Status = 'Delivered';
-- 25. Find the salesman’s name and their product name which is cancelled.
select ss.Salesman_Name,Product_Name from salesman ss inner join salesorder so 
on ss.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p
on sod.Product_Number = p.Product_Number
where so.Order_Status='Cancelled';
-- 26. Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
select p.Product_Name,p.Cost_Price,so.Delivery_Status from salesorder so inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p
on p.Product_Number = sod.Product_Number
inner join clients c
on c.Client_Number = so.Client_Number
where c.Client_Name = 'Nguyen Thanh ';
-- 27. Display the product name, sell price, salesperson name, delivery status, and order quantity information 
-- for each customer.
select p.Product_Name,p.Sell_Price,ss.Salesman_Name, so.Delivery_Status,sod.Order_Quality from salesorder so inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join clients c
on c.Client_Number = so.Client_Number
inner join product p 
on p.Product_Number = sod.Product_Number
inner join salesman ss
on ss.Salesman_Number = so.Salesman_Number;
-- 28. Find the names, product names, and order dates of all sales staff whose product order status has been 
-- successful but the items have not yet been delivered to the client.
select ss.Salesman_Name, p.Product_Name,so.Order_Status from salesman ss
inner join salesorder so
on ss.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p
on p.Product_Number = sod.Product_Number
where so.Order_Status ='Successful' and so.Delivery_Status='On Way';
-- 29. Find each clients’ product which in on the way.
select c.Client_Name,p.Product_Name,so.Delivery_Status from salesorder so
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join clients c
on c.Client_Number = so.Client_Number
inner join product p
on p.Product_Number = sod.Product_Number
where so.Delivery_Status='On Way';
-- 30. Find salary and the salesman’s names who is getting the highest salary.
with maxSalary as (select max(salary) as maxSa from salesman)
select Salary,Salesman_Name from salesman
where Salary = (select maxSa from maxSalary);
-- 31. Find salary and the salesman’s names who is getting second lowest salary.
with secondLoswest as ( select distinct Salary as secondLow from salesman
order by Salary asc
limit 1
offset 1)
select salary, Salesman_Name from salesman
where Salary = (select secondLow from secondLoswest);
-- 32. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more 
-- than 9.
select p.Product_Name from salesorder so
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p
on p.Product_Number = sod.Product_Number
where sod.Order_Quality > 9;
-- 33. Find the name of the customer who ordered the same item multiple times.
select distinct c.Client_Name from salesorder so
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join clients c
on c.Client_Number=so.Client_Number
group by c.Client_Name,sod.Product_Number;
-- 34. Write a query to find the name, number and salary of the salemans who earns less than the average 
-- salary and works in any of Thu Dau Mot city.
select Salesman_Name,Salesman_Number,Salary from salesman
where Salary < (select avg(Salary) from salesman)
and City = 'Thu Dau Mot';
-- 35. Write a query to find the name, number and salary of the salemans who earn a salary that is higher than 
-- the salary of all the salesman have (Order_status = ‘Cancelled’). Sort the results of the salary of the lowest to 
-- highest.
select distinct ss.Salesman_Name,ss.Salesman_Number,ss.Salary from salesorder so
inner join salesorderdetails sod
inner join salesman ss
on so.Salesman_Number = ss.Salesman_Number
where ss.Salary > (select max(ss.Salary) from salesman ss inner join salesorder so
on ss.Salesman_Number = so.Salesman_Number
where so.Order_Status = 'Cancelled')
order by ss.Salary asc;
-- 36. Write a query to find the 4th maximum salary on the salesman’s table.
select distinct Salary from salesman ss
order by Salary desc
limit 1
offset 3;
-- 37. Write a query to find the 3th minimum salary in the salesman’s table.
select distinct Salary from salesman ss
order by Salary desc
limit 1
offset 2;