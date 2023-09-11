# Airbnb-Listings-Analysis-SQL-Tableau

This repository contains the project on Airbnb Listings Analysis done using SQL and Tableau. This project is inspired from the Guided Project done by Avery Smith on Airbnb Exploratory Data Analysis.

## Structure of Analysis

1. Background
2. Preparation and Cleaning
3. Business problems
4. Exploratory Data Analysis
5. Summary of the findings

## Background

Airbnb is an online market-place for property owners to host their properties for tourists looking to book for short-term homestays. It is a medium between hosts and potential customers looking to make book listings in specific locations. Airbnb currently has over 100,000+ listings spread over 6 countries.

For my analysis, I am only considering only the data for Austin, Texas.

## Preparation and Cleaning

There are three datasets sourced from Inside Airbnb - listings, calendar, reviews. In the listings data, the 'price' field is of TEXT data type and contains a non-numeric character '$'. This is treated from the 'Modify table' option in 'Edit' menu.

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

-- Data preparation<BR>
-- Removing the '$' sign in 'price' column<BR>
-- Data type changed through 'Edit' in menu bar and 'Modify table'.<BR>

/* --------------- Data Exploration --------------- */<BR>
**-- 1. Lets look at number of listings and hosts**<BR>
SELECT<BR>
COUNT(DISTINCT(listings_austin.id)) AS Num_of_listings,<BR>
COUNT(DISTINCT(listings_austin.host_id)) AS Num_of_hosts<BR>
FROM listings_austin;
<BR>

**-- 2. Number of hosts**<BR>
SELECT COUNT(DISTINCT(listings_austin.host_id)) AS Num_of_hosts<BR>
FROM listings_austin;<BR>
-- Number of hosts = 9556
<BR>

**-- 3. Hosts with multiple listings**<BR>
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
 -- Close to 80% of hosts are single-property hosts.
<BR>

 **-- 4. Average price and number of listings by neighbourhood**<BR>
 -- For Cypress Mill, price value has a comma. This affects the average function resulting in wrong result.<BR>
 -- Remove the commas in the price column while calculating the average price.<BR>
SELECT<BR>
neighbourhood,<BR> 
COUNT(id) AS Num_listings,<BR> 
ROUND(AVG(CAST(REPLACE(price, ',', '') AS INTEGER)),2) AS Average_price<BR>
FROM listings_austin<BR>
GROUP BY neighbourhood<BR>
ORDER BY Average_price ASC;<BR>
 -- Cypress Mill having a single listing has the highest average price, around 50% more than at Burnet County.

 -- Neighborhoods ordered by number of listings in descending<BR>
SELECT<BR>
neighbourhood,<BR>
COUNT(id) AS Num_listings,<BR>
ROUND(COUNT(id)*100.0/(SELECT COUNT(DISTINCT (id)) FROM listings_austin),2) AS Perc_listings<BR>
FROM listings_austin<BR>
GROUP BY neighbourhood<BR>
ORDER BY num_listings DESC LIMIT 5;<BR>
-- Austin has largest number of listings.<BR> 
-- There is also a significant number listings assigned to a neighbourhood with a NULL value.
<BR>

**-- 5. Price per bed by neighbourhood**<BR>
SELECT neighbourhood, beds, ROUND(SUM(CAST(REPLACE(price, ',', '') AS INTEGER))/SUM(beds),2) AS Price_per_bed<BR>
FROM listings_austin<BR>
GROUP BY neighbourhood<BR>
ORDER BY Price_per_bed DESC LIMIT 5;<BR>
-- Price per bed in Rollingwood, single bed neighbourhood, is 5 times more than at Westlake Hills.<BR>
-- Rollingwood is one of the most affluent and sought-after neighbourhoods in Austin.
<BR>

**-- 6. Number of listings by room type and correlation between price and room type**<BR>
SELECT<BR>
room_type,<BR>
ROUND(AVG(CAST(REPLACE(price, ',', '') AS INTEGER)),2) AS Average_price,<BR>
COUNT(DISTINCT id) AS Number_of_listings,<BR>
ROUND(COUNT(DISTINCT id)*100.0/(SELECT COUNT(DISTINCT id) FROM listings_austin),2) AS Proportion_of_listings<BR>
FROM<BR>
listings_austin<BR>
GROUP BY<BR>
room_type<BR>
ORDER BY<BR>
Average_price DESC;<BR>
 -- Entire home/apartment is priced higher than others on average.<BR>
 -- 83% of the listings approximately are entire homes or apartments. Hotel and shared rooms are in the minority among all 17071 listings.<BR>
 -- But, it is observed the cost of a hotel room more than combined price of private and shared rooms.
<BR>

**-- 7. By neighborhood, average price per room type**<BR>
SELECT<BR>
neighbourhood,<BR>
room_type,<BR>
ROUND(AVG(CAST(REPLACE(price, ',', '') AS INTEGER)),2) AS Average_price,<BR>
COUNT(DISTINCT id) AS Number_of_listings<BR>
FROM<BR>
listings_austin<BR>
GROUP BY<BR>
neighbourhood,<BR>
room_type<BR>
ORDER BY<BR>
Average_price DESC;<BR>
-- 8 out of the top 10 in average prices are homes or apartments.<BR>
-- Hotel rooms and private rooms in Austin and Rollingwood respectively are other two.
<BR>

**-- 8. Projected revenue for each listing based on number of days it is booked in next 30 days**<BR>
SELECT<BR>
id,<BR>
listing_url,<BR>
CAST(REPLACE(price, ',', '') AS INTEGER) AS Price_listing,<BR>
name,<BR>
(30 - availability_30) AS booked_next_30,<BR>
(30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER) AS projected_rev_30<BR>
FROM listings_austin<BR>
ORDER BY projected_rev_30 DESC LIMIT 5;

**-- Looking at availability for next year**<BR>
SELECT id, listing_url, CAST(REPLACE(price, ',', '') AS INTEGER) AS Price_listing, name, availability_365, property_type,<BR>
(365 - availability_365)*CAST(REPLACE(price, ',', '') AS INTEGER) AS projected_rev_365<BR>
FROM listings_austin<BR>
ORDER BY projected_rev_365 DESC LIMIT 5;
<BR>

-- Now lets understand the revenue numbers by neighbourhood.<BR>
-- Which neighbourhoods lead the way in terms of revenue earned?<BR>
**-- 9. Projected revenue for each neighbourhood for the next 30 days**<BR>
-- Filtering listings based on last review data. Considering only those listings <BR>
-- where a review was made in past 6 months from 2022-06-08<BR>
SELECT<BR>
neighbourhood,<BR>
SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) AS projected_rev_30,<BR>
ROUND((SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER))*100.0/<BR>
	(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER))<BR> 
	  FROM listings_austin WHERE last_review >= '2022-01-01' )),2) AS Revenue_share,<BR>
COUNT(DISTINCT id) AS num_listings<BR>
FROM<BR>
listings_austin<BR>
WHERE<BR>
last_review >= '2022-01-01' AND neighbourhood IS NOT NULL<BR>
GROUP BY<BR>
neighbourhood<BR>
ORDER BY<BR>
projected_rev_30 DESC LIMIT 5;
<BR>

-- Deeper analysis by looking revenue potential by neighbourhood and room type.<BR>
-- Listings filtered where last review >= '2022-01-01'<BR>
**-- 10. Revenue potential by neighbourhood and room type**<BR>
SELECT<BR>
la.neighbourhood,<BR>
SUM((30 - la.availability_30)*(CAST(REPLACE(la.price, ',', '') AS INTEGER))) AS projected_totalrev_30,<BR>
ROUND(SUM(CASE WHEN la.room_type='Entire home/apt' THEN ((30 - la.availability_30)*(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/<BR>
	(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND<BR> 
	last_review>='2022-01-01'),2) AS projected_rev_entirehome,<BR>
ROUND(SUM(CASE WHEN la.room_type='Hotel room' THEN ((30 - la.availability_30)*(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/<BR>
	(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND<BR> 
	last_review>='2022-01-01'),2) AS projected_rev_hotelroom,<BR>
ROUND(SUM(CASE WHEN la.room_type='Private room' THEN ((30 - la.availability_30)*(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/<BR>
	(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND<BR>
	last_review>='2022-01-01'),2) AS projected_rev_privateroom,<BR>
ROUND(SUM(CASE WHEN la.room_type='Shared room' THEN ((30 - la.availability_30)*(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/<BR>
	(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND<BR> 
	last_review>='2022-01-01'),2) AS projected_rev_sharedroom<BR>
FROM<BR>
listings_austin AS la<BR>
WHERE<BR>
la.last_review >= '2022-01-01'<BR>
GROUP BY la.neighbourhood ORDER BY projected_totalrev_30 DESC;
<BR>

**-- 11. Potential customer list for Airbnb cleaning business**<BR>
-- Look for hosts which have got large number of 'dirty' complaints.<BR>
SELECT<BR>
listings_austin.host_id, listings_austin.host_name,  reviews_austin.comments, COUNT(*) AS num_dirty_comments,<BR> 
reviews_austin.listing_id, listings_austin.name, listings_austin.room_type<BR>
FROM<BR>
reviews_austin<BR>
INNER JOIN<BR>
listings_austin<BR>
ON<BR>
listings_austin.id = reviews_austin.listing_id<BR>
WHERE<BR>
reviews_austin.comments LIKE '%dirty%'<BR>
GROUP BY<BR> 
listings_austin.host_id, listings_austin.host_name<BR>
ORDER BY<BR> 
num_dirty_comments DESC LIMIT 5;
<BR>

-- Superhosts<BR>
-- A superhost is one who performs exceptionally well in his/her hosting duties. We look into detail in this superhost status.<BR>
**-- 12. Proportion of super-hosts**<BR>
SELECT<BR>
COUNT (DISTINCT(CASE WHEN host_is_superhost = 't' THEN host_id END)) AS Superhost,<BR>
COUNT (DISTINCT(CASE WHEN host_is_superhost = 'f' THEN host_id END)) AS Regularhost<BR>
FROM listings_austin;<BR>
-- There are 3027 super hosts with around 6524 regular hosts.<BR>
-- Lets look at the number of superhosts and regular hosts by neighbourhood.
<BR>

**-- 13. Superhosts Across neighbourhoods**<BR>
-- By neighbourhoods, we look number of superhosts.<BR>
SELECT neighbourhood,<BR>
COUNT (DISTINCT(CASE WHEN host_is_superhost = 't' THEN host_id END)) AS Superhost,<BR>
COUNT (DISTINCT(CASE WHEN host_is_superhost = 'f' THEN host_id END)) AS Regularhost<BR>
FROM listings_austin<BR>
WHERE<BR>
last_review >= '2022-01-01'<BR>
GROUP BY neighbourhood<BR>
ORDER BY Superhost DESC;<BR>
-- Austin has the largest number of Superhosts. Majority of the listings are centred in Austin.<BR>
-- We go one step further to understand which neighbourhoods have more super hosts than the regular hosts.
<BR>

**-- 14. Neighbourhoods where superhosts are in majority**<BR>
-- Here, data is filtered where the last review date is beyond 2022-01-01<BR>
SELECT neighbourhood,<BR>
COUNT (DISTINCT(CASE WHEN host_is_superhost = 't' THEN host_id END)) AS Superhost,<BR>
COUNT (DISTINCT(CASE WHEN host_is_superhost = 'f' THEN host_id END)) AS Regularhost<BR>
FROM listings_austin<BR>
WHERE<BR>
last_review >= '2022-01-01'<BR>
GROUP BY neighbourhood<BR>
HAVING Superhost > Regularhost<BR>
ORDER BY Superhost DESC;<BR>
-- There are 54 neighbourhoods where superhosts are in majority.<BR>
-- Kingsbury is one such with zero regular hosts which could tell that the hosts are performing<BR>
-- exceptionally well in their hosting duties and giving a really good customer experience.<BR>
<BR>

**-- 15. Correlation of average price of a listing with superhost status**<BR>
SELECT<BR>
ROUND(AVG(CASE WHEN host_is_superhost = 't' THEN (CAST(REPLACE(price, ',', '') AS INTEGER)) END),2) AS Superhost_price,<BR>
ROUND(AVG(CASE WHEN host_is_superhost = 'f' THEN (CAST(REPLACE(price, ',', '') AS INTEGER)) END),2) AS Regularhost_price<BR>
FROM listings_austin;<BR>
-- 276 vs 303, Average price for regular host is greater than for a superhost.<BR>
<BR>

**-- 16. Average price by neighbourhoods and a superhost status**<BR>
SELECT<BR>
neighbourhood,<BR>
ROUND(AVG(CASE WHEN host_is_superhost = 't' THEN CAST(REPLACE(price, ',', '') AS INTEGER) END),2) AS Superhost_avgprice,<BR>
ROUND(AVG(CASE WHEN host_is_superhost = 'f' THEN CAST(REPLACE(price, ',', '') AS INTEGER) END),2) AS Regularhost_avgprice<BR>
FROM<BR>
listings_austin<BR>
WHERE<BR>
last_review >= '2022-01-01'<BR>
GROUP BY<BR>
neighbourhood<BR>
ORDER BY<BR>
Superhost_avgprice DESC LIMIT 10;
<BR>

**-- 17. Neighbourhoods where average price  for a super host is greater than for a regular host**<BR>
SELECT neighbourhood, ROUND(AVG(CASE WHEN host_is_superhost = 't' THEN CAST(REPLACE(price, ',', '') AS INTEGER) END),2) AS Superhost_avg_price<BR>
FROM listings_austin<BR>
WHERE<BR>
last_review >= '2022-01-01'<BR>
GROUP BY neighbourhood<BR>
HAVING Superhost_avg_price > (SELECT AVG(CASE WHEN host_is_superhost = 'f' THEN CAST(REPLACE(price, ',', '') AS INTEGER) END))<BR>
ORDER BY Superhost_avg_price DESC;<BR>
-- Sunrise Beach Village, West Lake Hills, Garfield, Kingsland and Jonestown are in top 5 neighbourhoods.<BR>
-- where superhosts charge greater than the regular hosts.<BR>
-- There are 21 neighbourhoods where the average price of listing for super host greater than for a regular host.<BR>
<BR>

-- Now we look at the ratings scores for a superhost.<BR>
**-- 18. Ratings and cleanliness scores based on review**<BR>
SELECT<BR>
host_is_superhost,<BR>
ROUND(AVG(review_scores_rating),2) AS Avg_rating,<BR>
ROUND(AVG(review_scores_cleanliness),2) AS Avg_cleanliness,<BR>
ROUND(AVG(review_scores_accuracy),2) AS Avg_accuracy,<BR>
ROUND(AVG(review_scores_checkin),2) AS Avg_checkin,<BR>
ROUND(AVG(review_scores_communication),2) AS Avg_comms,<BR>
ROUND(AVG(review_scores_location),2) AS Avg_loc<BR>
FROM<BR>
listings_austin<BR>
WHERE<BR>
last_review >= '2022-01-01'<BR>
GROUP BY<BR>
host_is_superhost;<BR>
-- We can see why superhosts perform better than regular hosts from the average ratings.<BR>
-- Superhosts get better ratings for cleanliness, check-in service, communication, location and the final rating also.
<BR>

-- Other insights<BR>
**-- 19. Instant bookable - number of listings and average price**<BR>
SELECT<BR>
instant_bookable,<BR> 
COUNT(id) AS num_listings,<BR>
ROUND(AVG(price),2) AS avg_price<BR>
FROM<BR>
listings_austin<BR>
GROUP BY<BR>
instant_bookable<BR>
ORDER BY<BR>
num_listings DESC;<BR>
<BR>

**-- 20. Instant bookable - number of listings by neighbourhood**<BR>
SELECT<BR>
neighbourhood,<BR>
instant_bookable,<BR> 
COUNT(id) AS num_listings,<BR> 
ROUND(AVG(price),2) AS avg_price<BR>
FROM<BR>
listings_austin<BR>
GROUP BY<BR>
neighbourhood, instant_bookable<BR>
ORDER BY<BR>
num_listings DESC;<BR>


## Summary of findings:<BR>

- **Hosts and listings**: In Austin, we have 17071 listings and 9556 hosts. 80% of hosts have a single listing and there are hosts holding listings in the range from 1 to 400.
- **Neighbourhood**: Austin accounts for approximately 42% listings against rest 97 neighborhoods. 4 of top 5 priced neighborhoods hold only 1 listing.
Price per bed: Rollingwood has the highest price per bed rate around $1000, 80% more than at Westlake hills. Cypress Mill having 15 beds offers rate similar to Westlake Hills.
- **Room type**: Entire homes or apartments make up 83% of the properties, with their average price  highest. Hotel rooms cost more than combined price of shared and private rooms. Private rooms make up 16% of the listing market.
- **Revenue potential**: For the next 30 days, Austin projects close to 47% revenue share. Entire homes or apartments have more than 50-60% revenue share in majority of neighborhoods.
- **Superhosts**: 32% of property owners are superhosts, with majority of them in Austin and 54 such neighborhoods having more superhosts than regular hosts.
- **Ratings**: Superhosts appear to receive higher review scores on average for cleanliness, location, communication etc. than regular hosts.
