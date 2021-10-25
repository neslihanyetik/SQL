-------------- ROLLUP GRUPLAMA-------------

use SampleSales

--SYNTAX:
SELECT
		d1,
		d2,
		d3, 
		aggregate_function
FROM
		table_name
GROUP BY
		ROLLUP (d1,d2,d3);



--Summary Table--

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary
FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year




--brand, category, model_year sütunları için Rollup kullanarak total sales hesaplaması yapın.
--Bu sütun için 4 farklı gruplama varyasyonu üretmek istiyoruz.



SELECT	brand, Category, Model_Year, SUM(total_sales_price) total_price
FROM	sale.sales_summary
GROUP BY
		ROLLUP (brand, Category, Model_Year)



--------------- CUBE GRUPLAMA -------------

-- Gruplama kombinasyonu

SELECT
		d1,
		d2,
		d3, 
		aggregate_function
FROM
		table_name
GROUP BY
		CUBE (d1,d2,d3);

--  (d1,d2,d3)
--  (d1,d2) + (d1,d3) + (d2,d3)
--  (d1) + (d2) + (d3)   
--  ()


--brand, category, model_year sütunları için cube kullanarak total sales hesaplaması yapın.

--bu sütun için 8 farklı gruplama varyasyonu oluşturuyor	



SELECT	brand, Category, Model_Year, SUM(total_sales_price) total_price
FROM	sale.sales_summary
GROUP BY
		CUBE (brand, Category, Model_Year)
ORDER BY
		brand, Category



-------------- PIVOT -------------

-- Pivot satır halindeki sonucu sütuna çevirir. Ayrıca group by gerek yoktur.

--SYNTAX

SELECT [column_name], [pivot_value1], [pivot_value2], ...[pivot_value_n]
FROM
table_name
PIVOT
(
aggregate_function(aggregate_column)
FOR pivot_column
IN ([pivot_value1], [pivot_value2], ... [pivot_value_n])
) AS pivot_table_name;

-- Pivot ile başlayan kod bloğunda aggregate işlemi yapılır.

SELECT Category, Model_Year, SUM(total_sales_price)
FROM sale.sales_summary
GROUP BY Category, Model_Year

-- kategori ve yıla total sale aldık.

SELECT Category, Model_Year, SUM(total_sales_price)
FROM sale.sales_summary
GROUP BY Category, Model_Year
ORDER BY 1,2  -- 1. ve 2.sütuna göre

-- category sütununun satırlarını sütunlara alıp ve
-- total_sales_price'ları value olarak satırlara getiren pivot table yapıyoruz
SELECT *
FROM
	(
	SELECT Category, Model_Year, total_sales_price
	FROM	SALE.sales_summary -- kaynak tablo !! bu tablo üzererinde kategori ve yıla göre toplam satısı buluyoruzz.
	) A
PIVOT
	(
	SUM(total_sales_price)
	FOR Category
	IN (
            [Children Bicycles],
            [Comfort Bicycles],
            [Cruisers Bicycles],
            [Cyclocross Bicycles],
            [Electric Bikes],
            [Mountain Bikes],
            [Road Bikes]
		)
	) AS P1 -- pivot table isim verdik.


-- Bir tablodaki işlemi başka tabloda yapmak için kullanılan yöntemler: 
	
    -- Subqueries
	-- Views
	-- Common Table Expression (CTE's)

----------  SUBQUERY ------------

-- Bir sorgunun sonucunu başka sorguda kullanırız.
-- Select, where, ın From 
-- Where de kaç değer döndürdüğü önemli çünkü ona göre operatör değişiyor.

--- SINGLE ROW SUBQUERIES ---

-- Single row sub. operatörlerle kullanılır.
-- Subq. joinlerden hızlıdır.Tüm tabloya gitmediği için.

-- 1. Order ıd lerin toplam list_price larını istiyor.

SELECT order_id,
        (
            SELECT SUM(list_price) 
			FROM sale.order_item B
            WHERE A.order_id = B.order_id
        )
FROM sale.order_item A

---CORRELATED

SELECT DISTINCT order_id,
        (
            SELECT SUM(list_price) FROM sale.order_item B
            WHERE A.order_id = B.order_id
        )
FROM sale.order_item A



-- Maria Cussona nın çalıştığı mağazadaki tüm çalışanları istiyor.

SELECT first_name, last_name
FROM sale.staff
WHERE store_id = (
                SELECT store_id
                FROM sale.staff
                WHERE first_name = 'Maria'AND last_name = 'Cussona'
)

-- Jane Destrey in manager olduğu çalışanlar.

SELECT first_name, last_name
	FROM sale.staff
	WHERE manager_id = (
					SELECT staff_id
					FROM sale.staff
					WHERE first_name = 'Jane' AND last_name = 'Destrey'
					)
-- Holbrook şehrinde oturan müşterilerin sipariş tarihlerini listeleyin.

SELECT	customer_id, order_id, order_date
FROM	SALE.orders
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	SALE.customer
						WHERE	city = 'Holbrook'
						)

-- Abby	Parks isimli müşterinin alışveriş yaptığı tarihte/tarihlerde alışveriş yapan tüm müşterileri listeleyin.Müşteri adı, soyadı ve sipariş tarihi bilgilerini listeleyin.

SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE order_date IN (
					SELECT order_date
					FROM Sale.customer A
					JOIN Sale.orders B
					ON A.customer_id = B.customer_id
					WHERE first_name = 'Abby' AND last_name = 'Parks'
					)

-------

SELECT	C.first_name, C.last_name, A.order_id, A.order_date
FROM	sale.orders A 
INNER JOIN (
			SELECT	A.first_name, A.last_name, B.customer_id, B.order_id, B.order_date
			FROM	sale.customer A 
			INNER JOIN sale.orders B 
			ON A.customer_id = B.customer_id
			WHERE	A.last_name = 'Parks' AND A.first_name = 'Abby'
			) B 
ON A.order_date = B.order_date
INNER JOIN sale.customer C ON A.customer_id = C.customer_id


-- subq. gelen order date ile diğer order date aynı olması gerekiyor. 

-- Bütün elektrikli bisikletlerden pahalı olan bisikletleri listelyin.
-- Ürün adı, model_yılı ve fiyat bilgilerini yüksek fiyattan düşük fiyata doğru sıralayınız.


SELECT	list_price
FROM	product.product A INNER JOIN product.category B ON A.category_id = B.category_id
WHERE	B.category_name = 'Electric Bikes'
ORDER BY 
		1



SELECT	product_name, list_price
FROM	product.product 
WHERE	list_price > ALL (
							SELECT	list_price
							FROM	product.product A 
							INNER JOIN product.category B 
							ON A.category_id = B.category_id
							WHERE	B.category_name = 'Electric Bikes'
							)
AND		model_year = 2020


--


SELECT	product_name, list_price
FROM	product.product 
WHERE	list_price > ANY (
							SELECT	list_price
							FROM	product.product A 
							INNER JOIN product.category B 
							ON A.category_id = B.category_id
							WHERE	B.category_name = 'Electric Bikes'
							)
AND		model_year = 2020





---------



SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE EXISTS (
					SELECT 1
					FROM Sale.customer A
					JOIN Sale.orders B
					ON A.customer_id = B.customer_id
					WHERE first_name = 'Abby' AND last_name = 'Parks'
					)

---CORRELATED



SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE EXISTS (
					SELECT 1
					FROM Sale.customer C
					JOIN Sale.orders D
					ON C.customer_id = D.customer_id
					WHERE first_name = 'Abby' AND last_name = 'Parks'
					AND		A.order_date = D.order_date
					)



---

SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE NOT EXISTS (
					SELECT 1
					FROM Sale.customer A
					JOIN Sale.orders B
					ON A.customer_id = B.customer_id
					WHERE first_name = 'Abbay' AND last_name = 'Parks'
					)




