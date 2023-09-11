-- 1. Lets look at number of listings and hosts
SELECT
COUNT(DISTINCT(listings_austin.id)) AS Num_of_listings,
COUNT(DISTINCT(listings_austin.host_id)) AS Num_of_hosts
FROM listings_austin; 

-- 2. Hosts with multiple listings
SELECT
num_listings_per_host,
COUNT(host_id) AS num_hosts,
ROUND(COUNT(host_id)*100.0/(SELECT COUNT(DISTINCT (host_id)) FROM listings_austin),2) AS Host_percentage
FROM (SELECT host_id, COUNT(DISTINCT id) AS num_listings_per_host FROM listings_austin GROUP BY host_id)
GROUP BY
num_listings_per_host
ORDER BY
num_listings_per_host;
-- There are hosts with a single listing and also with little less than 400 listings.
-- Close to 80% of hosts are single-property hosts. 

-- 3. Average price and number of listings by neighbourhood
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

-- 4. Price per bed by neighbourhood
SELECT neighbourhood, beds, ROUND(SUM(CAST(REPLACE(price, ',', '') AS INTEGER))/SUM(beds),2) AS Price_per_bed
FROM listings_austin
GROUP BY neighbourhood
ORDER BY Price_per_bed DESC LIMIT 5;
-- Price per bed in Rollingwood, single bed neighbourhood, is 5 times more than at Westlake Hills.
-- Rollingwood is one of the most affluent and sought-after neighbourhoods in Austin. 

-- 5. Number of listings by room type and correlation between price and room type
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

-- 6. By neighborhood, average price per room type
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

-- 7. Projected revenue for each listing based on number of days it is booked in next 30 days
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
-- 8. Projected revenue for each neighbourhood for the next 30 days
-- Filtering listings based on last review data. Considering only those listings 
-- where a review was made in past 6 months from 2022-06-08
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
-- 9. Revenue potential by neighbourhood and room type
SELECT
la.neighbourhood,
SUM((30 - la.availability_30)(CAST(REPLACE(la.price, ',', '') AS INTEGER))) AS projected_totalrev_30,
ROUND(SUM(CASE WHEN la.room_type='Entire home/apt' THEN ((30 - la.availability_30)(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/
(SELECT SUM((30 - availability_30)CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND
last_review>='2022-01-01'),2) AS projected_rev_entirehome,
ROUND(SUM(CASE WHEN la.room_type='Hotel room' THEN ((30 - la.availability_30)(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/
(SELECT SUM((30 - availability_30)CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND
last_review>='2022-01-01'),2) AS projected_rev_hotelroom,
ROUND(SUM(CASE WHEN la.room_type='Private room' THEN ((30 - la.availability_30)(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/
(SELECT SUM((30 - availability_30)CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND
last_review>='2022-01-01'),2) AS projected_rev_privateroom,
ROUND(SUM(CASE WHEN la.room_type='Shared room' THEN ((30 - la.availability_30)(CAST(REPLACE(la.price, ',', '') AS INTEGER))) END)*100.0/
(SELECT SUM((30 - availability_30)*CAST(REPLACE(price, ',', '') AS INTEGER)) FROM listings_austin WHERE neighbourhood = la.neighbourhood AND
last_review>='2022-01-01'),2) AS projected_rev_sharedroom
FROM
listings_austin AS la
WHERE
la.last_review >= '2022-01-01'
GROUP BY la.neighbourhood ORDER BY projected_totalrev_30 DESC; 

-- 10. Potential customer list for Airbnb cleaning business
-- Look for hosts which have got large number of 'dirty' complaints.
SELECT
listings_austin.host_id, listings_austin.host_name, reviews_austin.comments, COUNT(*) AS num_dirty_comments,
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

-- Superhosts
-- A superhost is one who performs exceptionally well in his/her hosting duties. We look into detail in this superhost status.
-- 11. Proportion of super-hosts
SELECT
COUNT (DISTINCT(CASE WHEN host_is_superhost = 't' THEN host_id END)) AS Superhost,
COUNT (DISTINCT(CASE WHEN host_is_superhost = 'f' THEN host_id END)) AS Regularhost
FROM listings_austin;
-- There are 3027 super hosts with around 6524 regular hosts.
-- Lets look at the number of superhosts and regular hosts by neighbourhood. 

-- 12. Superhosts Across neighbourhoods
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

-- 13. Neighbourhoods where superhosts are in majority
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


-- 14. Correlation of average price of a listing with superhost status
SELECT
ROUND(AVG(CASE WHEN host_is_superhost = 't' THEN (CAST(REPLACE(price, ',', '') AS INTEGER)) END),2) AS Superhost_price,
ROUND(AVG(CASE WHEN host_is_superhost = 'f' THEN (CAST(REPLACE(price, ',', '') AS INTEGER)) END),2) AS Regularhost_price
FROM listings_austin;
-- 276 vs 303, Average price for regular host is greater than for a superhost.


-- 15. Average price by neighbourhoods and a superhost status
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

-- 16. Neighbourhoods where average price for a super host is greater than for a regular host
SELECT neighbourhood, ROUND(AVG(CASE WHEN host_is_superhost = 't' THEN CAST(REPLACE(price, ',', '') AS INTEGER) END),2) AS Superhost_avg_price
FROM listings_austin
WHERE
last_review >= '2022-01-01'
GROUP BY neighbourhood
HAVING Superhost_avg_price > (SELECT AVG(CASE WHEN host_is_superhost = 'f' THEN CAST(REPLACE(price, ',', '') AS INTEGER) END))
ORDER BY Superhost_avg_price DESC;
-- Sunrise Beach Village, West Lake Hills, Garfield, Kingsland and Jonestown are in top 5 neighbourhoods.
-- where superhosts charge greater than the regular hosts.
-- There are 21 neighbourhoods where the average price of listing for super host greater than for a regular host.


-- Now we look at the ratings scores for a superhost.
-- 17. Ratings and cleanliness scores based on review
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
-- 18. Instant bookable - number of listings and average price
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


-- 19. Instant bookable - number of listings by neighbourhood
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