set search_path to boston;


/*"Annual Estimates of Resident Population Change for Incorporated Places of 50,000 or More in 2020, Ranked by Percent Change:
July 1, 2021 to July 1, 2022 (SUB-IP-EST2022-ANNCHG)"					
Source: U.S. Census Bureau, Population Division					
Release Date: May 2023
https://www.census.gov/data/tables/time-series/demo/popest/2020s-total-cities-and-towns.html
*/					


drop table if exists pop_change;
create table if not exists pop_change (
	index_ int,
	city text,
	pop2021 numeric,
	pop2022 numeric,
	change numeric,
	percent_change numeric
);

select * from pop_change
limit 10;

drop table if exists mass_popchange;
create table if not exists mass_popchange as (
select city, pop2021, pop2022, change, percent_change
from pop_change
where city like '%Massachusetts%'
order by percent_change
	);

drop table if exists us_popchange;
create table if not exists us_popchange as (
select city, pop2021, pop2022, change, percent_change
from pop_change
where pop2022 > 650000
order by percent_change
	);
	
update mass_popchange
set city = left(city, -(length(' Massachusetts') + length(' city')));

update us_popchange
set city = replace(city, ' city ', ', ');
select * from us_popchange;

update pop_change
set city = replace(city, ' city ', ', ');

select * from pop_change
limit 10;

select * from mass_popchange;


