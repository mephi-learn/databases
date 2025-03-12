use svedb02;

select car_name, car_class, average_position, race_count
from (
	select car_name, car_class, average_position, row_number() over (partition by t.car_class order by average_position) position, race_count
	from (
		select name car_name, class car_class, avg(position) average_position, count(name) race_count
		from Cars c join Results r on c.name = r.car
		group by name, class
	) t
) t
where position = 1
order by average_position
;
