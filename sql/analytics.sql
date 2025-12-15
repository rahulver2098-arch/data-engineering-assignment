-- Create staging tables
CREATE TABLE stg_users (
    user_id INTEGER,
    name TEXT,
    email TEXT,
    city TEXT,
    signup_date DATE,
    account_age_days INTEGER,
    ltv REAL
);

CREATE TABLE stg_orders (
    order_id INTEGER,
    user_id INTEGER,
    product TEXT,
    price REAL,
    order_date DATE,
    status TEXT,
    order_month TEXT
);


--Creating dim_dim_users table

CREATE TABLE dim_users AS
SELECT
    user_id,
    TRIM(name) AS name,
    LOWER(TRIM(email)) AS email,
    TRIM(city) AS city,
    DATE(signup_date) AS signup_date
FROM stg_users
WHERE user_id IS NOT NULL;

--Creating dim_date table

CREATE TABLE dim_date AS
SELECT DISTINCT
    DATE(order_date) AS date,
    STRFTIME('%Y%m%d', order_date) AS date_key,
    CAST(STRFTIME('%m', order_date) AS INTEGER) AS month,
    CAST(STRFTIME('%Y', order_date) AS INTEGER) AS year,
    STRFTIME('%w', order_date) AS day_of_week
FROM stg_orders
WHERE order_date IS NOT NULL;



--Creating the Fact TABLE

CREATE TABLE fact_orders AS
SELECT
    o.order_id,
    o.user_id,
    o.price,
    o.status,
    DATE(o.order_date) AS order_date,
    STRFTIME('%Y-%m', o.order_date) AS order_month
FROM stg_orders o
WHERE
    o.price > 0
    AND o.user_id IS NOT NULL
    AND o.order_date IS NOT NULL;
    
    
    
SELECT COUNT(*) FROM dim_users;
SELECT COUNT(*) FROM dim_date;
SELECT COUNT(*) FROM fact_orders;

SELECT * FROM fact_orders LIMIT 10;




--Query Writing



-- Top 10 users and their total_spends

SELECT
    user_id,
    SUM(price) AS total_spent
FROM stg_orders
WHERE price > 0
  AND status = 'completed'
GROUP BY user_id
ORDER BY total_spent DESC
LIMIT 10;


--Monthly revenue trends (last 12 months)

SELECT
    strftime('%Y-%m', order_date) AS month, --strftime extracts year-month from a date in SQLite.
    SUM(price) AS total_revenue
FROM stg_orders
WHERE price > 0
  AND status = 'completed'
  AND order_date IS NOT NULL
GROUP BY month
ORDER BY month DESC
LIMIT 12;


--Cities with highest failed orders

SELECT
    u.city,
    COUNT(*) AS failed_count
FROM stg_orders o
JOIN stg_users u
    ON o.user_id = u.user_id
WHERE o.status = 'failed'
GROUP BY u.city
ORDER BY failed_count DESC;

--Users with Repeat Purchases

SELECT
    user_id,
    COUNT(order_id) AS order_count
FROM stg_orders
WHERE status = 'completed'
GROUP BY user_id
HAVING COUNT(order_id) > 1
ORDER BY order_count DESC;
