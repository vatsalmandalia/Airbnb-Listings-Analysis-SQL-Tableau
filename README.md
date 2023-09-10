# Airbnb-Listings-Analysis-SQL-Tableau

This repository contains the project on Airbnb Listings Analysis done using SQL and Tableau. This project is inspired from the Guided Project done by Avery Smith on Airbnb Exploratory Data Analysis.

## Structure of Analysis:

1. Background
2. Preparation and Cleaning
3. Business problems
4. Exploratory Data Analysis
5. Summary of the findings

## Background:

Airbnb is an online market-place for property owners to host their properties for tourists looking to book for short-term homestays. It is a medium between hosts and potential customers looking to make book listings in specific locations. Airbnb currently has over 100,000+ listings spread over 6 countries.

For my analysis, I am only considering only the data for Austin, Texas.

## Preparation and Cleaning:

There are three datasets sourced from Inside Airbnb - listings, calendar, reviews. In the listings data, the 'price' field is of TEXT data type and contains a non-numeric character '$'. This is treated using the below query.

UPDATE listings_austin
SET price = REPLACE(price, '$', '');

Data has been scraped on 2022-06-08 from the source. Tools employed are DB Browser for SQLite and Tableau Public.

## Business problems

- How many listings and hosts are there in Austin? Are there hosts with multiple listings?
- Across neighborhoods, what is the proportion of listings and the price situation?
- What is the price per bed trend by each neighborhood?
- What is the division of each type of room among all listings? How does the price correlate with a room type and neighbourhood?
- In the next 30-day period, who are the top revenue earners? How does this revenue potential vary by neighborhoods and room types?
- What is the outlook of superhosts across each neighborhood – in terms of numbers, price and ratings?

## Exploratory Data Analysis

Below is the queries implemented in DB Browser for SQLite for addressing the above business questions.

/* Airbnb Listings Analysis through SQL*/

-- Data preparation
-- Removing the '$' sign in 'price' column
-- Data type changed through 'Edit' in menu bar and 'Modify table'.

/* --------------- Data Exploration --------------- */<BR>
-- 1. Lets look at number of listings and hosts<BR>
SELECT<BR>
COUNT(DISTINCT(listings_austin.id)) AS Num_of_listings,<BR>
COUNT(DISTINCT(listings_austin.host_id)) AS Num_of_hosts<BR>
FROM listings_austin;

<BR><BR>
-- 2. Number of hosts
SELECT COUNT(DISTINCT(listings_austin.host_id)) AS Num_of_hosts<BR>
FROM listings_austin;<BR>
-- Number of hosts = 9556

<BR><BR>
-- 3. Hosts with multiple listings<BR>
SELECT<BR>
num_listings_per_host,<BR>
COUNT(host_id) AS num_hosts,<BR>
ROUND(COUNT(host_id)*100.0/(SELECT COUNT(DISTINCT (host_id)) FROM listings_austin),2) AS Host_percentage<BR>
FROM (SELECT host_id, COUNT(DISTINCT id) AS num_listings_per_host FROM listings_austin GROUP BY host_id)<BR>
GROUP BY<BR>
num_listings_per_host<BR>
ORDER BY<BR>
num_listings_per_host;<BR>
 -- There are hosts with a single listing and also with little less than 400 listings.<BR>
 -- Close to 80% of hosts are single-property hosts.<BR>

 
 -- 4. Average price and number of listings by neighbourhood
 -- For Cypress Mill, price value has a comma. This affects the average function resulting in wrong result.
 -- Remove the commas in the price column while calculating the average price.
SELECT
neighbourhood, 
COUNT(id) AS Num_listings, 
ROUND(AVG(CAST(REPLACE(price, ',', '') AS INTEGER)),2) AS Average_price
FROM listings_austin
GROUP BY neighbourhood
ORDER BY Average_price ASC;
 -- Cypress Mill having a single listing has the highest average price, around 50% more than at Burnet County.

 -- Neighborhoods ordered by number of listings in descending
SELECT
neighbourhood,
COUNT(id) AS Num_listings,
ROUND(COUNT(id)*100.0/(SELECT COUNT(DISTINCT (id)) FROM listings_austin),2) AS Perc_listings
FROM listings_austin
GROUP BY neighbourhood
ORDER BY num_listings DESC LIMIT 5;
-- Austin has largest number of listings. 
-- There is also a significant number listings assigned to a neighbourhood with a NULL value.


-- 5. Price per bed by neighbourhood
SELECT neighbourhood, beds, ROUND(SUM(CAST(REPLACE(price, ',', '') AS INTEGER))/SUM(beds),2) AS Price_per_bed
FROM listings_austin
GROUP BY neighbourhood
ORDER BY Price_per_bed DESC LIMIT 5;
-- Price per bed in Rollingwood, single bed neighbourhood, is 5 times more than at Westlake Hills.
-- Rollingwood is one of the most affluent and sought-after neighbourhoods in Austin.


-- 6. Number of listings by room type and correlation between price and room type
SELECT
room_type,
ROUND(AVG(CAST(REPLACE(price, ',', '') AS INTEGER)),2) AS Average_price,
COUNT(DISTINCT id) AS Number_of_listings,
ROUND(COUNT(DISTINCT id)*100.0/(SELECT COUNT(DISTINCT id) FROM listings_austin),2) AS Proportion_of_listings
FROM
listings_austin
GROUP BY
room_type
ORDER BY
Average_price DESC;
 -- Entire home/apartment is priced higher than others on average.
 -- 83% of the listings approximately are entire homes or apartments. Hotel and shared rooms are in the minority among all 17071 listings.
 -- But, it is observed the cost of a hotel room more than combined price of private and shared rooms.
 
 
 -- 7. By neighborhood, average price per room type
SELECT
neighbourhood,
room_type,
ROUND(AVG(CAST(REPLACE(price, ',', '') AS INTEGER)),2) AS Average_price,
COUNT(DISTINCT id) AS Number_of_listings
FROM
listings_austin
GROUP BY
neighbourhood,
room_type
ORDER BY
Average_price DESC;
-- 8 out of the top 10 in average prices are homes or apartments.
-- Hotel rooms and private rooms in Austin and Rollingwood respectively are other two.
 
 
-- 8. Projected revenue for each listing based on number of days it is booked in next 30 days
SELECT
id,
listing_url,
CAST(REPLACE(price, ',', '') AS INTEGER) AS Price_listing,
name,
(30 - availability_30) AS booked_next_30,
(30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER) AS projected_rev_30
FROM listings_austin
ORDER BY projected_rev_30 DESC LIMIT 5;

-- Looking at availability for next year
SELECT id, listing_url, CAST(REPLACE(price, ',', '') AS INTEGER) AS Price_listing, name, availability_365, property_type,
(365 - availability_365)*CAST(REPLACE(price, ',', '') AS INTEGER) AS projected_rev_365
FROM listings_austin
ORDER BY projected_rev_365 DESC LIMIT 5;


-- Now lets understand the revenue numbers by neighbourhood.
-- Which neighbourhoods lead the way in terms of revenue earned?

-- 9. Projected revenue for each neighbourhood for the next 30 days
-- Filtering listings based on last review data. Considering only those listings 
-- where a review was made in past 6 months from 2022-06-08
-- Top 5 earners
SELECT
neighbourhood,
SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) AS projected_rev_30,
ROUND((SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER))*100.0/
	(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) 
	  FROM listings_austin WHERE last_review >= '2022-01-01' )),2) AS Revenue_share,
COUNT(DISTINCT id) AS num_listings
FROM
listings_austin
WHERE
last_review >= '2022-01-01' AND neighbourhood IS NOT NULL
GROUP BY
neighbourhood
ORDER BY
projected_rev_30 DESC LIMIT 5;


-- Deeper analysis by looking revenue potential by neighbourhood and room type.
-- Listings filtered where last review >= '2022-01-01'
-- 10. Revenue potential by neighbourhood and room type
SELECT
la.neighbourhood,
SUM((30 - la.availability_30)*(CAST(REPLACE(la.price, ',', '') AS INTEGER))) AS projected_totalrev_30,
ROUND(SUM(CASE WHEN la.room_type='Entire home/apt' THEN ((30 - la.availability_30)*(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/
	(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND 
	last_review>='2022-01-01'),2) AS projected_rev_entirehome,
ROUND(SUM(CASE WHEN la.room_type='Hotel room' THEN ((30 - la.availability_30)*(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/
	(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND 
	last_review>='2022-01-01'),2) AS projected_rev_hotelroom,
ROUND(SUM(CASE WHEN la.room_type='Private room' THEN ((30 - la.availability_30)*(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/
	(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND
	last_review>='2022-01-01'),2) AS projected_rev_privateroom,
ROUND(SUM(CASE WHEN la.room_type='Shared room' THEN ((30 - la.availability_30)*(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/
	(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND 
	last_review>='2022-01-01'),2) AS projected_rev_sharedroom
FROM
listings_austin AS la
WHERE
la.last_review >= '2022-01-01'
GROUP BY la.neighbourhood ORDER BY projected_totalrev_30 DESC;


-- 11. Potential customer list for Airbnb cleaning business
-- Look for hosts which have got large number of 'dirty' complaints.
SELECT 
listings_austin.host_id, listings_austin.host_name,  reviews_austin.comments, COUNT(*) AS num_dirty_comments, 
reviews_austin.listing_id, listings_austin.name, listings_austin.room_type
FROM
reviews_austin
INNER JOIN
listings_austin
ON
listings_austin.id = reviews_austin.listing_id
WHERE 
reviews_austin.comments LIKE '%dirty%'
GROUP BY 
listings_austin.host_id, listings_austin.host_name
ORDER BY 
num_dirty_comments DESC LIMIT 5;


-- Now we look at the reviews and ratings and the factor of superhosts.
-- A superhost is one who performs exceptionally well in his/her hosting duties. We look into detail in this superhost status.
-- 12. Proportion of super-hosts
SELECT
COUNT (DISTINCT(CASE WHEN host_is_superhost = 't' THEN host_id END)) AS Superhost,
COUNT (DISTINCT(CASE WHEN host_is_superhost = 'f' THEN host_id END)) AS Regularhost
FROM listings_austin;
-- There are 3027 super hosts with around 6524 regular hosts.
-- Lets look at the number of superhosts and regular hosts by neighbourhood.


-- 13. Superhosts Across neighbourhoods
-- By neighbourhoods, we look number of superhosts.
SELECT neighbourhood,
COUNT (DISTINCT(CASE WHEN host_is_superhost = 't' THEN host_id END)) AS Superhost,
COUNT (DISTINCT(CASE WHEN host_is_superhost = 'f' THEN host_id END)) AS Regularhost
FROM listings_austin
WHERE
last_review >= '2022-01-01'
GROUP BY neighbourhood
ORDER BY Superhost DESC;
-- Austin has the largest number of Superhosts. Majority of the listings are centred in Austin.
-- We go one step further to understand which neighbourhoods have more super hosts than the regular hosts.


--14. Neighbourhoods where superhosts are in majority
-- Here, data is filtered where the last review date is beyond 2022-01-01
SELECT neighbourhood,
COUNT (DISTINCT(CASE WHEN host_is_superhost = 't' THEN host_id END)) AS Superhost,
COUNT (DISTINCT(CASE WHEN host_is_superhost = 'f' THEN host_id END)) AS Regularhost
FROM listings_austin
WHERE
last_review >= '2022-01-01'
GROUP BY neighbourhood
HAVING Superhost > Regularhost
ORDER BY Superhost DESC;
-- There are 54 neighbourhoods where superhosts are in majority.
-- Kingsbury is one such with zero regular hosts which could tell that the hosts are performing 
-- exceptionally well in their hosting duties and giving a really good customer experience.


-- 15. Correlation of average price of a listing with superhost status
SELECT
ROUND(AVG(CASE WHEN host_is_superhost = 't' THEN (CAST(REPLACE(price, ',', '') AS INTEGER)) END),2) AS Superhost_price,
ROUND(AVG(CASE WHEN host_is_superhost = 'f' THEN (CAST(REPLACE(price, ',', '') AS INTEGER)) END),2) AS Regularhost_price
FROM listings_austin;
-- 276 vs 303, Average price for regular host is greater than for a superhost.


-- 16. Average price by neighbourhoods and a superhost status
SELECT
neighbourhood,
ROUND(AVG(CASE WHEN host_is_superhost = 't' THEN CAST(REPLACE(price, ',', '') AS INTEGER) END),2) AS Superhost_avgprice,
ROUND(AVG(CASE WHEN host_is_superhost = 'f' THEN CAST(REPLACE(price, ',', '') AS INTEGER) END),2) AS Regularhost_avgprice
FROM
listings_austin
WHERE
last_review >= '2022-01-01'
GROUP BY
neighbourhood
ORDER BY
Superhost_avgprice DESC LIMIT 10;


-- 17. Neighbourhoods where average price  for a super host is greater than for a regular host
SELECT neighbourhood, ROUND(AVG(CASE WHEN host_is_superhost = 't' THEN 
				 CAST(REPLACE(price, ',', '') AS INTEGER) END),2) AS Superhost_avg_price
FROM listings_austin
WHERE
last_review >= '2022-01-01'
GROUP BY neighbourhood
HAVING Superhost_avg_price > (SELECT AVG(CASE WHEN host_is_superhost = 'f' THEN 
				 CAST(REPLACE(price, ',', '') AS INTEGER) END))
ORDER BY Superhost_avg_price DESC;
-- Sunrise Beach Village, West Lake Hills, Garfield, Kingsland and Jonestown are in top 5 neighbourhoods 
-- where superhosts charge greater than the regular hosts.
-- There are 21 neighbourhoods where the average price of listing for super host greater than for a regular host.


-- Now we look at the ratings scores for a superhost.
-- 18. Ratings and cleanliness scores based on review
SELECT
host_is_superhost,
ROUND(AVG(review_scores_rating),2) AS Avg_rating,
ROUND(AVG(review_scores_cleanliness),2) AS Avg_cleanliness,
ROUND(AVG(review_scores_accuracy),2) AS Avg_accuracy,
ROUND(AVG(review_scores_checkin),2) AS Avg_checkin,
ROUND(AVG(review_scores_communication),2) AS Avg_comms,
ROUND(AVG(review_scores_location),2) AS Avg_loc
FROM
listings_austin
WHERE
last_review >= '2022-01-01'
GROUP BY
host_is_superhost;
-- We can see why superhosts perform better than regular hosts from the average ratings.
-- Superhosts get better ratings for cleanliness, check-in service, communication, location and the final rating also.

-- Other insights

-- 19. Instant bookable - number of listings and average price
SELECT
instant_bookable, 
COUNT(id) AS num_listings, 
ROUND(AVG(price),2) AS avg_price
FROM
listings_austin
GROUP BY
instant_bookable
ORDER BY
num_listings DESC;

-- 20. Instant bookable - number of listings by neighbourhood
SELECT
neighbourhood,
instant_bookable, 
COUNT(id) AS num_listings, 
ROUND(AVG(price),2) AS avg_price
FROM
listings_austin
GROUP BY
neighbourhood, instant_bookable
ORDER BY
num_listings DESC;


## Summary of findings:

- **Hosts and listings**: In Austin, we have 17071 listings and 9556 hosts. 80% of hosts have a single listing and there are hosts holding listings in the range from 1 to 400.
- **Neighbourhood**: Austin accounts for approximately 42% listings against rest 97 neighborhoods. 4 of top 5 priced neighborhoods hold only 1 listing.
Price per bed: Rollingwood has the highest price per bed rate around $1000, 80% more than at Westlake hills. Cypress Mill having 15 beds offers rate similar to Westlake Hills.
- **Room type**: Entire homes or apartments make up 83% of the properties, with their average price  highest. Hotel rooms cost more than combined price of shared and private rooms. Private rooms make up 16% of the listing market.
- **Revenue potential**: For the next 30 days, Austin projects close to 47% revenue share. Entire homes or apartments have more than 50-60% revenue share in majority of neighborhoods.
- **Superhosts**: 32% of property owners are superhosts, with majority of them in Austin and 54 such neighborhoods having more superhosts than regular hosts.
- **Ratings**: Superhosts appear to receive higher review scores on average for cleanliness, location, communication etc. than regular hosts.
