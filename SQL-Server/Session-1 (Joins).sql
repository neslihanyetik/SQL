-- Combine Your Tables

use SampleSales

-- Tablolar arasındaki bağlantıyı joinler ile sağlıyoruz.

------ INNER JOIN ------

-- iki tablonun kesişim kümesini bize döndürür.

-- Question 1:
-- List products with category names
-- Select product ID, product name, category ID and category names
-- Ürünleri kategori isimleriyle listeleyiniz.
-- Limit sql server da yok, Top kullanıyoruz !!

SELECT A.product_id, A.product_name, B.category_id, B.category_name
FROM product.product AS A
INNER JOIN product.category AS B
ON  A.category_id = B.category_id;

-- Question 2:
-- List employees of stores with their store information
-- Select employee name, surname, store names
-- Mağaza çalışanlarının bilgisini istiyor. Çalışanlar staffs tablosunda mağaza bilgisi mevcut
-- fakat ismini bilmiyoruz bu yüzden store tablosuna gitmeliyiz.
-- employee sale içindeki staff tablosunda.

SELECT A.first_name, A.last_name, B.store_name
FROM sale.staff A
INNER JOIN sale.store B 
ON A.store_id = B.store_id;

------ LEFT JOIN ------

-- Soldaki yada önce yazılanları temel olarak alıp yazarız sağdaki tabladan ise eşleşenleri getitir.

-- Question 3:
-- Write a query that returns products that have never been ordered
-- Select product ID, product name, orderID
-- (Use Left Join)
-- Hiç sipariş edilmemiş ürünleri döndüren bir sorgu yazın

SELECT A.product_id, A.product_name, b.product_id
FROM product.product A
INNER JOIN sale.order_item B
ON A.product_id = B.product_id;
-- Hangi ürünün hangi siparişlerde verildiği bilgisini aldık left join ne içerdiğin öğrenmek için left join yaptık.

-- Bir product birden fazla siparişde bulunabilir. Tekrarlanan veri içeriğini engellemek için distinct kullanırız.

SELECT DISTINCT A.product_id, A.product_name, b.product_id
FROM product.product A
INNER JOIN sale.order_item B
ON A.product_id = B.product_id;

-- Product tablosundaki produkları alıp yanına order-item tablosunda bilgileri olanları getirirsek product tablosundaki tüm 
-- ürünlere ulaşırız. order_iitemleri NULL ise bu ürünler product da var ama sipariş almamış demektir.
SELECT A.product_id, A.product_name, b.product_id
FROM product.product A
LEFT JOIN sale.order_item B
ON A.product_id = B.product_id;

-- Sadece NULL ları çekmemiz gerek.
SELECT A.product_id, A.product_name, b.product_id
FROM product.product A
LEFT JOIN sale.order_item B
ON A.product_id = B.product_id
WHERE B.order_id IS NULL;

-- Burada inner join olmaz çünkü ikisinde mevcut olanları veriyor.

-- Question 4:
-- Report the stock status of the products that product id greater than 310 in the stores.
-- Expected columns: Product_id, Product_name, Store_id, quantity
-- Mağazalarda 310'dan büyük ürün kimliğine sahip ürünlerin stok durumunu bildirin.

SELECT A.product_id, A.product_name, B.store_id, B.quantity
FROM product.product A
LEFT JOIN product.stock B
ON A.product_id = B.product_id
WHERE B.product_id > 310
ORDER BY store_id ;

------ RIGHT JOIN ------

-- Sağdaki yada önce yazılanları temel olarak alıp yazarız soldaki tabladan ise eşleşenleri getitir.


-- Question 5:
-- Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores.

SELECT		A.product_id, B.product_name, A.store_id, A.quantity
FROM		product.stock A 
RIGHT JOIN product.product B  
ON A.product_id = B.product_id
WHERE		B.product_id > 310
ORDER BY	store_id;

-- Question 6:
---Report the orders information made by all staffs.
-- Expected columns: Staff_id, first_name, last_name, all the information about orders
-- Çalışanların yaptıkları siparişlerle ilgili bilgi istiyor fakat tüm çalışanları içermeli.

SELECT *
FROM sale.staff;

SELECT COUNT(staff_id)
FROM sale.staff;
-- 10 staff id var.


SELECT COUNT(DISTINCT A.staff_id)
FROM sale.staff A
INNER JOIN sale.orders B
ON A.staff_id = B.staff_id;
-- Keşisim ile şipariş alan çalışan sayısını bulduk. 6 staff id var.
-- Yani 4 çalışan hiç sipariş vermemiş.

SELECT	A.staff_id, A.first_name, A.last_name, B.order_id
FROM	sale.staff A 
INNER JOIN sale.orders B 
ON A.staff_id = B.staff_id 
-- Burada detaylı olarak olarak bilgileri aldık.

SELECT	A.staff_id, A.first_name, A.last_name, B.order_id
FROM	sale.staff A 
LEFT JOIN sale.orders B 
ON A.staff_id = B.staff_id


------ FULL OUTER JOIN ------

-- Sağ ve solda olan bütün kayıtları alır.

-- Question 7:
-- Write a query that returns stock and order information together for all products . (TOP 20)
-- Expected columns: Product_id, store_id, quantity, order_id, list_price
-- Tüm ürünler için stok ve sipariş bilgilerini döndüren sorgu yaz.

SELECT A.product_id, B.store_id, B.quantity, A.list_price
FROM sale.order_item A
FULL OUTER JOIN product.stock B
ON A.product_id = B.product_id
ORDER BY A.product_id, A.order_id ;

SELECT Top 20*
FROM sale.order_item A
FULL OUTER JOIN product.stock B
ON A.product_id = B.product_id
ORDER BY A.product_id, A.order_id ;