select * from retail_sales;
select  count(*) from retail_sales;
select * from retail_sales
order by transactions_id asc limit 100 ;
 -- data  cleaning  
-- remove  null values 
select * from retail_sales
where transactions_id is null ; 
select * from retail_sales
where sale_time is null ; 
 -- renaming a column name 
-- ALTER TABLE retail_sales
-- RENAME COLUMN `quantiy` TO quantity 

-- mulitiple remove null values 
select * from retail_sales
where 
	sale_time is null 
    or 
    transactions_id is null
    or
    sale_date is null
    or 
    sale_time is null
    or 
    customer_id is null
    or 
    gender is null
    or 
    category is null
    or
    quantity is null
    or
    price_per_unit is null
    or
    cogs is null
    or
    total_sale is null ; 
    
    
    -- deleting null values 
    SET SQL_SAFE_UPDATES = 0;

-- Now run your delete query
DELETE FROM retail_sales
WHERE
    sale_time IS NULL OR
    transactions_id IS NULL OR
    sale_date IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    category IS NULL OR
    quantity IS NULL OR 
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;
    
SET SQL_SAFE_UPDATES = 1; -- Optional: Turn safe mode back on after the delete

-- data exploring
-- 1.how many sales do we have 
    select count(*) as total_sales
    from retail_sales;
     -- how many customers  we have 
      select count(customer_id ) as total_sales
    from retail_sales;
    -- how many  unique customers do we have 
        select distinct customer_id as total_sales
    from retail_sales;
    -- how many category do we have 
      select  distinct category from retail_sales;
      
      
      -- data analysis  key problems & answers
      -- my analysis and finding
       -- query to retrive all columns for sales  made on '2022-11-05'
       select  * from retail_sales
       where sale_date = '2022-11-05';
       
-- 2.query to retrive  all transactions where the category is 'colthing' and the quantity sold is more than 4 in the month of nov -2022
       
       select *
        from retail_sales
        where
        category ='Clothing' 
        and 
DATE_FORMAT(sale_date, '%Y-%m') = '2022-11' -- You need to replace DATE_FORMAT(sale_date, '%Y-%m')  to  with the Oracle or PostgreSQL databases. equivalent: TO_CHAR(sale_date, 'YYYY-MM')
and 
quantity >= 4  ;

-- 3.query to retrive to calculate the total sales (total_sales) for each category
select 
category,
sum(total_sale) as net_sale, 
count(*) as total_orders
from retail_sales 
group by category ;
 
 
 -- 4.query  to find avgerage age of customer who purchased items from the 'Beauty' categroy
 select
 round(avg(age),2) avg_age -- round gives us  floating point upto 2 we have mentioned 
 from retail_sales
 where category = 'Beauty';
 
 -- 5.sql query find all transaction where the total_sale is greater than 1000
 select  * from retail_sales
 where total_sale > 1000;
 
 -- 6. query to find  the total number  of tansaction (transactions_id) made by each gender in each categry
select 
category,
gender,
count(*) as total_trans
from retail_sales
group by category,gender
order by category,gender  ;
 
 
 -- 7.query to  caluclate  the avgerage sale for each month .find out best selling month in each year 
 
 select
 year,
 month,
 avg_sale
 from
 (
 select
 extract(year from sale_date) as year,
 extract( month from sale_date)as month,
 avg(total_sale)as avg_sale,
 rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as  ranking 
 from retail_sales
 group by 1,2
 ) as T1
 where ranking = 1 ;-- we have retrive the highest  avg_sale  in both 2022 and 2023
 
 
 -- 8. sql query to find the top 5 customer based on the highest total sales
 select 
  customer_id,
  sum(total_sale) as total_sales 
 from retail_sales
  group by 1
  order  by 2 desc 
  limit 5; 
  
  -- 9.sql query   to find the number of unique customer who purchased   items  from  each category
   select category,
   count(distinct customer_id) as cnt_unique_cs
   from   retail_sales
   group by  category;


-- 10. query to  create each shift  and number of order (example morning  < 12,afternoon between 12 & 17,evening >17)


with hour_sale  
as
(	
select *,
 case
  when extract(hour from sale_time) < 12 then 'Morning'
  when extract(hour from sale_time) between 12 and 17 then  'Afternoon'
  else 'Evening'
  end  as shift
  from retail_sales
  )
  select shift, 
  count(*) as totol_orders
  from hour_sale
  
  
## end of project 
  group by shift;
  
