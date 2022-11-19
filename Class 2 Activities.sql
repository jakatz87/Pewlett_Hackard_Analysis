SELECT rating, COUNT(film_id) AS "Total Films"
FROM film
GROUP BY rating;

SELECT ROUND(AVG(rental_duration), 2)
FROM film;