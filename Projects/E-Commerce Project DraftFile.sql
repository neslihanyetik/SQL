use ECOMMERCE

--DAwSQL Session -8 

--E-Commerce Project Solution



--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

--1. Tüm tablolara katılın ve combined_table adlı yeni bir tablo oluşturun. 

select * into combined_table from 
 
 (select A.Sales, A.Discount,A.Order_Quantity,A.Product_Base_Margin, B.*,C.*,D.*,E.*
  from market_fact_new A
        FULL OUTER JOIN orders_dimen B ON B.Ord_id = A.Ord_id
        FULL OUTER JOIN prod_dimen_new C ON C.Prod_id = A.Prod_id
        FULL OUTER JOIN cust_dimen D ON D.Cust_id = A.Cust_id
        FULL OUTER JOIN shipping_dimen_new E ON E.Ship_id = A.Ship_id )  S ;

Select * from combined_table


--///////////////////////


--2. Find the top 3 customers who have the maximum count of ord ers.

--2. Maksimum sipariş sayısına sahip en iyi 3 müşteriyi bulun.

SELECT TOP 3 Cust_id, COUNT(Ord_id) AS CountOfOrders
FROM  combined_table
GROUP BY Cust_id
ORDER BY CountOfOrders DESC;



--/////////////////////////////////



--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

--3.Combined_table'da Order_Date ve Ship_Date tarih farkını içeren Teslimat için Geçen Günler olarak yeni bir sütun oluşturun.
--Vb TABLO"," UPDATE "ALTER" kullanın.

ALTER TABLE combined_table ADD DaysTakenForDelivery INT;

UPDATE combined_table
SET DaysTakenForDelivery = DATEDIFF(DAY, Order_Date,Ship_Date)

SELECT * From combined_table;

--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"

--4. Siparişi teslim almak için en fazla zaman alan müşteriyi bulun. "MAX" veya "TOP" kullanın

-- Solition1:

SELECT Customer_Name,Cust_id,Order_Date,Ship_Date, DaysTakenForDelivery
FROM combined_table
WHERE DaysTakenForDelivery = (Select MAX(DaysTakenForDelivery)
                                FROM combined_table)
 

-- Solition2:

SELECT TOP 1 Cust_id, Customer_Name, MAX(DaysTakenForDelivery) as max_delivered
FROM combined_table
GROUP BY Cust_id, Customer_Name
ORDER BY max_delivered DESC;

--////////////////////////////////



--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--You can use such date functions and subqueries


--5. Ocak ayındaki toplam benzersiz müşteri sayısını ve bunların 2011 yılı boyunca her ay kaç tanesinin geri geldiğini sayın
--Bu tür tarih işlevlerini ve alt sorguları kullanabilirsiniz

SELECT MONTH(Order_Date) as month, COUNT(DISTINCT Cust_id) AS customer_count
FROM  combined_table
WHERE Cust_id IN (
                    Select Cust_id 
                    FROM combined_table
                    WHERE YEAR(Order_Date) =  2011 and MONTH(Order_Date) = 01 
                )

AND YEAR(Order_Date) = 2011
GROUP BY MONTH(Order_Date)

--////////////////////////////////////////////

--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID

--Use "MIN" with Window Functions
--6. her kullanıcı için ilk satın alma ile üçüncü satın alma arasında geçen süreyi döndürmek üzere bir sorgu yazın,
----müşteri kimliğine göre artan sırada

-- SOLUTION-1

SELECT DISTINCT Cust_id,
		Order_date,
		dense_number,
		FIRST_ORDER_DATE,
		DATEDIFF(day, FIRST_ORDER_DATE, order_date) DAYS_ELAPSED

FROM (SELECT Cust_id, Order_Date,
			MIN (Order_Date) OVER (PARTITION BY Cust_id) FIRST_ORDER_DATE,
			DENSE_RANK () OVER (PARTITION BY Cust_id ORDER BY Order_date) dense_number
FROM combined_table) A
WHERE	dense_number = 3

 -- SOLUTION-2

 WITH T1 AS
 (SELECT Cust_id, Order_Date,
			MIN (Order_Date) OVER (PARTITION BY Cust_id) FIRST_ORDER_DATE,
			DENSE_RANK () OVER (PARTITION BY Cust_id ORDER BY Order_date) dense_number
FROM combined_table)

SELECT DISTINCT Cust_id,
		Order_date,
		dense_number,
		FIRST_ORDER_DATE,
		DATEDIFF(day, FIRST_ORDER_DATE, order_date) DAYS_ELAPSED
FROM T1
WHERE	dense_number = 3



--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions

--7. Hem ürün 11 hem de ürün 14'ü satın alan müşterileri döndüren bir sorgu yazın,
--bu ürünlerin müşteri tarafından satın alınan toplam ürün sayısına oranının yanı sıra.
--CASE Expression, CTE, CAST VE benzeri Toplama İşlevlerini kullanın

-- SOLUTION-1:

SELECT Cust_id,
       SUM(CASE WHEN Prod_id = 'Prod_11' THEN Order_Quantity ELSE 0 END) AS P11,
       SUM(CASE WHEN Prod_id = 'Prod_14' THEN Order_Quantity ELSE 0 END) AS P14,
       SUM(Order_Quantity) AS TotalProd,
       ROUND(CAST(SUM(CASE WHEN Prod_id = 'Prod_11' THEN Order_Quantity ELSE 0 END) AS FLOAT) / SUM(Order_Quantity),2) AS RATIO_P11,
       ROUND(CAST(SUM(CASE WHEN Prod_id = 'Prod_14' THEN Order_Quantity ELSE 0 END) AS FLOAT) / SUM(Order_Quantity),2) AS RATIO_P14
FROM combined_table
WHERE Cust_id IN(SELECT Cust_id
		 FROM combined_table
		 WHERE Prod_id IN ('Prod_11', 'Prod_14')
		 GROUP BY Cust_id
		 HAVING COUNT(DISTINCT Prod_id)=2)
GROUP BY Cust_id;

-- SOLUTION-2:

WITH T1 AS (
SELECT Cust_id, 
		SUM(CASE WHEN Prod_id = '11' THEN Order_Quantity ELSE 0 END) P11,
		SUM(CASE WHEN Prod_id = '14' THEN Order_Quantity ELSE 0 END) P14,
		SUM(Order_Quantity) TOTAL_PROD
FROM combined_table
GROUP BY Cust_id 
HAVING 
	    SUM(CASE WHEN Prod_id = '11' THEN Order_Quantity ELSE 0 END) >=1 AND
		SUM(CASE WHEN Prod_id = '14' THEN Order_Quantity ELSE 0 END) >=1
)
SELECT Cust_id, P11, P14, TOTAL_PROD,
	   ROUND(CAST( P11 as float)/CAST (TOTAL_PROD as float), 2) RATIO_P11,
	   ROUND(CAST( P14 as float)/CAST (TOTAL_PROD as float), 2) RATIO_P14
FROM T1
ORDER BY Cust_id

--/////////////////



--CUSTOMER RETENTION ANALYSIS



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

--1. Müşterilerin ziyaret günlüklerini aylık olarak tutan bir görünüm oluşturun. (Her günlük için üç alan tutulur: Cust_id, Yıl, Ay)
--Bu tür tarih işlevlerini kullanın. Daha sonra ihtiyacınız olabilecek sütunları aramayı unutmayın.

CREATE VIEW customer_logs AS

SELECT cust_id,
				DATEPART(YEAR,Order_Date) AS [YEAR],
				DATEPART(MONTH, Order_date) AS [MONTH]

FROM combined_table


SELECT * FROM customer_logs
ORDER BY 1,2,3



--//////////////////////////////////


--2. Create a view that keeps the number of monthly visits by users. (Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.

--2. Kullanıcıların aylık ziyaret sayısını tutan bir görünüm oluşturun. (Ayrı iş her ay başında)
--Daha sonra ihtiyacın olabilecek sütunları aramayı unutma.


CREATE VIEW monthly_visits AS
       SELECT Cust_id, 
	      YEAR(Order_Date) AS [YEAR], 
	      MONTH(Order_Date) AS [MONTH],
	      COUNT(Order_Date) AS NUM_OF_LOG
       FROM combined_table
       GROUP BY Cust_id, YEAR(Order_Date), MONTH(Order_Date);


SELECT * FROM monthly_visits

--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.

--3. Müşterilerin her ziyareti için, ziyaretin bir sonraki ayını ayrı bir sütun olarak oluşturun.
--"DENSE_RANK" fonksiyonu ile ayları numaralandırabilirsiniz.
--ardından, yaptığınız numaralandırmayı kullanarak her ay için bir sonraki ayı gösteren yeni bir sütun oluşturun.
-- ("KURŞUN" işlevini kullanın.)
--Daha sonra ihtiyacın olabilecek sütunları aramayı unutma.

CREATE VIEW next_month_visits AS
       SELECT *, LEAD(current_month) OVER(PARTITION BY Cust_id ORDER BY [YEAR], [MONTH]) AS next_visit_month
       FROM (SELECT *, DENSE_RANK() OVER(ORDER BY [YEAR], [MONTH]) AS current_month 
	     FROM monthly_visits) AS M

SELECT * FROM next_month_visits

--/////////////////////////////////



--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.

--4. Her müşteri tarafından ardışık iki ziyaret arasındaki aylık zaman farkını hesaplayın.
--Daha sonra ihtiyacın olabilecek sütunları aramayı unutma.


CREATE VIEW monthly_time_gap AS
       SELECT *, next_visit_month-current_month AS TimeGaps
       FROM next_month_visits


SELECT * From monthly_time_gap


--/////////////////////////////////////////


--5.Categorise customers using time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc.

--5.Müşterileri zaman aralıklarını kullanarak kategorilere ayırın. Sizin için en uygun etiketleme modelini seçin.
-- Örneğin:
-- Müşteri ilk satın alımını yaptığından bu yana geçen aylarda başka bir satın alma işlemi yapmadıysa, yayık olarak etiketlenir.
-- Müşteri her ay bir satın alma işlemi yaptıysa normal olarak etiketlenir.
-- Vb.


SELECT Cust_id, AVG(TimeGaps) AS AvgTimeGap,
       CASE WHEN AVG(TimeGaps) IS NULL THEN 'Churn'
	    WHEN MAX(TimeGaps) = 1 THEN 'regular'
	    ELSE 'irregular'	
       END CustLabels
FROM monthly_time_gap
GROUP BY Cust_id;



--/////////////////////////////////////




--MONTH-WİSE RETENTİON RATE


--Find month-by-month customer retention rate  since the start of the business.
--Bu iş başladığından beri-bul ay-by-ay müşteri tutma oranı.

--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

--1. Aylık olarak tutulan müşteri sayısını bulun. (Zaman boşluklarını kullanabilirsiniz)
--Kullanım Süresi Boşlukları


SELECT *, COUNT(Cust_id) OVER(PARTITION BY [YEAR], [MONTH]) AS RetentionMonthWise
FROM monthly_time_gap
WHERE TimeGaps=1
ORDER BY Cust_id;


--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Total Number of Customers in The Previous Month / Number of Customers Retained in The Next Nonth

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.

--2. Aylık saklama oranını hesaplayın.

--Temel formül: o Aylık Saklama Oranı = 1.0 * Bir Önceki Aydaki Toplam Müşteri Sayısı / Bir Sonraki Ayda Tutulan Müşteri Sayısı

--İşlemleri tek bir geçici sorgu yerine parçalara bölmek daha kolaydır. Görünümü kullanmanız önerilir.



WITH CTE1 AS
     (SELECT [YEAR], [MONTH], COUNT(Cust_id) AS TotalCustomerPerMonth,
      SUM(CASE WHEN TimeGaps=1 THEN 1 END) AS RetentionMonthWise
      FROM monthly_time_gap
      GROUP BY [YEAR], [MONTH])
SELECT *
FROM(SELECT [YEAR], [MONTH], LAG(RetentionRate) OVER(ORDER BY [YEAR], [MONTH]) AS RetentionRate
     FROM(SELECT CTE1.[YEAR], CTE1.[MONTH],
		 ROUND(CAST(CTE1.RetentionMonthWise AS FLOAT) / CTE1.TotalCustomerPerMonth,2) AS RetentionRate
          FROM CTE1) AS SUBQ1) AS SUBQ2
WHERE RetentionRate IS NOT NULL



---///////////////////////////////////
--Good luck!