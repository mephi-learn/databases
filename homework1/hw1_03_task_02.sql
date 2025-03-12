use svedb01;

select *
from (
	select v.maker, v.model, horsepower, engine_capacity, 'Car' vehicle_type
	from Vehicle v inner join Car c on v.model = c.model
	where 1 = 1
		and horsepower > 150
		and engine_capacity < 3
		and price < 35000
	union
	select v.maker, v.model, horsepower, engine_capacity, 'Motorcycle' vehicle_type
	from Vehicle v inner join Motorcycle m on v.model = m.model
	where 1 = 1
		and horsepower > 150
		and engine_capacity < 1.5
		and price < 20000
	union
	select v.maker, v.model, null horsepower, null engine_capacity, 'Bicycle' vehicle_type
	from Vehicle v inner join Bicycle b on v.model = b.model
	where 1 = 1
		and gear_count > 18
		and price < 4000
) t
order by t.horsepower desc
;
