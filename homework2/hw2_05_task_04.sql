use svedb02;

select t.car_name, t.car_class, t.average_car_position, t.average_class_position, t.race_count, cl.country car_country
from (
	select name car_name, class car_class, count(name) over(partition by name) race_count, avg(position) over(partition by name) average_car_position, avg(position) over(partition by class) average_class_position
	from Cars c join Results r on c.name = r.car
) t inner join Classes cl on t.car_class = cl.class
where t.average_car_position < t.average_class_position
;
