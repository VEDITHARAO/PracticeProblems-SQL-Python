/*
Create table If Not Exists Accounts (account_id int, income int)
Truncate table Accounts
insert into Accounts (account_id, income) values ('3', '108939')
insert into Accounts (account_id, income) values ('2', '12747')
insert into Accounts (account_id, income) values ('8', '87709')
insert into Accounts (account_id, income) values ('6', '91796')
*/

/*

Table: Accounts

+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
account_id is the primary key for this table.
Each row contains information about the monthly income for one bank account.
 

Write an SQL query to report the number of bank accounts of each salary category. The salary categories are:

"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, then report 0.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Accounts table:
+------------+--------+
| account_id | income |
+------------+--------+
| 3          | 108939 |
| 2          | 12747  |
| 8          | 87709  |
| 6          | 91796  |
+------------+--------+
Output: 
+----------------+----------------+
| category       | accounts_count |
+----------------+----------------+
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |
+----------------+----------------+
Explanation: 
Low Salary: Account 2.
Average Salary: No accounts.
High Salary: Accounts 3, 6, and 8.
*/

--SOLUTION
# Write your MySQL query statement below

with ac as(
SELECT (
CASE 
    WHEN income<20000 then 'Low Salary'
    WHEN income>=20000 and income<=50000 then 'Average Salary'
    WHEN income>50000 then 'High Salary'
   ELSE 0
END) as category,account_id
from Accounts),

ac_c AS(        
SELECT "Low Salary" AS category
UNION 
SELECT "Average Salary" AS category
UNION 
SELECT "High Salary" AS category
) 

SELECT ac_c.category, count(ac.account_id) as accounts_count 
from ac_c left join ac on
ac_c.category=ac.category
group by ac_c.category
order by 2 DESC;
