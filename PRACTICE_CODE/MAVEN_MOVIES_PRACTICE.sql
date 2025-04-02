
USE MAVENMOVIES;

SELECT count(RENTAL_DATE)
FROM RENTAL;

SELECT SUM(AMOUNT) AS REVENUE
FROM PAYMENT;

SELECT ROUND(AVG(AMOUNT),2) AS AVG_RENTAL
FROM PAYMENT;

SELECT MAX(AMOUNT) AS REVENUE
FROM PAYMENT;

SELECT MIN(AMOUNT) AS REVENUE
FROM PAYMENT;

SELECT *
FROM PAYMENT
WHERE AMOUNT = 0;

SELECT RENTAL_ID,PAYMENT_ID,PAYMENT_DATE,AMOUNT
FROM PAYMENT;

SELECT PAYMENT_DATE,RENTAL_ID,PAYMENT_ID,PAYMENT_DATE,AMOUNT,CUSTOMER_ID,STAFF_ID,LAST_UPDATE
FROM PAYMENT;

SELECT * 
FROM PAYMENT
ORDER BY PAYMENT_DATE DESC
LIMIT 10;

SELECT * 
FROM PAYMENT
LIMIT 10 OFFSET 5;

SELECT (CONCAT(LEFT(FIRST_NAME,1),LOWER(SUBSTRING(FIRST_NAME,2))," ",LAST_NAME)) AS FULL_NAME, LOWER(EMAIL)
FROM CUSTOMER;

SELECT SUBSTRING(FIRST_NAME,2,2) FROM CUSTOMER;

SELECT (CONCAT(LEFT(FIRST_NAME,1),LOWER(SUBSTRING(FIRST_NAME,2))," ",LEFT(LAST_NAME,1),LOWER(SUBSTRING(LAST_NAME,2)))) AS FULL_NAME, 
LOWER(EMAIL) AS EMAIL_ID
FROM CUSTOMER;

-- CREATE A REPORT OF CUSTOMER ID 9 HAS EVER PURCHASED
SELECT *
FROM RENTAL
WHERE CUSTOMER_ID = 9;

-- CREATE A REPORT OF CUSTOMER ID 9 AND 10 HAS EVER PURCHASED
SELECT *
FROM RENTAL
WHERE CUSTOMER_ID = 9 OR CUSTOMER_ID = 10;

-- CREATE A REPORT OF CUSTOMER ID 9,10,11 HAS EVER PURCHASED

SELECT *
FROM RENTAL
WHERE CUSTOMER_ID = 9 OR CUSTOMER_ID = 10 OR CUSTOMER_ID = 11;

SELECT *
FROM RENTAL
WHERE CUSTOMER_ID IN (9,10,11);

SELECT *
FROM RENTAL
WHERE CUSTOMER_ID >= 9 AND CUSTOMER_ID <=11;

SELECT *
FROM RENTAL
WHERE CUSTOMER_ID BETWEEN 9 AND 11;

SELECT *
FROM FILM
WHERE SPECIAL_FEATURES = "Deleted Scenes";

SELECT *
FROM FILM
WHERE SPECIAL_FEATURES LIKE "%Deleted Scenes%";

-- 1. % - stands for 0 or more characters
-- 2. _ (underscore) - stands for 1 and only 1 character

-- Examples
-- LIKE “a%” - any length string starting with “a”
-- LIKE “%a” - anything length string with ends with “a”
-- LIKE “%em%” - any string with “em” in between, will match “em” also
-- LIKE “a_” - Any string with length 2 and starting from “a”
-- LIKE “a_%” - A string with starts from “a” and at least is 2 character long

SELECT *
FROM FILM
WHERE RATING LIKE "P%";

SELECT *
FROM ADDRESS
WHERE ADDRESS2 IS NULL OR TRIM(ADDRESS2) = "";
