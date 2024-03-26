/*
Create table If Not Exists Orders (order_id int, product_id int, quantity int, purchase_date date)
Truncate table Orders
insert into Orders (order_id, product_id, quantity, purchase_date) values ('1', '1', '7', '2020-03-16')
insert into Orders (order_id, product_id, quantity, purchase_date) values ('2', '1', '4', '2020-12-02')
insert into Orders (order_id, product_id, quantity, purchase_date) values ('3', '1', '7', '2020-05-10')
insert into Orders (order_id, product_id, quantity, purchase_date) values ('4', '1', '6', '2021-12-23')
insert into Orders (order_id, product_id, quantity, purchase_date) values ('5', '1', '5', '2021-05-21')
insert into Orders (order_id, product_id, quantity, purchase_date) values ('6', '1', '6', '2021-10-11')
insert into Orders (order_id, product_id, quantity, purchase_date) values ('7', '2', '6', '2022-10-11')
*/

/*
Table: Orders

+---------------+------+
| Column Name   | Type |
+---------------+------+
| order_id      | int  |
| product_id    | int  |
| quantity      | int  |
| purchase_date | date |
+---------------+------+
order_id is the primary key for this table.
Each row in this table contains the ID of an order, the id of the product purchased, the quantity, and the purchase date.
 

Write an SQL query to report the IDs of all the products that were ordered three or more times in two consecutive years.

Return the result table in any order.

The query result format is shown in the following example.

 

Example 1:

Input: 
Orders table:
+----------+------------+----------+---------------+
| order_id | product_id | quantity | purchase_date |
+----------+------------+----------+---------------+
| 1        | 1          | 7        | 2020-03-16    |
| 2        | 1          | 4        | 2020-12-02    |
| 3        | 1          | 7        | 2020-05-10    |
| 4        | 1          | 6        | 2021-12-23    |
| 5        | 1          | 5        | 2021-05-21    |
| 6        | 1          | 6        | 2021-10-11    |
| 7        | 2          | 6        | 2022-10-11    |
+----------+------------+----------+---------------+
Output: 
+------------+
| product_id |
+------------+
| 1          |
+------------+
Explanation: 
Product 1 was ordered in 2020 three times and in 2021 three times. Since it was ordered three times in two consecutive years, we include it in the answer.
Product 2 was ordered one time in 2022. We do not include it in the answer.
*/

--SOLUTION
# Write your MySQL query statement below
# The LAG() function is used to get value from row that precedes the current row.
# The LEAD() function is used to get value from row that succeeds the current row.

with d as (
SELECT product_id, 
 YEAR(purchase_date) AS curr_year,LEAD(YEAR(purchase_date)) OVER(PARTITION BY product_id ORDER BY YEAR(purchase_date)) AS next_year
 FROM orders
 GROUP BY curr_year, product_id
 HAVING COUNT(order_id) >= 3)
 SELECT DISTINCT d.product_id FROM d WHERE d.next_year=d.curr_year+1

/*
SELECT product_id, 
 YEAR(purchase_date) AS curr_year,LEAD(YEAR(purchase_date)) OVER(PARTITION BY product_id ORDER BY YEAR(purchase_date)) AS next_year
 FROM orders
 GROUP BY curr_year, product_id
 HAVING COUNT(order_id) >= 3;
 Output
| product_id | curr_year | next_year |
| ---------- | --------- | --------- |
| 1          | 2020      | 2021      |
| 1          | 2021      | null      |
*/
