--Question1: movies categories that are being watched--

SELECT f.title, c.name AS category, COUNT(*) AS count
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
INNER JOIN inventory i ON i.film_id = f.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY f.title, c.name
ORDER BY category, title;


--Question2: What is the number of rental orders for each store per month?--

SELECT DATE_TRUNC('month', r.rental_date) AS rental_month, i.store_id, COUNT(*) AS count_rentals
FROM rental r
LEFT JOIN inventory i ON i.inventory_id = r.inventory_id
GROUP BY rental_month, i.store_id
ORDER BY count_rentals DESC;



--Question3: Who an d how many are top 10 paying customers ? --

WITH t1 AS (
    SELECT first_name || ' ' || last_name AS Name,
           SUM(p.amount) AS Total_Amount
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
)
SELECT Name, Total_Amount
FROM t1



--Question4: What is the running total amount paid on film rental on each month?--

WITH t1 AS (
    SELECT DATE_TRUNC('month', payment_date) AS month,
           SUM(amount) AS total_amount
    FROM payment
    GROUP BY month
)
SELECT DATE_PART('month', t1.month) AS month_number,
       SUM(t1.total_amount) OVER (ORDER BY t1.month) AS running_total
FROM t1;