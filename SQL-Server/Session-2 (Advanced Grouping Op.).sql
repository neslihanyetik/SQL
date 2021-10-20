-- Session-2 - 0921 (Advanced Grouping Op.)

use SampleSales

-- Question 1:
-- Report the orders information made by all sataff.
-- Expected columns: Staff_id, first_name, last_name, , all the information about orders.
-- Tüm personel tarafından yapılan sipariş bilgilerini bildirin.


SELECT A.staff_id, A.first_name, A.last_name, B.staff_id
FROM sale.staff A
LEFT JOIN sale.orders B
ON A.staff_id = B.staff_id
ORDER BY B.order_id;


SELECT	COUNT (DISTINCT A.staff_id) , COUNT (DISTINCT B.staff_id)
FROM sale.staff A 
INNER JOIN SALE.orders B 
ON A.staff_id = B.staff_id;


SELECT	COUNT (DISTINCT A.staff_id) , COUNT (DISTINCT B.staff_id)
FROM sale.staff A 
LEFT JOIN SALE.orders B 
ON A.staff_id = B.staff_id;


------ CROSS JOIN ------

-- Tablodaki tüm değerlerin birbiriyle nasıl eşleşeceğini görmek istiyoruz. 

-- Question 2:
-- White a query that returns all brand X category possibilities.
-- Expected columns: brand_id,brand_name,category_id,category_name
-- Hangi markada hangi kategoride kaçar ürün olduğu bilgisine ihtiyaç duyulur.

SELECT B.brand_id, B.brand_name, A.category_name, A.category_id
FROM product.category A 
CROSS JOIN product.brand B;

------ SELF JOIN ------

-- Bir tablonun kendisiyle join yapılmasıdır.

-- Question 3:
-- Write a query that returns The staffs with their managers.
-- Expected columns: staff first name, staff last name, manager name 
-- Çalışanları yöneticileriyle birlikte döndüren bir sorgu yazın.

SELECT A.first_name, A.last_name, B.first_name AS manager_name
FROM sale.staff A
INNER JOIN sale.staff B
ON A.manager_id = B.staff_id
-- A daki maneger B deki staff olacak.

-------- Advanced Grouping Operations --------

-- Grouping + Aggregation
-- Having yapılan aggregation işlemini ilgili condition vermek için kulllanılır.
-- Nasıl bir filtreleme yapacağımızı having ile elde ediyoruz.
-- Group by olmadan having kullanamayız.
---- SQL kendi içindeki sıralaması:
   -- FROM	
   -- WHERE	
   -- GROUP BY
   -- HAVING 
   -- SELECT 
   -- ORDER BY	
   	

-- Question 4:
-- Write a query that checks if any product id is repeated in more than one row in the products table.
-- Ürünler tablosunda birden fazla satırda herhangi bir ürün kimliğinin yinelenip yinelenmediğini denetleyen bir sorgu yazın.

SELECT product_id, COUNT(*) CNT_PRODUCT
FROM product.product
GROUP BY product_id
HAVING COUNT(*) > 1

-- Question 5:
-- Write a query that returns category ids with a max. list price above 4000 or a min list price below 500.
-- 4000 den büyük 500 den küçük  list price sahip kategorileri istiyor.

SELECT category_id, MAX(list_price) AS MAX_PRİCE, MIN(list_price) AS MİN_PRİCE
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 or MIN(list_price) < 500


-- Question 6:
-- Find the average product prices of the brands. As a result of the query, the average prices should be
-- displayed in descending order.
-- Markalara göre ürün fiyatlarını alınız. Ortalama fiyatlara göre azalan sırayla gösteriniz.

SELECT	B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM	product.product A, product.brand B -- inner join burası , ile yaptık on yerine where yapıyoruz. 
WHERE	A.brand_id = B.brand_id
GROUP BY
		B.brand_id, B.brand_name
ORDER BY 
		avg_price DESC

-- Question 7:
-- Ortalama ürün fiyatı 1000' den yüksek olan MARKALARI getiriniz.

SELECT	B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
GROUP BY
		B.brand_id, B.brand_name
HAVING	AVG(A.list_price) > 1000
ORDER BY 
		avg_price DESC


-- Question 8:
-- Write a query that returns the net price paid by the customer for each
-- order.(Dont neglect discounts and quantities).

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales
FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


-------- GROUPING SETS --------

-- Farklı  gruplama kombinasyoları yapmak için kullanılır.

SELECT *
FROM	sale.sales_summary


-- Question 9:
-- Toplam sales miktarını hesaplayınız.


SELECT	SUM(total_sales_price)
FROM	sale.sales_summary

-- Question 10:
-- Markaların toplam sales miktarını hesaplayınız.


SELECT	brand, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	brand

-- Question 11:
-- Kategori bazında yapılan toplam sales miktarını hesaplayınız.


SELECT	Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY Category

-- Question 12:
-- Marka ve kategori kırılımındaki toplam sales miktarını hesaplayınız.


SELECT	brand, Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	brand, Category
ORDER BY brand



----

SELECT	brand, category, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		GROUPING SETS (
				(brand, category),
				(brand),
				(category),
				()
				)
ORDER BY
	brand, category


