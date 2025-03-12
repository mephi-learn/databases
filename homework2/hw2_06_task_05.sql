use svedb02;

select car_name, t.car_class, c.average_position, c.race_count, c.country, t.class_race, low_position_count
from (
	select t.*, rank() over (order by low_position_count desc) rank
	from (
		select t.*, count(car_class) over(partition by car_class) low_position_count
		from (
			select class car_class, avg(position) over(partition by name) average_position, count(class) over(partition by class) class_race
			from Cars c inner join Results r on c.name = r.car
		) t
		where average_position > 3
	) t
) t inner join (
	select c.name car_name, c.class car_class, avg(position) over(partition by name) average_position, count(name) over(partition by name) race_count, cl.country
	from Cars c inner join Results r on c.name = r.car
		inner join Classes cl on c.class = cl.class
) c on t.car_class = c.car_class
where rank = 1
order by low_position_count
;
