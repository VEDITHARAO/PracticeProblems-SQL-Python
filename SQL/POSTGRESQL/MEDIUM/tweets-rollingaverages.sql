/*The table below contains information about tweets over a given period of time. 
Calculate the 3-day rolling average of tweets published by each user for each date that a tweet was posted.
Output the user id, tweet date, and rolling averages rounded to 2 decimal places.*/
/*tweets Table:
Column Name	Type
tweet_id	integer
user_id	integer
tweet_date	timestamp*/

/*tweets Example Input:
tweet_id	user_id	tweet_date
214252	111	06/01/2022 12:00:00
739252	111	06/01/2022 12:00:00
846402	111	06/02/2022 12:00:00
241425	254	06/02/2022 12:00:00
137374	111	06/04/2022 12:00:00*/

/*Example Output:
user_id	tweet_date	rolling_avg_3days
111	06/01/2022 12:00:00	2.00
111	06/02/2022 12:00:00	1.50
111	06/04/2022 12:00:00	1.33
254	06/02/2022 12:00:00	1.00 */

WITH tc as(
SELECT user_id, tweet_date, 
COUNT(DISTINCT tweet_id) as tweet_count
FROM tweets
GROUP BY user_id,tweet_date)

SELECT user_id,tweet_date, ROUND(
AVG(tweet_count) OVER(
PARTITION BY user_id 
ORDER BY user_id,tweet_date
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) as rolling_avg_3d  
FROM tc;




