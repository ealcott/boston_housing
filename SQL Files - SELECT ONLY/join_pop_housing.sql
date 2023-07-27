set search_path to boston;

/*
Population data: 
U.S. Census Bureau, Resident Population in Boston-Cambridge-Newton, MA-NH (MSA) [BOSPOP], 
retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/BOSPOP, July 10, 2023.

Housing data:
"Downloadable Housing Market Data - Redfin." Redfin News Data Center, www.redfin.com/news/data-center/. 
Accessed 16 Jul. 2023.

CPI data:
U.S. Bureau of Labor Statistics.  "CPI for All Urban Consumers (CPI-U)." All Urban Consumers (Current Series) 
(Consumer Price Index - CPI," Series ID: CUURS11ASA0,CUUSS11ASA0, https://www.bls.gov/cpi/data.htm

U.S. Bureau of Labor Statistics.  "CPI for All Urban Consumers (CPI-U)." 
All Urban Consumers (Current Series) (Consumer Price Index - CPI," Series ID: CUURS11ASAH,CUUSS11ASAH, 
https://www.bls.gov/cpi/data.htm

*/


alter table housing
alter column period_begin type date using period_begin::date;

create table join_pop_housing as
select population.*, housing.*
from population
join housing on population.date_ = housing.period_begin
where housing.region like '%Boston%' and property_type = 'All Residential';

alter table join_pop_housing
add column avg_price float,
add column avg_dom float,
add column avg_mos float,
add column avg_omtw float;

update join_pop_housing as jph
set avg_price = subquery.avg_price
from (
    select year_, avg(median_sale_price) as avg_price
    from join_pop_housing
    group by year_
) as subquery
where jph.year_ = subquery.year_;

update join_pop_housing as jph
set avg_dom = subquery.dom
from (
    select year_, avg(median_dom) as dom
    from join_pop_housing
    group by year_
) as subquery
where jph.year_ = subquery.year_;

update join_pop_housing as jph
set avg_mos = subquery.mos
from (
    select year_, avg(months_of_supply) as mos
    from join_pop_housing
    group by year_
) as subquery
where jph.year_ = subquery.year_;

update join_pop_housing as jph
set avg_omtw = subquery.omtw
from (
    select year_, avg(off_market_in_two_weeks) as omtw
    from join_pop_housing
    group by year_
) as subquery
where jph.year_ = subquery.year_;

alter table join_pop_housing
add column cpi float,
add column cpi_housing float;

update join_pop_housing as jph
set cpi = subquery.annual from
(
	select year_, annual as annual
	from cpi_bos
	
) as subquery where jph.year_ = subquery.year_;

update join_pop_housing as jph
set cpi_housing = subquery.annual from
(
	select year_, annual as annual
	from cpi_bos_housing
	
) as subquery where jph.year_ = subquery.year_;