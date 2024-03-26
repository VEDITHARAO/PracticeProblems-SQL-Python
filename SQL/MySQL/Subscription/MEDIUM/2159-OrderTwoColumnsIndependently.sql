/*
Create table If Not Exists Data (first_col int, second_col int)
Truncate table Data
insert into Data (first_col, second_col) values ('4', '2')
insert into Data (first_col, second_col) values ('2', '3')
insert into Data (first_col, second_col) values ('3', '1')
insert into Data (first_col, second_col) values ('1', '4')
*/

/*
Table: Data

+-------------+------+
| Column Name | Type |
+-------------+------+
| first_col   | int  |
| second_col  | int  |
+-------------+------+
There is no primary key for this table and it may contain duplicates.
 

Write an SQL query to independently:

order first_col in ascending order.
order second_col in descending order.
The query result format is in the following example.

 

Example 1:

Input: 
Data table:
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 4         | 2          |
| 2         | 3          |
| 3         | 1          |
| 1         | 4          |
+-----------+------------+
Output: 
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 1         | 4          |
| 2         | 3          |
| 3         | 2          |
| 4         | 1          |
+-----------+------------+
*/

--SOLUTION
# Write your MySQL query statement below
with a as(
    SELECT first_col, ROW_NUMBER() OVER(ORDER BY first_col ASC) AS r
    FROM Data
),
b as(
    SELECT second_col, ROW_NUMBER() OVER(ORDER BY second_col DESC) AS r
    FROM Data
) 
SELECT a.first_col, b.second_col
FROM a join b 
ON a.r = b.r
