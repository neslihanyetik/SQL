/* Octover 16th 2021 - Session: 2: Part: 1 */

select category_name, count(product_id) as cnt_product
from product.product A
JOIN product.category B ON A.category_id = B.category_id
GROUP BY category_name


select * from product.product

select * from product.category
/*
How many ? (COUNT) - how many of a particular item has been ordered
How much ? (SUM) -- whats the total sales for last year ?
The average ? (AVG) -- Whats the average amount of sales per customer?
Largest or highest ? (MAX)
Smallest or lowest ? (MIN) -- what is our most or least popular item?

*/

--GROUPING OPERATIONS

--HAVING
--Write a query that checks if any product id is repeated in more than one row in the product table.

SELECT product_id, count(product_id) num_of_rows
FROM product.product 
GROUP BY product_id
	HAVING count(product_id) >1 
--List all products that have been ordered in more than 100 orders


select O.product_id, P.product_name, count(O.product_id) numOfOrders
FROM sale.order_item O  
 JOIN product.product P ON O.product_id = P.product_id
GROUP BY O.product_id, P.product_name
 HAVING count(O.product_id) > 100
 ORDER BY 3 DESC

 select * from sale.order_item
-----------------------------------------------------------
--///////

--Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500.

SELECT category_id, MAX(list_price) as max_price, MIN(list_price) as min_price
FROM product.product
GROUP BY category_id
 HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500 
 --AND category_id > 5
 ORDER BY 2, 3

select * FROM product.product

---/////

--Find the average product prices of the brands.
--As a result of the query, the average prices should be displayed in descending order.

SELECT B.brand_name, ROUND(AVG(list_price),2) as avg_list_price
FROM product.product A
 JOIN product.brand B ON A.brand_id = B.brand_id
 GROUP BY B.brand_name
 ORDER BY AVG(list_price) DESC;

SELECT B.brand_name, ROUND(AVG(list_price),2) as avg_list_price
FROM product.product A,product.brand B 
WHERE A.brand_id = B.brand_id
 GROUP BY B.brand_name
 ORDER BY AVG(list_price) DESC;

 select brand_name, MAX(len(brand_name))
 from product.brand 
 group by brand_name
 order by 2 desc
 ---------------------------------------------------
 
--////

--Write a query that returns BRANDS with an average product price of more than 1000.

SELECT B.brand_name , ROUND(AVG(list_price),2) as avg_list_price
FROM product.product A
JOIN product.brand B ON A.brand_id = B.brand_id
GROUP BY B.brand_name
HAVING AVG(list_price) > 1000

SELECT B.brand_name, ROUND(AVG(list_price),2) as avg_list_price
FROM product.product A,product.brand B 
WHERE A.brand_id = B.brand_id
 GROUP BY B.brand_name
 HAVING AVG(list_price) > 1000
 ORDER BY AVG(list_price) DESC;

 ---------------------------------------------------------
 --Write a query that returns the net price paid by customer for each order

 SELECT *
 FROM sale.order_item

 SELECT order_id, SUM(quantity * list_price * (1-discount)) as net_price
  FROM sale.order_item
  GROUP BY order_id
  -----------------------
  --Create a table out of result set
-----------------------------------------------------------
--SELECT <Columns> 
--INTO <New Table Name>
--FROM <Table names> 
--WHERE <condition>
--------------------------------------------------------------
 SELECT order_id, SUM(quantity * list_price * (1-discount)) as net_price
 INTO #testsession2
  FROM sale.order_item
  GROUP BY order_id

  --select * from testsession2














