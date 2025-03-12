use svedb01;

select v.maker, v.model
from Motorcycle m join Vehicle v on m.model = v.model
where 1 = 1
	and horsepower > 150
	and price < 20000
	and m.`type` = 'Sport'
order by horsepower desc
;
