/*
Create table If Not Exists Employees (employee_id int, name varchar(30), salary int)
Truncate table Employees
insert into Employees (employee_id, name, salary) values ('2', 'Meir', '3000')
insert into Employees (employee_id, name, salary) values ('3', 'Michael', '3000')
insert into Employees (employee_id, name, salary) values ('7', 'Addilyn', '7400')
insert into Employees (employee_id, name, salary) values ('8', 'Juan', '6100')
insert into Employees (employee_id, name, salary) values ('9', 'Kannon', '7400')
*/

/*
Table: Employees

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
| salary      | int     |
+-------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates the employee ID, employee name, and salary.
 

A company wants to divide the employees into teams such that all the members on each team have the same salary. The teams should follow these criteria:

Each team should consist of at least two employees.
All the employees on a team should have the same salary.
All the employees of the same salary should be assigned to the same team.
If the salary of an employee is unique, we do not assign this employee to any team.
A team's ID is assigned based on the rank of the team's salary relative to the other teams' salaries, where the team with the lowest salary has team_id = 1. Note that the salaries for employees not on a team are not included in this ranking.
Write an SQL query to get the team_id of each employee that is in a team.

Return the result table ordered by team_id in ascending order. In case of a tie, order it by employee_id in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Employees table:
+-------------+---------+--------+
| employee_id | name    | salary |
+-------------+---------+--------+
| 2           | Meir    | 3000   |
| 3           | Michael | 3000   |
| 7           | Addilyn | 7400   |
| 8           | Juan    | 6100   |
| 9           | Kannon  | 7400   |
+-------------+---------+--------+
Output: 
+-------------+---------+--------+---------+
| employee_id | name    | salary | team_id |
+-------------+---------+--------+---------+
| 2           | Meir    | 3000   | 1       |
| 3           | Michael | 3000   | 1       |
| 7           | Addilyn | 7400   | 2       |
| 9           | Kannon  | 7400   | 2       |
+-------------+---------+--------+---------+
Explanation: 
Meir (employee_id=2) and Michael (employee_id=3) are in the same team because they have the same salary of 3000.
Addilyn (employee_id=7) and Kannon (employee_id=9) are in the same team because they have the same salary of 7400.
Juan (employee_id=8) is not included in any team because their salary of 6100 is unique (i.e. no other employee has the same salary).
The team IDs are assigned as follows (based on salary ranking, lowest first):
- team_id=1: Meir and Michael, a salary of 3000
- team_id=2: Addilyn and Kannon, a salary of 7400
Juan's salary of 6100 is not included in the ranking because they are not on a team.
*/

--SOLUTION
# Write your MySQL query statement below
select *,dense_rank() over(order by salary) as team_id
from employees
where salary not in (
    select  salary from 
    employees group by salary
    having count(*)=1
)
order by team_id,employee_id
;
