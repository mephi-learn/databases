use svedb02;

select c.car_name, c.car_class, c.average_position, c.race_count, cl.country car_country, c.total_races
from (
	select t.*,  rank() over (order by t.average_position) rank
	from (
		select name car_name, class car_class, count(name) over(partition by name) race_count, count(class) over(partition by class) total_races, avg(position) over(partition by name) average_position
		from Cars c join Results r on c.name = r.car
	) t
) c inner join Classes cl on c.car_class = cl.class
where rank = 1
;
