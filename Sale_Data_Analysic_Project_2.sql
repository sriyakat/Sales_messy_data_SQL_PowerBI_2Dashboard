
use  SalesProject;

-- Total rows
SELECT COUNT(*) as Total_Rows FROM sales_messy_data;


Select Order_ID, count(*) as count 
from sales_messy_data
Group BY Order_ID 
Having Count(*) > 1
Order BY Count DESC;


WITH CTE AS (
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY Order_ID ORDER BY Order_ID) as rn
    FROM sales_messy_data
)
DELETE FROM CTE WHERE rn > 1;


--Table View
Select * From sales_messy_data;


--Null Values in Price Column
Select count(*) as Null_Price from sales_messy_data Where Price IS Null;


--Null Value in Total Column
Select count(*) as Null_Total from sales_messy_data Where Total IS NUll


--Check Total Null Region 
Select count(*) as Null_Region From sales_messy_data Where Region is Null or Region = ' ';


--To check How Many Customer Name is NUll
Select count(*) as Null_Customer_Name From sales_messy_data Where Customer is Null;


--Checking Null Value in Quantity Column
Select count(*) as Invailid_Quantity From sales_messy_data Where Quantity <= 0 ;


SELECT DISTINCT Region FROM sales_messy_data;


--Now start Data Cleaning
Update sales_messy_data
Set Region = UPPER(left(trim(Region), 1)) + LOWER(Substring(trim(Region), 2, LEN(Region)))
Where Region is not null and Region != ' ';

--To check data updated or not
SELECT DISTINCT Region FROM sales_messy_data;


--Fill Missing row with Unknown in Region
Update sales_messy_data
Set Region = 'Unknown'
Where Region IS Null or Region = ' ';


--put avg value in Price column 
Update sales_messy_data
set Price =(select AVG(Price) from sales_messy_data Where Price is not null)
where price is null;


--to check How mant data  is zero or -1.
Select * from sales_messy_data where Quantity <= 0;

--Delet all 241 rows from data.
Delete from sales_messy_data where Quantity <= 0;


--Filling Customer Name
Update sales_messy_data
Set Customer = 'Not Provided'
where Customer Is Null;


--TO FIXED the customer name
Update sales_messy_data
Set Customer = Upper(LEFT(TRIM(Customer), 1)) + LOWER(substring(Trim(Customer), 2 , LEN(Customer)))
where Customer Is Not Null or Customer != 'Not Provided';

select * from sales_messy_data;

UPDATE sales_messy_data
SET Total = Price * Quantity;


--To varify the column there is no Null value
Select
     Sum(Case when Price Is Null Then 1 Else 0 End) as Null_Price,
     Sum( Case When Total Is Null Then 1 Else 0 End ) as Null_Total,
     Sum ( Case when Region Is Null then 1 else 0 End ) as Null_Region,
     Sum( Case when Customer Is Null then 1 else 0 End ) as Null_Customer
     from sales_messy_data;


     --Calculae Total Revenue
     Select Sum(Total) as Revenue From sales_messy_data;


     --Category wise revenue
     Select Category, Sum(Total) as Revenue
     from sales_messy_data
     Group BY Category order BY Revenue DESC;

     --Now Region wise Sales
     Select Region, Sum(Total) as Revenue
     from sales_messy_data
     Group BY Region Order BY Revenue DESC;

     --Month wise trends
     Select MONTH(Date) as Month, Sum(Total) as Revenue
     From sales_messy_data
     Group BY MONTH(Date) Order BY Month DESC;


     --Top 5 Product
     Select * from sales_messy_data
     Select Top 5 Product, Sum(Total) as Revenue
     From sales_messy_data
     Group BY Product Order BY Revenue DESC;