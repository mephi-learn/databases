use svedb02;

select c.car_name, c.car_class, c.average_position, c.race_count, cl.country car_country
from (
	select t.*, row_number() over(order by average_position, car_name) rank
	from (
		select name car_name, class car_class, count(name) over(partition by name) race_count, avg(position) over(partition by name) average_position
		from Cars c join Results r on c.name = r.car
	) t
) c inner join Classes cl on c.car_class = cl.class
where rank = 1
;
