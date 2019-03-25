Use Sakila;

#1a
select first_name, last_name from actor;

#1b
select upper(concat(first_name, ' ', last_name)) as actor_name from actor;
ALTER TABLE actor
add COLUMN actor_name varchar(90) not null after last_name;
UPDATE actor set actor_name = upper(concat(first_name, ' ', last_name));
alter table actor drop COLUMN actor_name;

#2a
select actor_id, first_name, last_name from actor
	where first_name = 'joe';

#2b
select actor_id, first_name, last_name from actor where last_name like '%GEN%'; 

#2c
select last_name, first_name from actor where last_name like '%LI%';

#2d
select country_id, country from country
	where country IN ('Afghanistan', 'Bangladesh', 'China');

#4a
select last_name, count(last_name) as same_name_count from actor
	group by last_name;

#4b
select last_name, count(last_name) as more_than_2 from actor
	group by last_name having more_than_2 >= 2;
    
#4c
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';
        
#4d
UPDATE actor SET first_name =
    CASE
    WHEN first_name = 'HARPO' THEN
    'GROUCHO'
    WHEN first_name = 'GROUCHO' THEN
    'MUCHO GROUCHO'
    ELSE first_name
    END
WHERE 172 IN (actor_id);

#6a
select first_name, last_name, address.address from staff
	join address on address.address_id = staff.address_id;
select first_name, last_name, (select address from address
	where address.address_id = staff.address_id) as address
	from staff;

#6b
select first_name, last_name, sum(payment.amount) as total_payment from staff
	join payment on staff.staff_id = payment.staff_id where payment_date > '2005-08-01 00:00:00' and payment_date < '2005-09-01 00:00:00'
	group by staff.staff_id;
select first_name, last_name, (select sum(amount) from payment
	where staff.staff_id = payment.staff_id and payment_date > '2005-08-01 00:00:00' and payment_date < '2005-09-01 00:00:00') as total_payment
	from staff;
    
#6c
select title, count(actor_id) as actors_number from film
	join film_actor on film.film_id = film_actor.film_id group by film.film_id;
select title, (select count(actor_id) from film_actor where film.film_id = film_actor.film_id) as actors_number from film;

#6d
select count(*) as number_of_copies from inventory
	where film_id in (
		select film_id from film
			where title = "Hunchback Impossible" 
        );

#6e
select first_name, last_name, sum(amount) as total_payment from payment 
	join customer on payment.customer_id = customer.customer_id
    GROUP BY payment.customer_id ORDER BY last_name;
select first_name, last_name,
	(select sum(amount) from payment
		where payment.customer_id = customer.customer_id) as total_payment
from customer ORDER BY last_name;

#7a
select title from film
	where title like "K%" OR title like "Q%" and language_id IN (
		select language_id from language
			where name = "English"
    );

#7b
SELECT concat(a.first_name, ' ', a.last_name) AS actor_name
FROM actor a 
LEFT JOIN film_actor fa
ON a.actor_id = fa.actor_id
LEFT JOIN film f
ON fa.film_id = f.film_id
WHERE upper('Alone Trip') IN (f.title);
    
#7c
select email from customer
	inner join address on address.address_id = customer.address_id
    inner join city on city.city_id = address.city_id
    inner join country on country.country_id = city.country_id
		where country = "Canada";
	
#7d
SELECT title
FROM film
WHERE rating IN ('G', 'PG');

#7e
SELECT f.title,
         count(r.rental_id) AS rental_count
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY  f.title
ORDER BY  count(r.rental_id) DESC;

#7f
SELECT s.store_id,
         sum(p.amount)
FROM store s
LEFT JOIN staff sf
    ON s.store_id = sf.store_id
LEFT JOIN payment p
    ON sf.staff_id = p.staff_id
GROUP BY  s.store_id
ORDER BY  s.store_id; 

#7g
SELECT s.store_id,
         cy.city,
         co.country
FROM store s
LEFT JOIN address a
    ON s.address_id = a.address_id
LEFT JOIN city cy
    ON a.city_id = cy.city_id
LEFT JOIN country co
    ON cy.country_id = co.country_id;
    
#7h
SELECT cat.name,
         sum(pay.amount)
FROM category cat
LEFT JOIN film_category fc
    ON cat.category_id = fc.category_id
LEFT JOIN film f
    ON fc.film_id = f.film_id
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
LEFT JOIN payment pay
    ON r.rental_id = pay.rental_id
GROUP BY  cat.name
ORDER BY  sum(pay.amount) DESC limit 5;

#8a
CREATE OR REPLACE VIEW top_five_genres AS
SELECT cat.name,
         sum(pay.amount)
FROM category cat
LEFT JOIN film_category fc
    ON cat.category_id = fc.category_id
LEFT JOIN film f
    ON fc.film_id = f.film_id
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
LEFT JOIN payment pay
    ON r.rental_id = pay.rental_id
GROUP BY  cat.name
ORDER BY  sum(pay.amount) DESC limit 5;

#8b
SELECT * FROM top_five_genres;

#8c
DROP VIEW top_five_genres;