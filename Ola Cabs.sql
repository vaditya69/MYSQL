COPY main
FROM 'C:/Users/Adity/Desktop/Aditya/Ola Cabs/Book1(csv).csv'
DELIMITER ','
CSV HEADER
NULL 'null';

-- Data Cleaning
ALTER TABLE main 
DROP COLUMN "vehicle images";

ALTER TABLE main
RENAME COLUMN "vehical_type" TO "vehicle_type";

ALTER TABLE main
RENAME COLUMN "driver_ratings" TO "driver_rating";

ALTER TABLE main
RENAME COLUMN "canceled_rides_by_customer" TO "cancelled_rides_by_customer";

ALTER TABLE main
RENAME COLUMN "canceled_rides_by_driver" TO "cancelled_rides_by_driver";

-- UPDATING
UPDATE main
SET booking_status = 'Cancelled by Driver'
WHERE booking_status = 'Canceled by Driver';

UPDATE main
SET booking_status = 'Cancelled by Customer'
WHERE booking_status = 'Canceled by Customer';

SELECT 
*
FROM main;

-- Booking Status Breakdown
SELECT 
	booking_status,
	COUNT(*) AS total_bookings,
	SUM(booking_value) AS total_booking_value
FROM main
GROUP BY booking_status;

-- Vehical type KPIs
SELECT
	vehical_type,
	ROUND(AVG(ride_distance), 2) AS avg_ride_distance,
	ROUND(AVG(booking_value), 2) AS avg_booking_value,
	ROUND(SUM(ride_distance), 2) AS total_booking_value, 
	ROUND(SUM( CASE WHEN canceled_rides_by_customer IS NOT NULL THEN 1 ELSE 0 END), 2) AS total_cancelled_customers,
	ROUND(SUM(CASE WHEN canceled_rides_by_driver IS NOT NULL THEN 1 ELSE 0 END), 2) AS total_cancelled_driver
FROM main
GROUP BY vehical_type;

-- top 10 customers who booked the highest number of rides
SELECT
	customer_id,
	COUNT(*) AS total_number_of_rides
FROM main
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Number of rides cancelled by drivers due to personal & car-related issues.
SELECT
	COUNT(*) AS total_rides
FROM main
WHERE canceled_rides_by_driver = 'Personal & Car related issue';

-- Maximum and Minimum driver ratings by Different Vehicles
SELECT
	vehical_type,
	MAX(driver_ratings) AS max_driver_rating,
	MIN(driver_ratings) AS min_driver_rating
FROM main
GROUP BY vehical_type;

-- Breakdown of different Payment Methods
SELECT
	COALESCE(payment_method, 'Cancelled') AS payment_method,
	COUNT(*) AS total_bookings
FROM main
GROUP BY payment_method;

-- Average Customer and Driver Rating per Vehicle Type.
SELECT
	vehical_type,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating,
	ROUND(AVG(driver_ratings), 2) AS avg_driver_rating
FROM main
GROUP BY vehical_type;

-- All Incomplete Rides along with the Reason.  
SELECT
	vehical_type,
	COUNT(*) AS total_rides,
	SUM(booking_value) AS incomplete_value,
	SUM(SUM(booking_value)) OVER() AS total_booking_value 
FROM main
WHERE incomplete_rides = 'Yes'
GROUP BY vehical_type;

SELECT DISTINCT booking_status FROM main;


-- Pickup and Drop Location Analysis
-- Drop Location Rides Analysis
CREATE EXTENSION IF NOT EXISTS tablefunc;

WITH drop_location_rides AS (
    SELECT *
    FROM CROSSTAB(
        $$
        SELECT
            drop_location,
            booking_status,
            COUNT(*) AS total_bookings
        FROM main
        GROUP BY drop_location, booking_status
        ORDER BY drop_location, booking_status
        $$,
        $$
        SELECT DISTINCT booking_status
        FROM main
        ORDER BY booking_status
        $$
    ) AS ct (
        drop_location VARCHAR,
        "Success" INT,
        "Cancelled by Customer" INT,
        "Cancelled by Driver" INT,
        "Driver Not Found" INT
    )
),
drop_location_amount AS (
    SELECT *
    FROM CROSSTAB(
        $$
        SELECT
            drop_location,
            booking_status,
            SUM(booking_value) AS total_value
        FROM main
        GROUP BY drop_location, booking_status
        ORDER BY drop_location, booking_status
        $$,
        $$
        SELECT DISTINCT booking_status
        FROM main
        ORDER BY booking_status
        $$
    ) AS ct (
        drop_location VARCHAR,
        "Success" NUMERIC,
        "Cancelled by Customer" NUMERIC,
        "Cancelled by Driver" NUMERIC,
        "Driver Not Found" NUMERIC
    )
)
SELECT
    r.drop_location,
    r."Success" AS successful_rides,
    a."Success" AS successful_booking_value,
    r."Cancelled by Customer" AS customer_cancelled_rides,
    a."Cancelled by Customer" AS customer_cancelled_value,
    a."Cancelled by Driver" AS driver_cancelled_value,
    r."Cancelled by Driver" AS driver_cancelled_rides,
    r."Driver Not Found" AS driver_not_found_rides,
    a."Driver Not Found" AS driver_not_found_value
FROM drop_location_rides r
LEFT JOIN drop_location_amount a
    ON r.drop_location = a.drop_location
ORDER BY r.drop_location;

-- Pickup Location Rides and Booking Value Analysis
CREATE EXTENSION IF NOT EXISTS tablefunc;

WITH pickup_location_rides AS (
    SELECT *
    FROM CROSSTAB(
        $$
        SELECT
            pickup_location,
            booking_status,
            COUNT(*) AS total_bookings
        FROM main
        GROUP BY pickup_location, booking_status
        ORDER BY pickup_location, booking_status
        $$,
        $$
        SELECT DISTINCT booking_status
        FROM main
        ORDER BY booking_status
        $$
    ) AS ct (
        pickup_location VARCHAR,
        "Success" INT,
        "Cancelled by Customer" INT,
        "Cancelled by Driver" INT,
        "Driver Not Found" INT
    )
),
pickup_location_amount AS (
    SELECT *
    FROM CROSSTAB(
        $$
        SELECT
            pickup_location,
            booking_status,
            SUM(booking_value) AS total_value
        FROM main
        GROUP BY pickup_location, booking_status
        ORDER BY pickup_location, booking_status
        $$,
        $$
        SELECT DISTINCT booking_status
        FROM main
        ORDER BY booking_status
        $$
    ) AS ct (
        pickup_location VARCHAR,
        "Success" NUMERIC,
        "Cancelled by Customer" NUMERIC,
        "Cancelled by Driver" NUMERIC,
        "Driver Not Found" NUMERIC
    )
)
SELECT
    r.pickup_location,
    r."Success" AS successful_rides,
    a."Success" AS successful_booking_value,
    r."Cancelled by Customer" AS customer_cancelled_rides,
    a."Cancelled by Customer" AS customer_cancelled_value,
    r."Cancelled by Driver" AS driver_cancelled_rides,
    a."Cancelled by Driver" AS driver_cancelled_value,
    r."Driver Not Found" AS driver_not_found_rides,
    a."Driver Not Found" AS driver_not_found_value
FROM pickup_location_rides r
LEFT JOIN pickup_location_amount a
    ON r.pickup_location = a.pickup_location
ORDER BY r.pickup_location;

-- Bookings and Booking Amount with Booking Status Breakdown
WITH groupings AS(
SELECT
	booking_status,
	SUM(booking_value) AS bookings,
	SUM(SUM(booking_value)) OVER() AS total_bookings,
	COUNT(*) AS rides,
	SUM(COUNT(*)) OVER() AS total_rides
FROM main
GROUP BY 1
),
percentage AS(
SELECT 
	booking_status,
	bookings,
	rides,
	ROUND((bookings * 100) / total_bookings, 2) AS amount_percentage,
	ROUND((rides * 100) / total_rides, 2) AS ride_percentage
FROM groupings
)
SELECT * FROM percentage;

SELECT 
	*
FROM main;