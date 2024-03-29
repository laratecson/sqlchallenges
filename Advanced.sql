select *
from public.rental

select *
from public.customer

select 
count(rental_id) as rent
, a.customer_id
, first_name || ' ' || last_name as name
, d.film_id
, d.title
from rental a
left join customer b on a.customer_id = b.customer_id
left join inventory c on a.inventory_id = c.inventory_id
left join film d on c.film_id = d.film_id
where first_name = 'GEORGE'
and last_name = 'LINTON'
group by a.customer_id
, name
, d.film_id
, d.title
having count(rental_id) > 1

select 
film_id
, title
, length
from film
where length > (select avg(length) from film)

select *
from public.inventory

select *
from film
where film_id in (select 
film_id
from inventory
where store_id = '2'
group by film_id
having count(film_id)>3)



select 
count (a.film_id) as no_film
, a.store_id
, b.title
from inventory a 
left join film b on a.film_id = b.film_id
where store_id = '2'
group by a.film_id
, store_id
, title
having count(a.film_id)> 3

select
first_name
, last_name
from customer
where customer_id in (select customer_id
from payment
where payment_date 
between '2020-01-25 00:00:00' and '2020-01-26 00:00:00')

select
first_name
, last_name
from customer
where customer_id in (select customer_id
from payment
where date(payment_date) = '2020-01-25')

select
first_name
, email
from customer
where customer_id in 
(select customer_id from payment
group by customer_id
 having sum(amount)>30)
 
 select
first_name
, last_name
, district
from customer a
left join address b on a.address_id = b.address_id
where a.customer_id in 
(select customer_id from payment
group by customer_id
 having sum(amount)>100)
 and district = 'California'
 
select round(avg(tot_amt),2)
from
(select
 date(payment_date) as pay_date
, round(sum(amount),2) as tot_amt
from payment
group by date(payment_date)
order by pay_date) as alias

select *
, ((select (max(amount)) from payment)-amount) as difference
from payment


select *
from payment table_1
where amount in (select max(amount)
				 from payment table_2
				 where table_1.customer_id = table_2.customer_id)


select title
, film_id
, replacement_cost
, rating
from film f1
where replacement_cost in (select min(replacement_cost)
						  from film f2
						  where f1.rating = f2.rating)
						  

select title
, film_id
, length
, rating
from film f1
where length in (select max(length)
						  from film f2
						  where f1.rating = f2.rating)



select
*
, (select sum(amount) from payment t2 where t1.customer_id=t2.customer_id)
, (select count(*) from payment t3 where t1.customer_id = t3.customer_id)
from payment t1
order by customer_id asc

select
film_id
, title
, replacement_cost
, rating
, (select round(avg(replacement_cost),2) 
   from film t2 
   where t1.rating = t2.rating) as ave_cost
from film t1
where replacement_cost in (select max(replacement_cost)
						 from film t3
						  where t1.rating = t3.rating)
						  

select
t2.first_name
, t1.amount
, t1.payment_id
from payment t1
left join customer t2 on t1.customer_id = t2.customer_id
where amount in (select max(amount)
				from payment t3
				 join customer t4 on t3.customer_id = t4.customer_id
				 where t2.customer_id = t4.customer_id
				)
						