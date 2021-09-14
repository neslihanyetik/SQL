/*
Weather Observation Station 20
*/

SELECT CAST(LAT_N AS DECIMAL (7,4))
FROM
    (SELECT LAT_N, ROW_NUMBER() OVER (ORDER BY LAT_N) as ROWNU 
     FROM STATION 
     ) AS X
WHERE ROWNU = ( SELECT ROUND((COUNT(LAT_N)+1)/2,0) 
                FROM STATION
               );