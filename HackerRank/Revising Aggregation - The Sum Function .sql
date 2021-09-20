/*Revising Aggregations - The Sum Function

Query the total population of all cities in CITY where District is California.

*/
SELECT  SUM(POPULATION)
FROM CITY
WHERE District = 'CALIFORNIA';