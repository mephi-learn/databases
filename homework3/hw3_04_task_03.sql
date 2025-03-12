use svedb03;

with base as (
	select *, case when avg_price < 175 then 0 when avg_price > 300 then 2 else 1 end hotel_rate
	from (
		select c.ID_customer, h.ID_hotel, h.name hotel_name
			,datediff(check_out_date, check_in_date) nights
			,avg(datediff(check_out_date, check_in_date)) over (partition by c.ID_customer) average_stay_duration
			,count(h.ID_hotel) over(partition by c.ID_customer, h.ID_hotel) hotel_booking
			,count(h.ID_hotel) over(partition by c.ID_customer) total_bookings
			,sum(r.price) over(partition by c.ID_customer) total_spent
			,avg(r.price) over(partition by h.ID_hotel) avg_price
		from Customer c inner join Booking b on c.ID_customer = b.ID_customer
			inner join Room r on b.ID_room = r.ID_room
			inner join Hotel h on r.ID_hotel = h.ID_hotel
	) t
)
select c.ID_customer, c.name, r.hotel_rate preferred_hotel_type, hotels visited_hotels
from (
	select ID_customer, group_concat(distinct hotel_name separator ', ') hotels
	from base
	group by ID_customer
) h inner join (
	select ID_customer, hotel_rate hotel_rate_sort, case when hotel_rate = 0 then 'Дешевый' when hotel_rate = 1 then 'Средний' else 'Дорогой' end hotel_rate
	from (
		select t.ID_customer, t.hotel_rate_count, t.hotel_rate
			,rank() over (partition by t.ID_customer order by t.hotel_rate_count desc, t.hotel_rate desc) rank
		from (
			select distinct ID_customer, hotel_rate
				,count(hotel_rate) over(partition by ID_customer, hotel_rate) hotel_rate_count
			from base
		) t
	) t
	where rank = 1
) r on h.ID_customer = r.ID_customer inner join Customer c on r.ID_customer = c.ID_customer
order by hotel_rate_sort
;
