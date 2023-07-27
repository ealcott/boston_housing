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

select date_, origin_display, destination_display, pct_of_origin_to_dest,
pct_of_dest_from_origin, (100 - pct_of_origin_to_dest) as pct_of_origin_looking_elsewhere,
(pct_of_origin_to_dest - pct_of_dest_from_origin) as in_vs_out
from migration
where origin_display = destination_display and date_ = '2022-01-01'
order by in_vs_out asc;

select date_, origin_display, destination_display, pct_of_origin_to_dest,
pct_of_dest_from_origin, (100 - pct_of_origin_to_dest) as pct_of_origin_looking_elsewhere,
(pct_of_origin_to_dest - pct_of_dest_from_origin) as in_vs_out
from migration
where date_ = '2022-01-01'
order by pct_of_origin_to_dest desc;

