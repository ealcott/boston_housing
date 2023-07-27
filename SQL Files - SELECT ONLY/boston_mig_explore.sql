set search_path to boston;

/*
Migration data from Redfin, a national real estate brokerage. 
Redfin Data Center uses data obtained from those relocating using Redfin services. 
Their data center can be found here: https://www.redfin.com/news/data-center/ 
And citation here:
"Migration Housing Market Data - Redfin." Redfin News Data Center, www.redfin.com/news/data-center/migration/. 
Accessed 6 Jun. 2023.

*/

select * from migration
limit 10;

select date_, origin, origin_display, destination_city, dest_percent_leavers
from migration
where origin_display like 'Boston, MA'
order by dest_percent_leavers desc

select distinct origin
from migration
where origin_display = 'Boston, MA'

select date_, count(destination_city)
from migration
where origin_display = 'Boston, MA'
group by date_
order by count(destination_city) desc


