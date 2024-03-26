--1. How many users are there?
SELECT COUNT(DISTINCT USER_ID) as users_count FROM clique_bait.users;


--2. How many cookies does each user have on average?
WITH cc as(
SELECT  DISTINCT(user_id), COUNT(DISTINCT cookie_id) as cookie_count FROM clique_bait.users GROUP BY user_id)
SELECT ROUND(AVG(cookie_count),2) as avg_cookie_per_user from cc;


--3. What is the unique number of visits by all users per month?
WITH visited as(
SELECT distinct(cookie_id), COUNT(DISTINCT visit_id) as n_visit,
DATEPART(MONTH, event_time) as visit_month  FROM clique_bait.events
GROUP BY cookie_id,DATEPART(MONTH, event_time))
SELECT visit_month,
	sum(n_visit) AS total_visits from visited
GROUP BY visit_month
ORDER BY visit_month;

--4. What is the number of events for each event type?
SELECT 
e.event_type, 
COUNT(e.event_type) as countevent, 
ei.event_name FROM [clique_bait].[events] as e 
JOIN [clique_bait].[event_identifier] as ei ON
e.event_type=ei.event_type
GROUP BY e.event_type,ei.event_name
ORDER BY e.event_type;


--5. What is the percentage of visits which have a purchase event?
SELECT COUNT(CASE WHEN event_type = 3 THEN visit_id END) AS purchase_event,
COUNT(*) AS total_events,
ROUND(100* (cast(COUNT(CASE WHEN event_type = 3 THEN visit_id END) as numeric)/COUNT(*)),2) AS percent_purchase_event
FROM [clique_bait].[events]


--6. What is the percentage of visits which view the checkout page but do not have a purchase event?
--1. Select all visit_id's(events) which viewed(Page View,1 ) the checkout (page name,12)
--2.  Select all visit_id having made a purchase(3).
--3. Subtract percentage that did visit and purchase from 100%
WITH counts AS              
(SELECT visit_id,
sum( CASE WHEN page_id = 12 AND event_type = 1 THEN 1 ELSE 0 END) AS checked_out,
sum(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchased
FROM [clique_bait].[events]
GROUP BY visit_id)
SELECT
	round(100 * (1 - cast(sum(counts.purchased) as numeric) / sum(checked_out)), 2) AS visit_percentage
FROM counts;


--7. What are the top 3 pages by number of views?
SELECT TOP(3) e.page_id,ph.page_name,count(e.page_id) as pageview_count
FROM [clique_bait].[events] e
INNER JOIN [clique_bait].[page_hierarchy] ph
ON e.page_id=ph.page_id
INNER JOIN [clique_bait].[event_identifier] ei
ON e.event_type=ei.event_type
WHERE ei.event_name='Page View'
GROUP BY e.page_id,ph.page_name
ORDER BY pageview_count DESC;


--8. What is the number of views and cart adds for each product category?
WITH cc AS(
SELECT e.page_id,ei.event_name, ph.product_category, e.event_type
FROM [clique_bait].[events] e
LEFT JOIN [clique_bait].[page_hierarchy] ph 
ON e.page_id=ph.page_id
LEFT JOIN [clique_bait].[event_identifier] ei
ON e.event_type=ei.event_type)
SELECT cc.product_category,
COUNT( CASE WHEN cc.event_name='Page View' THEN 1 END) as count_pageviews,
COUNT( CASE WHEN cc.event_name='Add to Cart' THEN 1 END) as count_cartadds
FROM cc WHERE CC.product_category IS NOT NULL
GROUP BY product_category;


--9. What are the top 3 products by purchases?
--1. Identify the purchased items
--2. identify the add to cart items and match their visit_id's ensuring their page_id's 
-- are not belonging to page_names of Home Page(1), All Products(2), Checkout(12), Confirmation(13)
WITH get_purchases AS (
SELECT visit_id FROM clique_bait.events
	WHERE event_type = 3)	
SELECT
	TOP(3) ph.page_name, 
sum( CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS purchasedfromcart
FROM clique_bait.page_hierarchy AS ph
JOIN clique_bait.events AS e
ON e.page_id = ph.page_id
JOIN get_purchases AS gp
ON e.visit_id = gp.visit_id 
WHERE
ph.product_category IS NOT NULL
AND gp.visit_id = e.visit_id
AND ph.page_id NOT in('1','2','12','13')
GROUP BY ph.page_name
ORDER BY purchasedfromcart DESC;
