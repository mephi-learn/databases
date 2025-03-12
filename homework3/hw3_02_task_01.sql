use svedb03;

select c.name customer_name, c.email customer_email, c.phone customer_phone, t.total_bookings, t.hotels, t.average_stay_duration
from (
	select t.*, group_concat(hotel_name separator ', ') hotels
	from (
		select distinct ID_customer, hotel_name, total_bookings, average_stay_duration
		from (
			select c.ID_customer, h.ID_hotel, h.name hotel_name
				,avg(datediff(check_out_date, check_in_date)) over (partition by c.ID_customer) average_stay_duration
				,count(h.ID_hotel) over(partition by c.ID_customer, h.ID_hotel) hotel_booking
				,count(h.ID_hotel) over(partition by c.ID_customer) total_bookings
			from Customer c inner join Booking b on c.ID_customer = b.ID_customer
				inner join Room r on b.ID_room = r.ID_room
				inner join Hotel h on r.ID_hotel = h.ID_hotel
		) t
		where total_bookings > hotel_booking
			and total_bookings > 2
	) t
	group by ID_customer
) t inner join Customer c on t.ID_customer = c.ID_customer
;
