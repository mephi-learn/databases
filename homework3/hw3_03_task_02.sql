use svedb03;

select c.ID_customer, c.name, t.total_bookings, total_spent, count(hotel_name) unique_hotels
from (
	select distinct ID_customer, hotel_name, total_bookings, total_spent
	from (
		select c.ID_customer, h.name hotel_name
			,count(h.ID_hotel) over(partition by c.ID_customer, h.ID_hotel) hotel_booking
			,count(h.ID_hotel) over(partition by c.ID_customer) total_bookings
			,sum(r.price) over(partition by c.ID_customer) total_spent
		from Customer c inner join Booking b on c.ID_customer = b.ID_customer
			inner join Room r on b.ID_room = r.ID_room
			inner join Hotel h on r.ID_hotel = h.ID_hotel
	) t
	where total_bookings > hotel_booking
		and total_bookings > 2
		and total_spent > 500
) t inner join Customer c on t.ID_customer = c.ID_customer
group by ID_customer
;
