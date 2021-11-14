
-- What is the sales quantity of product according to the brands and sort them highest-lowest
-- (Markalara göre ürünün satýþ miktarý nedir ve bunlarý en yüksek-en düþük olarak sýralayýnýz.)

select B.brand_name, count(C.quantity) as quantity_of_product
from product.product A
inner join product.brand B on A.brand_id=B.brand_id
inner join sale.order_item C on A.product_id=C.product_id
group by B.brand_name 
order by quantity_of_product desc;

-- Select the top 5 most expensive products

select top 5 product_name, list_price
from product.product
order by list_price desc;

-- What are the categories that each brand has

select B.brand_name, C.category_name
from product.product A
inner join product.brand B on A.brand_id=B.brand_id
inner join product.category C on A.category_id=C.category_id
group by B.brand_name, C.category_name

-- Select the avg prices according to brands and categories

select B.brand_name, C.category_name, AVG(A.list_price) as avg_price
from product.product A
inner join product.brand B on A.brand_id=B.brand_id
inner join product.category C on A.category_id=C.category_id
group by B.brand_name, C.category_name
order by avg_price desc;

-- Select the annual amount of product produced according to brands

select B.brand_name, count(A.product_name) as cnt_product, A.model_year 
from product.product A
inner join product.brand B on A.brand_id=B.brand_id
inner join product.stock C on A.product_id=C.product_id
group by B.brand_name, A.model_year
order by A.model_year

-- Select the least 3 products in stock according to stores.

select top 3 B.brand_name, count(A.product_name) as cnt_product, A.model_year 
from product.product A
inner join product.brand B on A.brand_id=B.brand_id
inner join product.stock C on A.product_id=C.product_id
group by B.brand_name, A.model_year
order by count(A.product_name) asc;

-- Select the store which has the most sales quantity in 2018(

 select top 1  A.store_name , SUM(C.quantity ) as most_sales_quantity
	from sale.store A, sale.orders B, sale.order_item C
	where A.store_id =B.store_id and B.order_id=C.order_id 
	and order_date between '2018-01-01' and '2018-12-31'
    group by  A.store_name
	order by most_sales_quantity desc;

-- Select the store which has the most sales amount in 2018

select top 1  A.store_name , SUM(C.list_price ) as most_sales_price
	from sale.store A, sale.orders B, sale.order_item C
	where A.store_id =B.store_id and B.order_id=C.order_id 
	and order_date between '2018-01-01' and '2018-12-31'
    group by  A.store_name
	order by most_sales_price desc;

-- Select the personnel which has the most sales amount in 2018

select top 1  A.first_name ,A.last_name, sum(C.list_price ) as most_sales_amount
	from sale.staff A, sale.orders B, sale.order_item C
	where A.store_id =B.store_id and B.order_id=C.order_id 
	and order_date between '2018-01-01' and '2018-12-31'
    group by  A.first_name ,A.last_name
	order by most_sales_amount desc;

-- Select the least 3 sold products in 2018 and 2019 according to city.

select top 3 D.city, A.product_name, sum(B.quantity) as least3 
from product.product A, sale.order_item B, sale.orders C, sale.store D
where A.product_id=B.product_id and B.order_id=C.order_id and C.store_id=D.store_id 
and (year(order_date)=2018 or year(order_date)=2019)
group by D.city, A.product_name
order by least3 asc;

