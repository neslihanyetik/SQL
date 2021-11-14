/* Session:1: October 14th 2021 */
------ INNER JOIN ------

-- List products with category names
-- Select product ID, product name, category ID and category names

SELECT TOP 20 A.product_id, A.product_name, B.category_id, B.category_name
FROM product.product A
INNER JOIN product.category B ON A.category_id = B.category_id;

SELECT B.product_id, B.product_name, A.category_id, A.category_name
FROM product.category A
INNER JOIN product.product B ON A.category_id = B.category_id;

SELECT TOP 10 A.product_id, A.product_name, B.category_id, B.category_name
FROM product.product A, product.category B
WHERE A.category_id = B.category_id;
----------------------------------------------------------
--list of all employees and the store they are working in 
SELECT A.first_name, A.last_name, B.store_name
FROM sale.staff A
INNER JOIN [sale].[store] B ON A.store_id = B.store_id;
----------------------------------------------------------
------ LEFT JOIN ------

-- Write a query that returns products that have never been ordered
--Select product ID, product name, orderID
--(Use Left Join)

SELECT A.product_id, A.product_name, B.order_id
FROM product.product A
LEFT JOIN sale.order_item B ON A.product_id = B.product_id
--group by A.product_id, A.product_name, B.order_id
WHERE B.order_id IS NULL 


--------------

--SELECT  B.Product_id,A.product_id,  Count(B.order_id) as total_count
--FROM product.product A
--LEFT JOIN sale.order_item B ON A.product_id = B.product_id
--group by B.product_id
----WHERE B.order_id IS NULL OR 
--ORDER BY 1
---------------------------------------------------------

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity

SELECT A.product_id, A.product_name, B.store_id,B.quantity
FROM product.product A
  LEFT JOIN product.stock B ON A.product_id = B.product_id
  WHERE A.product_id > 310;
  --------------------------------------------

  SELECT B.product_id, B.product_name, A.store_id, A.quantity
  FROM product.stock A
    RIGHT JOIN product.product B ON A.product_id = B.product_id
	WHERE B.product_id > 310;
	----------------------------------------------


	
SELECT A.product_id, A.product_name, B.store_id,B.quantity
FROM product.product A
  RIGHT JOIN product.stock B ON A.product_id = B.product_id
  WHERE A.product_id > 310;

---------------------------------------------------------------------
--//////

---Report the orders information made by all staffs.
--Expected columns: Staff_id, first_name, last_name, all the information about orders

SELECT STF.staff_id, STF.first_name, STF.last_name, ORD.*
FROM sale.orders ORD
  RIGHT JOIN sale.staff STF ON ORD.staff_id = STF.staff_id
  ORDER BY ORD.order_id, STF.staff_id

  select * 
  FROM sale.staff


  select distinct staff_id from sale.orders
  order by 1;