/*
Create table If Not Exists Players (player_id int, player_name varchar(20))
Create table If Not Exists Championships (year int, Wimbledon int, Fr_open int, US_open int, Au_open int)
Truncate table Players
insert into Players (player_id, player_name) values ('1', 'Nadal')
insert into Players (player_id, player_name) values ('2', 'Federer')
insert into Players (player_id, player_name) values ('3', 'Novak')
Truncate table Championships
insert into Championships (year, Wimbledon, Fr_open, US_open, Au_open) values ('2018', '1', '1', '1', '1')
insert into Championships (year, Wimbledon, Fr_open, US_open, Au_open) values ('2019', '1', '1', '2', '2')
insert into Championships (year, Wimbledon, Fr_open, US_open, Au_open) values ('2020', '2', '1', '2', '2')

*/

/*
Table: Players

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| player_id      | int     |
| player_name    | varchar |
+----------------+---------+
player_id is the primary key for this table.
Each row in this table contains the name and the ID of a tennis player.
 

Table: Championships

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| year          | int     |
| Wimbledon     | int     |
| Fr_open       | int     |
| US_open       | int     |
| Au_open       | int     |
+---------------+---------+
year is the primary key for this table.
Each row of this table contains the IDs of the players who won one each tennis tournament of the grand slam.
 

Write an SQL query to report the number of grand slam tournaments won by each player. Do not include the players who did not win any tournament.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Players table:
+-----------+-------------+
| player_id | player_name |
+-----------+-------------+
| 1         | Nadal       |
| 2         | Federer     |
| 3         | Novak       |
+-----------+-------------+
Championships table:
+------+-----------+---------+---------+---------+
| year | Wimbledon | Fr_open | US_open | Au_open |
+------+-----------+---------+---------+---------+
| 2018 | 1         | 1       | 1       | 1       |
| 2019 | 1         | 1       | 2       | 2       |
| 2020 | 2         | 1       | 2       | 2       |
+------+-----------+---------+---------+---------+
Output: 
+-----------+-------------+-------------------+
| player_id | player_name | grand_slams_count |
+-----------+-------------+-------------------+
| 2         | Federer     | 5                 |
| 1         | Nadal       | 7                 |
+-----------+-------------+-------------------+
Explanation: 
Player 1 (Nadal) won 7 titles: Wimbledon (2018, 2019), Fr_open (2018, 2019, 2020), US_open (2018), and Au_open (2018).
Player 2 (Federer) won 5 titles: Wimbledon (2020), US_open (2019, 2020), and Au_open (2019, 2020).
Player 3 (Novak) did not win anything, we did not include them in the result table.
*/

--SOLUTION
# Write your MySQL query statement below
with gs as (
    select Wimbledon as player_id,year
    from Championships 
    union all 
    select Fr_open as player_id,year
    from Championships 
    union all 
    select US_open as player_id,year
    from Championships 
    union all
    select Au_open as player_id,year 
    from Championships 
)
, gs1 as (
    select player_id,year, row_number() over(partition by player_id order by year) as rn 
    from gs 
)

select gs1.player_id,p.player_name, count(*) as grand_slams_count
from gs1
inner join players p
on gs1.player_id=p.player_id
group by player_id;

/*
gs as
| player_id |
| --------- |
| 1         |
| 1         |
| 2         |
| 1         |
| 1         |
| 1         |
| 1         |
| 2         |
| 2         |
| 1         |
| 2         |
| 2         |

gs1 as

| player_id | year | rn |
| --------- | ---- | -- |
| 1         | 2018 | 1  |
| 1         | 2018 | 2  |
| 1         | 2018 | 3  |
| 1         | 2018 | 4  |
| 1         | 2019 | 5  |
| 1         | 2019 | 6  |
| 1         | 2020 | 7  |
| 2         | 2019 | 1  |
| 2         | 2019 | 2  |
| 2         | 2020 | 3  |
| 2         | 2020 | 4  |
| 2         | 2020 | 5  |

*/
