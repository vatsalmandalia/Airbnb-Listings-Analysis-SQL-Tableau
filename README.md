# Airbnb-Listings-Analysis-SQL-Tableau
![0*NChTo-XqLOxLabIW](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/a3f69848-63ef-4c69-9ca1-a903453ad4fc)


This repository contains the project on Airbnb Listings Analysis done using SQL and Tableau. This project is inspired from the project - Analysis of Airbnb Data Using SQL - done by Avery Smith.
[Analysis of Airbnb Data Using SQL](https://www.youtube.com/watch?v=CHb-QvGcRjw)

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

There are three datasets sourced from Inside Airbnb - listings, calendar, reviews.
![Screenshot 2023-09-11 at 11 09 25 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/9fffcbff-8e5d-480f-aca9-76583719405d)


In the listings data, the 'price' field is of TEXT data type and contains a non-numeric character '$'. This is treated from the 'Modify table' option in 'Edit' menu.

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
![Picture 1](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/8de1a5ce-9c4c-489b-a0b8-1dec222fba7e)


**-- 2. Hosts with multiple listings**<BR>
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
![Screenshot 2023-09-11 at 11 27 24 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/8ce661d3-5f37-4cc9-b018-923b15211584)


 **-- 3. Average price and number of listings by neighbourhood**<BR>
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
![Screenshot 2023-09-11 at 11 30 52 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/aa4f4659-65e1-491d-b236-d0065f806787)


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
![Screenshot 2023-09-11 at 11 32 19 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/5823d64c-b7fc-4db6-bd90-332282086062)


**-- 5. Price per bed by neighbourhood**<BR>
SELECT neighbourhood, beds, ROUND(SUM(CAST(REPLACE(price, ',', '') AS INTEGER))/SUM(beds),2) AS Price_per_bed<BR>
FROM listings_austin<BR>
GROUP BY neighbourhood<BR>
ORDER BY Price_per_bed DESC LIMIT 5;<BR>
-- Price per bed in Rollingwood, single bed neighbourhood, is 5 times more than at Westlake Hills.<BR>
-- Rollingwood is one of the most affluent and sought-after neighbourhoods in Austin.
<BR>
![Screenshot 2023-09-11 at 11 34 04 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/df34c3f9-b1a2-4938-b88d-fcf178dda5ac)


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
![Screenshot 2023-09-11 at 11 35 42 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/f11de5a0-ec55-43c3-ac67-c18153834f06)


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
![Screenshot 2023-09-11 at 11 37 03 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/def9af5e-ed75-4340-b5ec-89e00abb5345)


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
<BR>
![Screenshot 2023-09-11 at 11 38 25 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/03d17cf4-89e3-4efb-8a9e-00b97aef9991)


**-- Looking at availability for next year**<BR>
SELECT id, listing_url, CAST(REPLACE(price, ',', '') AS INTEGER) AS Price_listing, name, availability_365, property_type,<BR>
(365 - availability_365)*CAST(REPLACE(price, ',', '') AS INTEGER) AS projected_rev_365<BR>
FROM listings_austin<BR>
ORDER BY projected_rev_365 DESC LIMIT 5;
<BR>
![Screenshot 2023-09-11 at 11 39 51 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/fc9683a7-16d0-42cb-b910-30e819b8bf72)


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
![Screenshot 2023-09-11 at 11 41 14 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/9b5e6132-addf-4cf7-a676-516768f00e04)


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
![Screenshot 2023-09-11 at 11 44 57 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/4a386661-37de-49e7-9156-d33c3b4cf224)


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
![Screenshot 2023-09-11 at 11 46 22 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/da865b51-653c-487e-a4ac-65bc22f6f1c9)


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
![Screenshot 2023-09-11 at 11 48 21 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/58399250-5a57-4d76-bf5e-8c7c9491ba52)


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
![Picture 2](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/9256a930-8e9e-4f4d-b1a7-b09457a431e6)


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
![Screenshot 2023-09-11 at 11 54 17 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/7f844d45-c6bc-4283-9134-685754c22058)


**-- 15. Correlation of average price of a listing with superhost status**<BR>
SELECT<BR>
ROUND(AVG(CASE WHEN host_is_superhost = 't' THEN (CAST(REPLACE(price, ',', '') AS INTEGER)) END),2) AS Superhost_price,<BR>
ROUND(AVG(CASE WHEN host_is_superhost = 'f' THEN (CAST(REPLACE(price, ',', '') AS INTEGER)) END),2) AS Regularhost_price<BR>
FROM listings_austin;<BR>
-- 276 vs 303, Average price for regular host is greater than for a superhost.<BR>
<BR>
![Screenshot 2023-09-11 at 11 55 02 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/5d2162d3-5768-4fd3-bad5-12bd80395370)


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
![Screenshot 2023-09-11 at 11 57 01 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/d11e98e9-ef99-4b81-8154-59a5314d3d5d)


**-- 17. Neighbourhoods where average price for a super host is greater than for a regular host**<BR>
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
![Screenshot 2023-09-11 at 11 59 03 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/88946a75-8a71-4ba2-b74a-b348ed5c3ecc)


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
![Screenshot 2023-09-11 at 12 00 19 PM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/10fd6bc5-f82c-42f8-8429-c1062595bdff)


## Summary of findings:<BR>

- **Hosts and listings**: In Austin, we have 17071 listings and 9556 hosts. 80% of hosts have a single listing and there are hosts holding listings in the range from 1 to 400.
- **Neighbourhood**: Austin accounts for approximately 42% listings against rest 97 neighborhoods. 4 of top 5 priced neighborhoods hold only 1 listing.
Price per bed: Rollingwood has the highest price per bed rate around $1000, 80% more than at Westlake hills. Cypress Mill having 15 beds offers rate similar to Westlake Hills.
- **Room type**: Entire homes or apartments make up 83% of the properties, with their average price  highest. Hotel rooms cost more than combined price of shared and private rooms. Private rooms make up 16% of the listing market.
- **Revenue potential**: For the next 30 days, Austin projects close to 47% revenue share. Entire homes or apartments have more than 50-60% revenue share in majority of neighborhoods.
- **Superhosts**: 32% of property owners are superhosts, with majority of them in Austin and 54 such neighborhoods having more superhosts than regular hosts.
- **Ratings**: Superhosts appear to receive higher review scores on average for cleanliness, location, communication etc. than regular hosts.
