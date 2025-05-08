-- DATA ANALYSIS PROJECT FOR RENTAL MOVIES BUSINESS
-- THE STEPS INVOLVED ARE EDA, UNDERSTANDING THR SCHEMA AND ANSWERING THE AD-HOC QUESTIONS
-- BUSINESS QUESTIONS LIKE EXPANDING MOVIES COLLECTION AND FETCHING EMAIL IDS FOR MARKETING ARE INCLUDED
-- HELPING COMPANY KEEP A TRACK OF INVENTORY AND HELP MANAGE IT.

USE MAVENMOVIES;

-- EXPLORATORY DATA ANALYSIS --

-- UNDERSTANDING THE SCHEMA --

SELECT * FROM RENTAL;

SELECT CUSTOMER_ID, RENTAL_DATE
FROM RENTAL;

SELECT * FROM INVENTORY;

SELECT * FROM FILM;

SELECT * FROM CUSTOMER;

-- You need to provide customer firstname, lastname and email id to the marketing team --

SELECT first_name,last_name,email
FROM CUSTOMER;

-- How many movies are with rental rate of $0.99? --

SELECT count(*) as CHEAPEST_RENTALS
FROM film
WHERE rental_rate = 0.99;

-- We want to see rental rate and how many movies are in each rental category --

SELECT RENTAL_RATE,COUNT(*) AS NUMBER_OF_MOVIES
FROM FILM
GROUP BY RENTAL_RATE;

-- Which rating has the most films? --

SELECT RATING,COUNT(*) AS RATING_CATEGORY_COUNT
FROM FILM
GROUP BY RATING
ORDER BY RATING_CATEGORY_COUNT DESC;

-- Which rating is most prevalant in each store? --

SELECT I.store_id,F.rating,COUNT(F.rating) AS TOTAL_FILMS
FROM inventory AS I LEFT JOIN
	film AS F
ON I.film_id = F.film_id
GROUP BY I.store_id,F.rating
ORDER BY TOTAL_FILMS DESC;

-- List of films by Film Name, Category, Language --

SELECT F.TITLE AS FILM_NAME, C.NAME AS CATEGORY_NAME, LAN.NAME AS LANGUAGE_NAME
FROM FILM_CATEGORY AS FC LEFT JOIN CATEGORY AS C
ON FC.CATEGORY_ID = C.CATEGORY_ID LEFT JOIN FILM AS F
ON FC.FILM_ID = F.FILM_ID LEFT JOIN LANGUAGE AS LAN
ON F.LANGUAGE_ID = LAN.LANGUAGE_ID;

-- How many times each movie has been rented out?

SELECT F.FILM_ID,F.TITLE,COUNT(*) AS COUNT_OF_MOVIES
FROM RENTAL R LEFT JOIN INVENTORY AS INV
ON R.INVENTORY_ID = INV.INVENTORY_ID LEFT JOIN FILM AS F
ON INV.FILM_ID = F.FILM_ID
GROUP BY INV.FILM_ID
ORDER BY COUNT_OF_MOVIES DESC;

-- REVENUE PER FILM (TOP 10 GROSSERS)

SELECT F.TITLE,SUM(P.AMOUNT) AS FILM_GROSSING
FROM PAYMENT P LEFT JOIN RENTAL R
ON P.RENTAL_ID = R.RENTAL_ID LEFT JOIN INVENTORY AS INV
ON R.INVENTORY_ID = INV.INVENTORY_ID LEFT JOIN FILM AS F
ON INV.FILM_ID = F.FILM_ID
GROUP BY F.TITLE
ORDER BY FILM_GROSSING DESC
LIMIT 10;

-- Most Spending Customer so that we can send him/her rewards or debate points

SELECT *
FROM CUSTOMER
WHERE CUSTOMER_ID IN (SELECT X.CUSTOMER_ID
FROM (SELECT CUSTOMER_ID,SUM(AMOUNT) AS REVENUE
FROM PAYMENT
GROUP BY CUSTOMER_ID
ORDER BY REVENUE DESC
LIMIT 10) AS X);

SELECT C.CUSTOMER_ID,C.FIRST_NAME,C.LAST_NAME,C.EMAIL,SUM(P.AMOUNT) AS REVENUE
FROM PAYMENT AS P LEFT JOIN CUSTOMER AS C
ON P.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY REVENUE DESC
LIMIT 10;

-- Which Store has historically brought the most revenue?

SELECT ST.STORE_ID,SUM(P.AMOUNT) AS REVENEU_PER_STORE
FROM PAYMENT AS P LEFT JOIN STAFF AS ST
ON P.STAFF_ID = ST.STAFF_ID
GROUP BY ST.STORE_ID
ORDER BY REVENEU_PER_STORE DESC;

-- How many rentals we have for each month

SELECT EXTRACT(MONTH FROM RENTAL_DATE) AS MONTH_NUMBER,EXTRACT(YEAR FROM RENTAL_DATE) AS YEAR_NAME,COUNT(*) AS NUMBER_OF_RENTALS
FROM RENTAL
GROUP BY EXTRACT(YEAR FROM RENTAL_DATE),EXTRACT(MONTH FROM RENTAL_DATE);

-- Reward users who have rented at least 30 times (with details of customers)

SELECT R.CUSTOMER_ID,COUNT(*) AS NUMBER_OF_RENTALS,C.FIRST_NAME,C.EMAIL
FROM RENTAL AS R LEFT JOIN CUSTOMER AS C
ON R.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY R.CUSTOMER_ID
HAVING NUMBER_OF_RENTALS >= 30;

-- We need to understand the special features in our films. Could you pull a list of films which
-- include a Behind the Scenes special feature?

SELECT *
FROM FILM
WHERE SPECIAL_FEATURES LIKE "%Behind the Scenes%";

-- unique movie ratings and number of movies

SELECT RATING,COUNT(*) AS COUNT_OF_MOVIES
FROM FILM
GROUP BY RATING
ORDER BY COUNT_OF_MOVIES DESC;

-- Could you please pull a count of titles sliced by rental duration?

SELECT RENTAL_DURATION,COUNT(FILM_ID) AS NUMBER_OF_FILMS
FROM FILM
GROUP BY RENTAL_DURATION;

-- RATING, COUNT_MOVIES,LENGTH OF MOVIES AND COMPARE WITH RENTAL DURATION

SELECT RATING,COUNT(*) AS COUNT_OF_MOVIES,ROUND(AVG(LENGTH),0) AS AVERAGE_FILM_LENGTH,ROUND(AVG(RENTAL_DURATION),0) AS AVERAGE_RENTAL_DURATION,
MIN(RENTAL_DURATION),MAX(RENTAL_DURATION)
FROM FILM
GROUP BY RATING
ORDER BY COUNT_OF_MOVIES DESC;


-- I’m wondering if we charge more for a rental when the replacement cost is higher.
-- Can you help me pull a count of films, along with the average, min, and max rental rate,
-- grouped by replacement cost?

SELECT REPLACEMENT_COST,COUNT(*) AS NUMBER_OF_FILMS,AVG(RENTAL_RATE),MIN(RENTAL_RATE),MAX(RENTAL_RATE)
FROM FILM
GROUP BY REPLACEMENT_COST
ORDER BY REPLACEMENT_COST;

-- “I’d like to talk to customers that have not rented much from us to understand if there is something
-- we could be doing better. Could you pull a list of customer_ids with less than 15 rentals all-time?”

SELECT R.CUSTOMER_ID,COUNT(*) AS NUMBER_OF_RENTALS,C.FIRST_NAME,C.EMAIL
FROM RENTAL AS R LEFT JOIN CUSTOMER AS C
ON R.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY R.CUSTOMER_ID
HAVING NUMBER_OF_RENTALS <= 15;

-- CATEGORIZE MOVIES AS PER LENGTH

SELECT *,
CASE
	WHEN LENGTH < 60 THEN "SHORT MOVIE"
    WHEN LENGTH BETWEEN 60 AND 90 THEN "MEDIUM LENGTH"
    WHEN LENGTH > 90 THEN "LONG MOVIE"
    ELSE "ERROR"
END AS MOVIE_LENGTH_CATEGORY
FROM FILM;

-- CATEGORIZING MOVIES TO RECOMMEND VARIOUS AGE GROUPS AND DEMOGRAPHIC

SELECT DISTINCT TITLE,
	CASE
		WHEN RENTAL_DURATION <= 4 THEN 'RENTAL TOO SHORT'
        WHEN RENTAL_RATE >= 3.99 THEN 'TOO EXPENSIVE'
        WHEN RATING IN ('NC-17','R') THEN 'TOO ADULT'
        WHEN LENGTH NOT BETWEEN 60 AND 90 THEN 'TOO SHORT OR TOO LONG'
        WHEN DESCRIPTION LIKE '%Shark%' THEN 'NO_NO_HAS_SHARKS'
        ELSE 'GREAT_RECOMMENDATION_FOR_CHILDREN'
	END AS FIT_FOR_RECOMMENDATTION
FROM FILM;

-- “I’d like to know which store each customer goes to, and whether or
-- not they are active. Could you pull a list of first and last names of all customers, and
-- label them as either ‘store 1 active’, ‘store 1 inactive’, ‘store 2 active’, or ‘store 2 inactive’?”

SELECT CUSTOMER_ID,FIRST_NAME,LAST_NAME,
CASE
	WHEN STORE_ID = 1 AND ACTIVE = 1 THEN "store 1 active"
    WHEN STORE_ID = 1 AND ACTIVE = 0 THEN "store 1 inactive"
    WHEN STORE_ID = 2 AND ACTIVE = 1 THEN "store 2 active"
    WHEN STORE_ID = 2 AND ACTIVE = 0 THEN "store 2 inactive"
    ELSE "ERROR"
END AS STORE_AND_STATUS
FROM CUSTOMER;

-- “Can you pull for me a list of each film we have in inventory?
-- I would like to see the film’s title, description, and the store_id value
-- associated with each item, and its inventory_id. Thanks!”

SELECT INV.INVENTORY_ID,INV.STORE_ID,F.TITLE,F.DESCRIPTION
FROM INVENTORY AS INV INNER JOIN FILM AS F
ON INV.FILM_ID = F.FILM_ID;

-- Actor first_name, last_name and number of movies

SELECT A.ACTOR_ID,A.FIRST_NAME,A.LAST_NAME,COUNT(*) AS NUMBER_OF_MOVIES
FROM ACTOR AS A LEFT JOIN FILM_ACTOR AS FC
ON A.ACTOR_ID = FC.ACTOR_ID
GROUP BY A.ACTOR_ID;

-- “One of our investors is interested in the films we carry and how many actors are listed for each
-- film title. Can you pull a list of all titles, and figure out how many actors are
-- associated with each title?”

SELECT F.FILM_ID,F.TITLE,COUNT(*) AS NUMBER_OF_ACTORS
FROM FILM AS F LEFT JOIN FILM_ACTOR AS FC
ON F.FILM_ID = FC.FILM_ID
GROUP BY F.FILM_ID;

-- “Customers often ask which films their favorite actors appear in. It would be great to have a list of
-- all actors, with each title that they appear in. Could you please pull that for me?”
 
 SELECT A.ACTOR_ID,A.FIRST_NAME,A.LAST_NAME,F.TITLE
 FROM ACTOR AS A LEFT JOIN FILM_ACTOR AS FC
 ON A.ACTOR_ID = FC.ACTOR_ID LEFT JOIN FILM AS F
 ON FC.FILM_ID = F.FILM_ID;
 
 
 -- “The Manager from Store 2 is working on expanding our film collection there.
-- Could you pull a list of distinct titles and their descriptions, currently available in inventory at store 2?”

SELECT DISTINCT F.TITLE,F.DESCRIPTION
FROM FILM AS F INNER JOIN INVENTORY AS INV
ON F.FILM_ID = INV.FILM_ID
WHERE INV.STORE_ID = 2;

-- “We will be hosting a meeting with all of our staff and advisors soon. Could you pull one list of all staff
-- and advisor names, and include a column noting whether they are a staff member or advisor? Thanks!”

(SELECT FIRST_NAME,LAST_NAME,"STAFF_MEMBER" AS DESIGNATION
FROM STAFF
UNION
SELECT FIRST_NAME,LAST_NAME,"ADVISOR" AS DESIGNATION
FROM ADVISOR);

