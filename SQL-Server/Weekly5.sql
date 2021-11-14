use SampleSales

-- Select the annual amount of product produced according to brands
-- Markalara göre üretilen yıllık ürün miktarını seçin

SELECT  B.brand_name, A.model_year , count(C.quantity) as annual_amount_of_product
FROM product.product A

INNER JOIN product.brand B 
on A.brand_id = B.brand_id

INNER JOIN product.stock C 
on A.product_id= C.product_id

GROUP BY  B.brand_name, A.model_year
ORDER BY B.brand_name ;



-- Select the store which has the most sales quantity in 2018
-- 2018'de en çok satış miktarına sahip mağazayı seçin

SELECT TOP 1 A.store_name , COUNT(C.quantity ) AS most_sales_quantity
	FROM sale.store A, sale.orders B, sale.order_item C
	WHERE A.store_id = B.store_id AND B.order_id = C.order_id  AND year(B.order_date)= 2018
    GROUP BY  A.store_name
	ORDER BY most_sales_quantity DESC;

-- Select the store which has the most sales amount in 2018
-- 2018'de en fazla satış tutarına sahip mağazayı seçin

SELECT TOP 1  A.store_name , sum((C.quantity*C.list_price)*(1-C.discount)) AS most_amount
	FROM sale.store A, sale.orders B, sale.order_item C
	WHERE A.store_id =B.store_id AND B.order_id=C.order_id  AND year(B.order_date)= 2018
    GROUP BY  A.store_name
	ORDER BY most_amount DESC;



-- Select the personnel which has the most sales amount in 2018
-- 2018 yılında en fazla satış tutarına sahip personeli seçin

 
SELECT TOP 1 A.first_name, A.last_name , sum((C.quantity*C.list_price)*(1-C.discount)) AS most_amount
	FROM sale.staff A, sale.orders B, sale.order_item C
	WHERE A.staff_id =B.staff_id AND B.order_id=C.order_id  AND year(B.order_date)= 2018
    GROUP BY A.first_name, A.last_name
	ORDER BY most_amount DESC;

