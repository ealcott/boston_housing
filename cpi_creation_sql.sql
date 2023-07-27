set search_path to boston;

/*
U.S. Bureau of Labor Statistics.  "CPI for All Urban Consumers (CPI-U)." All Urban Consumers (Current Series) 
(Consumer Price Index - CPI," 
Series ID: CUURS11ASA0,CUUSS11ASA0, https://www.bls.gov/cpi/data.htm

U.S. Bureau of Labor Statistics.  "CPI for All Urban Consumers (CPI-U)." All Urban Consumers (Current Series) 
(Consumer Price Index - CPI," Series ID: CUURS11ASAH,CUUSS11ASAH, https://www.bls.gov/cpi/data.htm
*/


drop table if exists cpi_bos;
create table if not exists cpi_bos (
	year_ int,
	jan float, 
	feb float,
	mar float,
	apr float,
	may float,
	jun float,
	jul float,
	aug float,
	sep float,
	oct float,
	nov float,
	dec_ float,
	annual float,
	half1 float,
	half2 float
);

drop table if exists cpi_city_avg;
create table if not exists cpi_city_avg (
	year_ int,
	jan float, 
	feb float,
	mar float,
	apr float,
	may float,
	jun float,
	jul float,
	aug float,
	sep float,
	oct float,
	nov float,
	dec_ float,
	annual float,
	half1 float,
	half2 float
);

drop table if exists cpi_bos_housing;
create table if not exists cpi_bos_housing (
	year_ int,
	jan float, 
	feb float,
	mar float,
	apr float,
	may float,
	jun float,
	jul float,
	aug float,
	sep float,
	oct float,
	nov float,
	dec_ float,
	annual float,
	half1 float,
	half2 float
);

select period_begin, median_sale_price from housing 
where region like '%Boston%' and property_type = 'All Residential';
alter table housing
add column year_ int;
update housing
set year_ = 
	case when period_begin like '%2023%' then 2023
	when period_begin like '%2022%' then 2022
	when period_begin like '%2021%' then 2021
	when period_begin like '%2020%' then 2020
	when period_begin like '%2019%' then 2019
	when period_begin like '%2018%' then 2018
	when period_begin like '%2017%' then 2017
	when period_begin like '%2016%' then 2016
	when period_begin like '%2015%' then 2015
	when period_begin like '%2014%' then 2014
	when period_begin like '%2013%' then 2013
	when period_begin like '%2012%' then 2012
	else null

end;

select period_begin, year_, region, median_sale_price from housing
where region like '%Boston%' and property_type = 'All Residential'
order by year_ desc;

drop table if exists avg_sale_boston;
create table if not exists avg_sale_boston as
select avg(median_sale_price) as avg_price, housing.year_
from housing
where region like '%Boston%' and property_type = 'All Residential'
group by year_
order by year_ desc
	;
drop table if exists sale_cpi_join;
create table if not exists sale_cpi_join as
select avg_sale_boston.avg_price,
cpi_bos.*
from avg_sale_boston
right join cpi_bos on avg_sale_boston.year_ = cpi_bos.year_;

alter table sale_cpi_join
add column housing_annual float;

update sale_cpi_join
set housing_annual = cpi_bos_housing.annual
from cpi_bos_housing
where sale_cpi_join.year_ = cpi_bos_housing.year_;

select * from sale_cpi_join
order by year_ desc;