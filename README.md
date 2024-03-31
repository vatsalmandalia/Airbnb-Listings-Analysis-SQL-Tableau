# Airbnb Listings Analysis Using SQL and Tableau
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

The aim behind this analysis is to understand the local rental market in Austin, Texas and how Airbnb has become the key choice for vacationers interested in temporary accommodation at their holiday destination.

## Preparation and Cleaning

There are three datasets sourced from Inside Airbnb - listings, calendar, reviews.
![Screenshot 2023-09-11 at 11 09 25 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/9fffcbff-8e5d-480f-aca9-76583719405d)


In the listings data, the 'price' field is of TEXT data type and contains a non-numeric character '$'. This is treated manually from the 'Modify table' option in 'Edit' menu in DB Browser for SQLite application.

Data has been scraped as on 8th June 2022 from the Inside Airbnb.

For executing queries to manipulate and mine data, I employ DB Browser for SQLite tool. Tableau Public has been utilised to visualize underlying trends and produce impactful dashboards.

## Business problems

- How many listings and hosts are there in Austin? Are there hosts with multiple listings?
- Across neighborhoods, what is the proportion of listings and the price situation?
- What is the price per bed trend by each neighborhood?
- What is the division of each type of room among all listings? How does the price correlate with a room type and neighbourhood?
- In the next 30-day period, who are the top revenue earners? How does this revenue potential vary by neighborhoods and room types?
- What is the outlook of superhosts across each neighborhood – in terms of numbers, price and ratings?

## Exploratory Data Analysis

The above business questions are addressed using the below queries.<BR>

**1. Number of listings and hosts**<BR>
![Picture 1](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/8de1a5ce-9c4c-489b-a0b8-1dec222fba7e)

<BR>

**2. Hosts with multiple listings**<BR>
![Screenshot 2023-09-11 at 11 27 24 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/8ce661d3-5f37-4cc9-b018-923b15211584)

<BR>

 **3. Average price and number of listings by neighbourhood**<BR>
![Screenshot 2023-09-11 at 11 30 52 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/aa4f4659-65e1-491d-b236-d0065f806787)

<BR>

**4.Neighborhoods ordered by number of listings in descending**<BR>
![Screenshot 2023-09-11 at 11 32 19 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/5823d64c-b7fc-4db6-bd90-332282086062)

<BR>

**5. Price per bed by neighbourhood**<BR>
![Screenshot 2023-09-11 at 11 34 04 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/df34c3f9-b1a2-4938-b88d-fcf178dda5ac)

<BR>

**6. Number of listings by room type and correlation between price and room type**<BR>
![Screenshot 2023-09-11 at 11 35 42 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/f11de5a0-ec55-43c3-ac67-c18153834f06)

<BR>

**7. By neighborhood, average price per room type**<BR>
![Screenshot 2023-09-11 at 11 37 03 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/def9af5e-ed75-4340-b5ec-89e00abb5345)

<BR>

**8. Projected revenue for each listing based on number of days it is booked in next 30 days**<BR>
![Screenshot 2023-09-11 at 11 38 25 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/03d17cf4-89e3-4efb-8a9e-00b97aef9991)

<BR>

**Looking at availability for next year**<BR>
![Screenshot 2023-09-11 at 11 39 51 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/fc9683a7-16d0-42cb-b910-30e819b8bf72)

<BR>

**9. Projected revenue for each neighbourhood for the next 30 days**<BR>
![Screenshot 2023-09-11 at 11 41 14 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/9b5e6132-addf-4cf7-a676-516768f00e04)

<BR>

**10. Revenue potential by neighbourhood and room type**<BR>
![Screenshot 2023-09-11 at 11 44 57 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/4a386661-37de-49e7-9156-d33c3b4cf224)

<BR>

**11. Potential customer list for Airbnb cleaning business**<BR>
![Screenshot 2023-09-11 at 11 46 22 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/da865b51-653c-487e-a4ac-65bc22f6f1c9)

<BR>

**12. Proportion of super-hosts**<BR>
![Screenshot 2023-09-11 at 11 48 21 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/58399250-5a57-4d76-bf5e-8c7c9491ba52)

<BR>

**13. Superhosts Across neighbourhoods**<BR>
![Picture 2](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/9256a930-8e9e-4f4d-b1a7-b09457a431e6)

<BR>

**14. Neighbourhoods where superhosts are in majority**<BR>
![Screenshot 2023-09-11 at 11 54 17 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/7f844d45-c6bc-4283-9134-685754c22058)

<BR>

**15. Correlation of average price of a listing with superhost status**<BR>
![Screenshot 2023-09-11 at 11 55 02 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/5d2162d3-5768-4fd3-bad5-12bd80395370)

<BR>

**16. Average price by neighbourhoods and a superhost status**<BR>
![Screenshot 2023-09-11 at 11 57 01 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/d11e98e9-ef99-4b81-8154-59a5314d3d5d)

<BR>

**17. Neighbourhoods where average price for a super host is greater than for a regular host**<BR>
![Screenshot 2023-09-11 at 11 59 03 AM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/88946a75-8a71-4ba2-b74a-b348ed5c3ecc)

<BR>

**18. Ratings and cleanliness scores based on review**<BR>
![Screenshot 2023-09-11 at 12 00 19 PM](https://github.com/vatsalmandalia/Airbnb-Listings-Analysis-SQL-Tableau/assets/63712490/10fd6bc5-f82c-42f8-8429-c1062595bdff)

<BR>

## Summary of findings

- **Hosts and listings**: In Austin, we have 17071 listings and 9556 hosts. 80% of hosts have a single listing and there are hosts holding listings in the range from 1 to 400.
- **Neighbourhood**: Austin accounts for approximately 42% listings against rest 97 neighborhoods. 4 of top 5 priced neighborhoods hold only 1 listing.
Price per bed: Rollingwood has the highest price per bed rate around $1000, 80% more than at Westlake hills. Cypress Mill having 15 beds offers rate similar to Westlake Hills.
- **Room type**: Entire homes or apartments make up 83% of the properties, with their average price  highest. Hotel rooms cost more than combined price of shared and private rooms. Private rooms make up 16% of the listing market.
- **Revenue potential**: For the next 30 days, Austin projects close to 47% revenue share. Entire homes or apartments have more than 50-60% revenue share in majority of neighborhoods.
- **Superhosts**: 32% of property owners are superhosts, with majority of them in Austin and 54 such neighborhoods having more superhosts than regular hosts.
- **Ratings**: Superhosts appear to receive higher review scores on average for cleanliness, location, communication etc. than regular hosts.

## Dashboards in Tableau

I have created two dashboards depicting two sets of analysis and insights.
- Price and Proportion Analysis : [View in Tableau](https://public.tableau.com/views/AirbnbAnalysisforAustin/PriceandProportionAnalysis?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link)
- Revenue Potential and Superhost Status : [View in Tableau](https://public.tableau.com/views/AirbnbAnalysisforAustin-RevenuePotentialandSuperhostStatus/RevenuePotentialandSuperhostStatus?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link)
