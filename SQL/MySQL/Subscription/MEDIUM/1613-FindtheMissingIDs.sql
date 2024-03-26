/*
Create table If Not Exists Customers (customer_id int, customer_name varchar(20))
Truncate table Customers
insert into Customers (customer_id, customer_name) values ('1', 'Alice')
insert into Customers (customer_id, customer_name) values ('4', 'Bob')
insert into Customers (customer_id, customer_name) values ('5', 'Charlie')
*/

/*
Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
+---------------+---------+
customer_id is the primary key for this table.
Each row of this table contains the name and the id customer.
 

Write an SQL query to find the missing customer IDs. The missing IDs are ones that are not in the Customers table but are in the range between 1 and the maximum customer_id present in the table.

Notice that the maximum customer_id will not exceed 100.

Return the result table ordered by ids in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Alice         |
| 4           | Bob           |
| 5           | Charlie       |
+-------------+---------------+
Output: 
+-----+
| ids |
+-----+
| 2   |
| 3   |
+-----+
Explanation: 
The maximum customer_id present in the table is 5, so in the range [1,5], IDs 2 and 3 are missing from the table.
https://dev.mysql.com/doc/refman/8.0/en/with.html#common-table-expressions-recursive
*/

--SOLUTION
# Write your MySQL query statement below
WITH RECURSIVE seq AS (
    SELECT 1 AS value 
    UNION ALL 
    SELECT value + 1 FROM seq 
    WHERE  value < (SELECT MAX(customer_id) FROM Customers) AND value<100
    )
SELECT value as ids FROM seq 
WHERE value NOT IN (SELECT customer_id FROM Customers);

/*
WITH RECURSIVE seq AS (
    SELECT 1 AS value 
    UNION ALL 
    SELECT value + 1 FROM seq 
    WHERE  value < (SELECT MAX(customer_id) FROM Customers) AND value<100
    )
SELECT * FROM seq


| value |
| ----- |
| 1     |
| 2     |
| 3     |
| 4     |
| 5     |

*/
