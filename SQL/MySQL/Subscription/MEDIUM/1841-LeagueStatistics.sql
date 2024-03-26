/*
Create table If Not Exists Teams (team_id int, team_name varchar(20))
Create table If Not Exists Matches (home_team_id int, away_team_id int, home_team_goals int, away_team_goals int)
Truncate table Teams
insert into Teams (team_id, team_name) values ('1', 'Ajax')
insert into Teams (team_id, team_name) values ('4', 'Dortmund')
insert into Teams (team_id, team_name) values ('6', 'Arsenal')
Truncate table Matches
insert into Matches (home_team_id, away_team_id, home_team_goals, away_team_goals) values ('1', '4', '0', '1')
insert into Matches (home_team_id, away_team_id, home_team_goals, away_team_goals) values ('1', '6', '3', '3')
insert into Matches (home_team_id, away_team_id, home_team_goals, away_team_goals) values ('4', '1', '5', '2')
insert into Matches (home_team_id, away_team_id, home_team_goals, away_team_goals) values ('6', '1', '0', '0')
*/

/*
Table: Teams

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| team_id        | int     |
| team_name      | varchar |
+----------------+---------+
team_id is the primary key for this table.
Each row contains information about one team in the league.
 

Table: Matches

+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
| home_team_id    | int     |
| away_team_id    | int     |
| home_team_goals | int     |
| away_team_goals | int     |
+-----------------+---------+
(home_team_id, away_team_id) is the primary key for this table.
Each row contains information about one match.
home_team_goals is the number of goals scored by the home team.
away_team_goals is the number of goals scored by the away team.
The winner of the match is the team with the higher number of goals.
 

Write an SQL query to report the statistics of the league. 
The statistics should be built using the played matches where the winning team gets three points and the losing team gets no points. 
If a match ends with a draw, both teams get one point.

Each row of the result table should contain:

team_name - The name of the team in the Teams table.
matches_played - The number of matches played as either a home or away team.
points - The total points the team has so far.
goal_for - The total number of goals scored by the team across all matches.
goal_against - The total number of goals scored by opponent teams against this team across all matches.
goal_diff - The result of goal_for - goal_against.
Return the result table ordered by points in descending order. 
If two or more teams have the same points, order them by goal_diff in descending order. 
If there is still a tie, order them by team_name in lexicographical order.

The query result format is in the following example.

 

Example 1:

Input: 
Teams table:
+---------+-----------+
| team_id | team_name |
+---------+-----------+
| 1       | Ajax      |
| 4       | Dortmund  |
| 6       | Arsenal   |
+---------+-----------+
Matches table:
+--------------+--------------+-----------------+-----------------+
| home_team_id | away_team_id | home_team_goals | away_team_goals |
+--------------+--------------+-----------------+-----------------+
| 1            | 4            | 0               | 1               |
| 1            | 6            | 3               | 3               |
| 4            | 1            | 5               | 2               |
| 6            | 1            | 0               | 0               |
+--------------+--------------+-----------------+-----------------+
Output: 
+-----------+----------------+--------+----------+--------------+-----------+
| team_name | matches_played | points | goal_for | goal_against | goal_diff |
+-----------+----------------+--------+----------+--------------+-----------+
| Dortmund  | 2              | 6      | 6        | 2            | 4         |
| Arsenal   | 2              | 2      | 3        | 3            | 0         |
| Ajax      | 4              | 2      | 5        | 9            | -4        |
+-----------+----------------+--------+----------+--------------+-----------+
Explanation: 
Ajax (team_id=1) played 4 matches: 2 losses and 2 draws. Total points = 0 + 0 + 1 + 1 = 2.
Dortmund (team_id=4) played 2 matches: 2 wins. Total points = 3 + 3 = 6.
Arsenal (team_id=6) played 2 matches: 2 draws. Total points = 1 + 1 = 2.
Dortmund is the first team in the table. Ajax and Arsenal have the same points, 
but since Arsenal has a higher goal_diff than Ajax, Arsenal comes before Ajax in the table.
*/

--SOLUTION
# Write your MySQL query statement below

with tt as(SELECT  home_team_id, away_team_id, home_team_goals, away_team_goals 
from matches m1
union all
SELECT   away_team_id as home_team_id,home_team_id as away_team_id ,   away_team_goals as home_team_goals, home_team_goals as  away_team_goals
from matches m2)

select
    team_name
    , count(*) as matches_played
    , sum(case when home_team_goals > away_team_goals then 3 when home_team_goals = away_team_goals then 1 else 0 end) as points
    , sum(home_team_goals) as goal_for
    , sum(away_team_goals) as goal_against
    , sum(home_team_goals) - sum(away_team_goals) as goal_diff
    
from 
tt
join teams t on tt.home_team_id = t.team_id
group by team_name
order by points desc, goal_diff desc, team_name

/*
SELECT  home_team_id, away_team_id, home_team_goals, away_team_goals 
from matches m1

union all
SELECT   away_team_id as home_team_id,home_team_id as away_team_id ,   away_team_goals as home_team_goals, home_team_goals as  away_team_goals
from matches m2


| home_team_id | away_team_id | home_team_goals | away_team_goals |
| ------------ | ------------ | --------------- | --------------- |
| 1            | 4            | 0               | 1               |
| 1            | 6            | 3               | 3               |
| 4            | 1            | 5               | 2               |
| 6            | 1            | 0               | 0               |
| 4            | 1            | 1               | 0               |
| 6            | 1            | 3               | 3               |
| 1            | 4            | 2               | 5               |
| 1            | 6            | 0               | 0               |


SELECT  home_team_id, away_team_id, home_team_goals, away_team_goals 
from matches m1

union
SELECT   away_team_id, home_team_id, home_team_goals, away_team_goals 
from matches m2


| home_team_id | away_team_id | home_team_goals | away_team_goals |
| ------------ | ------------ | --------------- | --------------- |
| 1            | 4            | 0               | 1               |
| 1            | 6            | 3               | 3               |
| 4            | 1            | 5               | 2               |
| 6            | 1            | 0               | 0               |
| 4            | 1            | 0               | 1               |
| 6            | 1            | 3               | 3               |
| 1            | 4            | 5               | 2               |
| 1            | 6            | 0               | 0               |
*/
