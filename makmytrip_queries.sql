/*1. Write a SQL query that gives the below output.
Output: Summary at segment level.
Segment			Total_user_count		User_who_booked_flight_in_april_2022
s1				3						2
s2				2						2
s3				5						1*/

with tuc as (select segment, count(*) as total_user_count
			 from user_table
			 group by 1),
	 ubf as (select segment, count(distinct user_id) as user_who_booked_flight_in_april_2022
			 from booking_table b
             inner join user_table u using(user_id)
             where line_of_business = "Flight" and booking_date between '2022-04-01' and '2022-04-30'
             group by 1
             )
select *
from tuc t1
join ubf t2 using(segment);

/*2. Write a query to identify users whose first booking was a hotel booking. */
with cte as (
		select *, rank() over(partition by user_id order by booking_date asc) as rnk
		from booking_table
)
select user_id
from cte
where rnk = 1 and line_of_business = "Hotel";

/*3. Write a query to calculate the days between first and last booking of each user.*/
select user_id, datediff(max(booking_date), min(booking_date)) as no_of_days
from booking_table
group by 1;

/*4. Write a query to count the number of flight and hotel bookings in each of the user segments for the year 2022.*/
select user_id, line_of_business, count(*) as booking_count
from booking_table
group by 1, 2
order by 1;