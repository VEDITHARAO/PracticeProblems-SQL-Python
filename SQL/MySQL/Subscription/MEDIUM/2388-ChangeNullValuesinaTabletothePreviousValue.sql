/*
Create table If Not Exists CoffeeShop (id int, drink varchar(20))
Truncate table CoffeeShop
insert into CoffeeShop (id, drink) values ('9', 'Mezcal Margarita')
insert into CoffeeShop (id, drink) values ('6', 'None')
insert into CoffeeShop (id, drink) values ('7', 'None')
insert into CoffeeShop (id, drink) values ('3', 'Americano')
insert into CoffeeShop (id, drink) values ('1', 'Daiquiri')
insert into CoffeeShop (id, drink) values ('2', 'None')
*/

/*
Table: CoffeeShop

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| drink       | varchar |
+-------------+---------+
id is the primary key for this table.
Each row in this table shows the order id and the name of the drink ordered. Some drink rows are nulls.
 

Write an SQL query to replace the null values of drink with the name of the drink of the previous row that is not null. It is guaranteed that the drink of the first row of the table is not null.

Return the result table in the same order as the input.

The query result format is shown in the following example.

 

Example 1:

Input: 
CoffeeShop table:
+----+------------------+
| id | drink            |
+----+------------------+
| 9  | Mezcal Margarita |
| 6  | null             |
| 7  | null             |
| 3  | Americano        |
| 1  | Daiquiri         |
| 2  | null             |
+----+------------------+
Output: 
+----+------------------+
| id | drink            |
+----+------------------+
| 9  | Mezcal Margarita |
| 6  | Mezcal Margarita |
| 7  | Mezcal Margarita |
| 3  | Americano        |
| 1  | Daiquiri         |
| 2  | Daiquiri         |
+----+------------------+
Explanation: 
For ID 6, the previous value that is not null is from ID 9. We replace the null with "Mezcal Margarita".
For ID 7, the previous value that is not null is from ID 9. We replace the null with "Mezcal Margarita".
For ID 2, the previous value that is not null is from ID 1. We replace the null with "Daiquiri".
Note that the rows in the output are the same as in the input.
*/

/*OUTPUT
SELECT id, drink, ROW_NUMBER() OVER () AS nb FROM CoffeeShop;
Output
| id | drink            | nb |
| -- | ---------------- | -- |
| 9  | Mezcal Margarita | 1  |
| 6  | null             | 2  |
| 7  | null             | 3  |
| 3  | Americano        | 4  |
| 1  | Daiquiri         | 5  |
| 2  | null             | 6  |


WITH cte AS (SELECT id, drink, ROW_NUMBER() OVER () AS nb FROM CoffeeShop)

SELECT id, drink, nb, SUM(1-ISNULL(drink)) OVER (ORDER BY nb) AS group_id FROM cte;

Output
| id | drink            | nb | group_id |
| -- | ---------------- | -- | -------- |
| 9  | Mezcal Margarita | 1  | 1        |
| 6  | null             | 2  | 1        |
| 7  | null             | 3  | 1        |
| 3  | Americano        | 4  | 2        |
| 1  | Daiquiri         | 5  | 3        |
| 2  | null             | 6  | 3        |

*/

-- SOLUTION
# Write your MySQL query statement below
WITH cte AS (SELECT id, drink, ROW_NUMBER() OVER () AS nb FROM CoffeeShop), -- nb = initial row order
     cte2 AS (SELECT id, drink, nb, SUM(1-ISNULL(drink)) OVER (ORDER BY nb) AS group_id FROM cte) -- same group_id -> same drink
SELECT id, FIRST_VALUE(drink) OVER (PARTITION BY group_id) AS drink
FROM cte2
ORDER BY nb;
