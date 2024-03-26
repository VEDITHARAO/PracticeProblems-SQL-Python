/*
Create table If Not Exists Contests (contest_id int, gold_medal int, silver_medal int, bronze_medal int)
Create table If Not Exists Users (user_id int, mail varchar(50), name varchar(30))
Truncate table Contests
insert into Contests (contest_id, gold_medal, silver_medal, bronze_medal) values ('190', '1', '5', '2')
insert into Contests (contest_id, gold_medal, silver_medal, bronze_medal) values ('191', '2', '3', '5')
insert into Contests (contest_id, gold_medal, silver_medal, bronze_medal) values ('192', '5', '2', '3')
insert into Contests (contest_id, gold_medal, silver_medal, bronze_medal) values ('193', '1', '3', '5')
insert into Contests (contest_id, gold_medal, silver_medal, bronze_medal) values ('194', '4', '5', '2')
insert into Contests (contest_id, gold_medal, silver_medal, bronze_medal) values ('195', '4', '2', '1')
insert into Contests (contest_id, gold_medal, silver_medal, bronze_medal) values ('196', '1', '5', '2')
Truncate table Users
insert into Users (user_id, mail, name) values ('1', 'sarah@leetcode.com', 'Sarah')
insert into Users (user_id, mail, name) values ('2', 'bob@leetcode.com', 'Bob')
insert into Users (user_id, mail, name) values ('3', 'alice@leetcode.com', 'Alice')
insert into Users (user_id, mail, name) values ('4', 'hercy@leetcode.com', 'Hercy')
insert into Users (user_id, mail, name) values ('5', 'quarz@leetcode.com', 'Quarz')
*/

/*
Table: Contests

+--------------+------+
| Column Name  | Type |
+--------------+------+
| contest_id   | int  |
| gold_medal   | int  |
| silver_medal | int  |
| bronze_medal | int  |
+--------------+------+
contest_id is the primary key for this table.
This table contains the LeetCode contest ID and the user IDs of the gold, silver, and bronze medalists.
It is guaranteed that any consecutive contests have consecutive IDs and that no ID is skipped.
 

Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| mail        | varchar |
| name        | varchar |
+-------------+---------+
user_id is the primary key for this table.
This table contains information about the users.
 

Write an SQL query to report the name and the mail of all interview candidates. 
A user is an interview candidate if at least one of these two conditions is true:

The user won any medal in three or more consecutive contests.
The user won the gold medal in three or more different contests (not necessarily consecutive).
Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Contests table:
+------------+------------+--------------+--------------+
| contest_id | gold_medal | silver_medal | bronze_medal |
+------------+------------+--------------+--------------+
| 190        | 1          | 5            | 2            |
| 191        | 2          | 3            | 5            |
| 192        | 5          | 2            | 3            |
| 193        | 1          | 3            | 5            |
| 194        | 4          | 5            | 2            |
| 195        | 4          | 2            | 1            |
| 196        | 1          | 5            | 2            |
+------------+------------+--------------+--------------+
Users table:
+---------+--------------------+-------+
| user_id | mail               | name  |
+---------+--------------------+-------+
| 1       | sarah@leetcode.com | Sarah |
| 2       | bob@leetcode.com   | Bob   |
| 3       | alice@leetcode.com | Alice |
| 4       | hercy@leetcode.com | Hercy |
| 5       | quarz@leetcode.com | Quarz |
+---------+--------------------+-------+
Output: 
+-------+--------------------+
| name  | mail               |
+-------+--------------------+
| Sarah | sarah@leetcode.com |
| Bob   | bob@leetcode.com   |
| Alice | alice@leetcode.com |
| Quarz | quarz@leetcode.com |
+-------+--------------------+
Explanation: 
Sarah won 3 gold medals (190, 193, and 196), so we include her in the result table.
Bob won a medal in 3 consecutive contests (190, 191, and 192), so we include him in the result table.
    - Note that he also won a medal in 3 other consecutive contests (194, 195, and 196).
Alice won a medal in 3 consecutive contests (191, 192, and 193), so we include her in the result table.
Quarz won a medal in 5 consecutive contests (190, 191, 192, 193, and 194), so we include them in the result table.
 

Follow up:

What if the first condition changed to be "any medal in n or more consecutive contests"? 
How would you change your solution to get the interview candidates? Imagine that n is the parameter of a stored procedure.
Some users may not participate in every contest but still perform well in the ones they do. 
How would you change your solution to only consider contests where the user was a participant? 
Suppose the registered users for each contest are given in another table.
*/

--SOLUTION
# Write your MySQL query statement below

with t0 as (
    select gold_medal as user, contest_id 
    from contests 
    union all 
    select silver_medal as user, contest_id 
    from contests 
    union all 
    select bronze_medal as user, contest_id 
    from contests 
)
, t1 as (
    select user, contest_id, row_number() over(partition by user order by contest_id) as rn 
    from t0 
)
, t2 as (
    select user as user_id -- consecutive medal winners
    from t1 
    group by user, contest_id - rn 
    having count(*) >= 3 -- replace 3 with any number to solve the N problem
    union all
    select gold_medal as user_id  -- gold medal winners
    from contests 
    group by gold_medal 
    having count(*) >= 3
)
select distinct u.name, u.mail 
from t2 
inner join users u
on t2.user_id = u.user_id

/*
t0 as 
| user | contest_id |
| ---- | ---------- |
| 1    | 190        |
| 2    | 191        |
| 5    | 192        |
| 1    | 193        |
| 4    | 194        |
| 4    | 195        |
| 1    | 196        |
| 5    | 190        |
| 3    | 191        |
| 2    | 192        |
| 3    | 193        |
| 5    | 194        |
| 2    | 195        |
| 5    | 196        |
| 2    | 190        |
| 5    | 191        |
| 3    | 192        |
| 5    | 193        |
| 2    | 194        |
| 1    | 195        |
| 2    | 196        |

t1 as 
| user | contest_id | rn |
| ---- | ---------- | -- |
| 1    | 190        | 1  |
| 1    | 193        | 2  |
| 1    | 195        | 3  |
| 1    | 196        | 4  |
| 2    | 190        | 1  |
| 2    | 191        | 2  |
| 2    | 192        | 3  |
| 2    | 194        | 4  |
| 2    | 195        | 5  |
| 2    | 196        | 6  |
| 3    | 191        | 1  |
| 3    | 192        | 2  |
| 3    | 193        | 3  |
| 4    | 194        | 1  |
| 4    | 195        | 2  |
| 5    | 190        | 1  |
| 5    | 191        | 2  |
| 5    | 192        | 3  |
| 5    | 193        | 4  |
| 5    | 194        | 5  |
| 5    | 196        | 6  |

t2 as
| user_id |
| ------- |
| 2       |
| 2       |
| 3       |
| 5       |
| 1       |


*/
