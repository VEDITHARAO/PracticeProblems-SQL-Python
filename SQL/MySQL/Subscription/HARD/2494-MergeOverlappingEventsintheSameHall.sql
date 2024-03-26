/*
Create table If Not Exists HallEvents (hall_id int, start_day date, end_day date)
Truncate table HallEvents
insert into HallEvents (hall_id, start_day, end_day) values ('1', '2023-01-13', '2023-01-14')
insert into HallEvents (hall_id, start_day, end_day) values ('1', '2023-01-14', '2023-01-17')
insert into HallEvents (hall_id, start_day, end_day) values ('1', '2023-01-18', '2023-01-25')
insert into HallEvents (hall_id, start_day, end_day) values ('2', '2022-12-09', '2022-12-23')
insert into HallEvents (hall_id, start_day, end_day) values ('2', '2022-12-13', '2022-12-17')
insert into HallEvents (hall_id, start_day, end_day) values ('3', '2022-12-01', '2023-01-30')
*/

/*
Table: HallEvents

+-------------+------+
| Column Name | Type |
+-------------+------+
| hall_id     | int  |
| start_day   | date |
| end_day     | date |
+-------------+------+
There is no primary key in this table. It may contain duplicates.
Each row of this table indicates the start day and end day of an event and the hall in which the event is held.
 

Write an SQL query to merge all the overlapping events that are held in the same hall. Two events overlap if they have at least one day in common.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
HallEvents table:
+---------+------------+------------+
| hall_id | start_day  | end_day    |
+---------+------------+------------+
| 1       | 2023-01-13 | 2023-01-14 |
| 1       | 2023-01-14 | 2023-01-17 |
| 1       | 2023-01-18 | 2023-01-25 |
| 2       | 2022-12-09 | 2022-12-23 |
| 2       | 2022-12-13 | 2022-12-17 |
| 3       | 2022-12-01 | 2023-01-30 |
+---------+------------+------------+
Output: 
+---------+------------+------------+
| hall_id | start_day  | end_day    |
+---------+------------+------------+
| 1       | 2023-01-13 | 2023-01-17 |
| 1       | 2023-01-18 | 2023-01-25 |
| 2       | 2022-12-09 | 2022-12-23 |
| 3       | 2022-12-01 | 2023-01-30 |
+---------+------------+------------+
Explanation: There are three halls.
Hall 1:
- The two events ["2023-01-13", "2023-01-14"] and ["2023-01-14", "2023-01-17"] overlap. We merge them in one event ["2023-01-13", "2023-01-17"].
- The event ["2023-01-18", "2023-01-25"] does not overlap with any other event, so we leave it as it is.
Hall 2:
- The two events ["2022-12-09", "2022-12-23"] and ["2022-12-13", "2022-12-17"] overlap. We merge them in one event ["2022-12-09", "2022-12-23"].
Hall 3:
- The hall has only one event, so we return it. Note that we only consider the events of each hall separately.
*/

--SOLUTION
/*
For each event hall, an event belongs to an onging series of events if its start_day <= max_prev_end_day of all preceding events (events starts earlier than this event).

For each event hall, we need to sequentially iterate events holded in this hall by their start_day in an ascending order and keep tracking of the max(end_day). For each event we:

test if it begins a new series of event start_day > max_prev_end_day
update the max_prev_end_day = max(max_prev_end_day, end_day)
# Write your MySQL query statement below
*/

WITH new_event_start AS (
  SELECT
  	IFNULL(start_day > MAX(end_day) OVER pw, 1) AS is_new_event_start,
  	hall_id,
    start_day,
  	end_day
  FROM
  	HallEvents
  WINDOW
  	pw AS (
      PARTITION BY hall_id 
      ORDER BY start_day ASC, end_day DESC
      ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    )
),
event_id AS (
  SELECT
  	SUM(is_new_event_start) OVER w AS event_id,
    hall_id,
    start_day,
    end_day
  FROM
  	new_event_start
  WINDOW
  	w AS (
      PARTITION BY hall_id
      ORDER BY start_day ASC, end_day DESC
    )
)
SELECT
	hall_id,
    min(start_day) AS start_day,
    max(end_day) As end_day    
FROM
	event_id
GROUP BY hall_id, event_id
  
