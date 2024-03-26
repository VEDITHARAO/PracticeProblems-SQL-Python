/*
Create table If Not Exists Flights (departure_airport int, arrival_airport int, flights_count int)
Truncate table Flights
insert into Flights (departure_airport, arrival_airport, flights_count) values ('1', '2', '4')
insert into Flights (departure_airport, arrival_airport, flights_count) values ('2', '1', '5')
insert into Flights (departure_airport, arrival_airport, flights_count) values ('2', '4', '5')
*/

/*
Table: Flights

+-------------------+------+
| Column Name       | Type |
+-------------------+------+
| departure_airport | int  |
| arrival_airport   | int  |
| flights_count     | int  |
+-------------------+------+
(departure_airport, arrival_airport) is the primary key column for this table.
Each row of this table indicates that there were flights_count flights that departed from departure_airport and arrived at arrival_airport.
 

Write an SQL query to report the ID of the airport with the most traffic. The airport with the most traffic is the airport that has the largest total number of flights that either departed from or arrived at the airport. If there is more than one airport with the most traffic, report them all.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Flights table:
+-------------------+-----------------+---------------+
| departure_airport | arrival_airport | flights_count |
+-------------------+-----------------+---------------+
| 1                 | 2               | 4             |
| 2                 | 1               | 5             |
| 2                 | 4               | 5             |
+-------------------+-----------------+---------------+
Output: 
+------------+
| airport_id |
+------------+
| 2          |
+------------+
Explanation: 
Airport 1 was engaged with 9 flights (4 departures, 5 arrivals).
Airport 2 was engaged with 14 flights (10 departures, 4 arrivals).
Airport 4 was engaged with 5 flights (5 arrivals).
The airport with the most traffic is airport 2.
Example 2:

Input: 
Flights table:
+-------------------+-----------------+---------------+
| departure_airport | arrival_airport | flights_count |
+-------------------+-----------------+---------------+
| 1                 | 2               | 4             |
| 2                 | 1               | 5             |
| 3                 | 4               | 5             |
| 4                 | 3               | 4             |
| 5                 | 6               | 7             |
+-------------------+-----------------+---------------+
Output: 
+------------+
| airport_id |
+------------+
| 1          |
| 2          |
| 3          |
| 4          |
+------------+
Explanation: 
Airport 1 was engaged with 9 flights (4 departures, 5 arrivals).
Airport 2 was engaged with 9 flights (5 departures, 4 arrivals).
Airport 3 was engaged with 9 flights (5 departures, 4 arrivals).
Airport 4 was engaged with 9 flights (4 departures, 5 arrivals).
Airport 5 was engaged with 7 flights (7 departures).
Airport 6 was engaged with 7 flights (7 arrivals).
The airports with the most traffic are airports 1, 2, 3, and 4.
*/

--SOLUTION
# Write your MySQL query statement below
#each distinct airport_id find the total count
#of flights by using the flights_count
#get the airport ids with max number of flights with rank

WITH CTE AS (
  SELECT airport_id, RANK() OVER(ORDER BY SUM(flights_count) DESC) AS RN
  FROM ( SELECT departure_airport AS airport_id, flights_count FROM Flights
           UNION ALL
       SELECT arrival_airport AS airport_id, flights_count FROM Flights ) T
  GROUP BY airport_id )

SELECT airport_id FROM CTE WHERE RN = 1;

/*
SELECT departure_airport AS airport_id, flights_count FROM Flights
           UNION ALL
SELECT arrival_airport AS airport_id, flights_count FROM Flights;

| airport_id | flights_count |
| ---------- | ------------- |
| 1          | 4             |
| 2          | 5             |
| 2          | 5             |
| 2          | 4             |
| 1          | 5             |
| 4          | 5             |

SELECT airport_id, RANK() OVER(ORDER BY SUM(flights_count) DESC) AS RN
FROM ( SELECT departure_airport AS airport_id, flights_count FROM Flights
         UNION ALL
     SELECT arrival_airport AS airport_id, flights_count FROM Flights ) T
GROUP BY airport_id ;
| airport_id | RN |
| ---------- | -- |
| 2          | 1  |
| 1          | 2  |
| 4          | 3  |
  
*/
