/*
Create table If Not Exists Schools (school_id int, capacity int)
Create table If Not Exists Exam (score int, student_count int)
Truncate table Schools
insert into Schools (school_id, capacity) values ('11', '151')
insert into Schools (school_id, capacity) values ('5', '48')
insert into Schools (school_id, capacity) values ('9', '9')
insert into Schools (school_id, capacity) values ('10', '99')
Truncate table Exam
insert into Exam (score, student_count) values ('975', '10')
insert into Exam (score, student_count) values ('966', '60')
insert into Exam (score, student_count) values ('844', '76')
insert into Exam (score, student_count) values ('749', '76')
insert into Exam (score, student_count) values ('744', '100')
*/

/*
Table: Schools

+-------------+------+
| Column Name | Type |
+-------------+------+
| school_id   | int  |
| capacity    | int  |
+-------------+------+
school_id is the primary key for this table.
This table contains information about the capacity of some schools. The capacity is the maximum number of students the school can accept.
 

Table: Exam

+---------------+------+
| Column Name   | Type |
+---------------+------+
| score         | int  |
| student_count | int  |
+---------------+------+
score is the primary key for this table.
Each row in this table indicates that there are student_count students that got at least score points in the exam.
The data in this table will be logically correct, meaning a row recording a higher score will have the same or smaller student_count compared to a row recording a lower score. More formally, for every two rows i and j in the table, if scorei > scorej then student_counti <= student_countj.
 

Every year, each school announces a minimum score requirement that a student needs to apply to it. The school chooses the minimum score requirement based on the exam results of all the students:

They want to ensure that even if every student meeting the requirement applies, the school can accept everyone.
They also want to maximize the possible number of students that can apply.
They must use a score that is in the Exam table.
Write an SQL query to report the minimum score requirement for each school. If there are multiple score values satisfying the above conditions, choose the smallest one. If the input data is not enough to determine the score, report -1.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input:
Schools table:
+-----------+----------+
| school_id | capacity |
+-----------+----------+
| 11        | 151      |
| 5         | 48       |
| 9         | 9        |
| 10        | 99       |
+-----------+----------+
Exam table:
+-------+---------------+
| score | student_count |
+-------+---------------+
| 975   | 10            |
| 966   | 60            |
| 844   | 76            |
| 749   | 76            |
| 744   | 100           |
+-------+---------------+
Output:
+-----------+-------+
| school_id | score |
+-----------+-------+
| 5         | 975   |
| 9         | -1    |
| 10        | 749   |
| 11        | 744   |
+-----------+-------+
Explanation: 
- School 5: The school's capacity is 48. Choosing 975 as the min score requirement, the school will get at most 10 applications, which is within capacity.
- School 10: The school's capacity is 99. Choosing 844 or 749 as the min score requirement, the school will get at most 76 applications, which is within capacity. We choose the smallest of them, which is 749.
- School 11: The school's capacity is 151. Choosing 744 as the min score requirement, the school will get at most 100 applications, which is within capacity.
- School 9: The data given is not enough to determine the min score requirement. Choosing 975 as the min score, the school may get 10 requests while its capacity is 9. We do not have information about higher scores, hence we report -1.

*/
# Write your MySQL query statement below
# select school_id, ifnull(min(score),-1) as score
# from Schools left join Exam
# on capacity >= student_count
# group by school_id

--SOLUTION
select
school_Id,
min(case when student_count is not null then score else -1 end) as score
from 
schools
left join exam 
on capacity >= student_count
group by 1
 
