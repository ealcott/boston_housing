set search_path to boston;

/*
Data from Redfin, a national real estate brokerage. F
ind their Data Center here: Downloadable Housing Market Data - Redfin
Citation:
[1] "Downloadable Housing Market Data - Redfin." Redfin News Data Center, www.redfin.com/news/data-center/. 
Accessed 16 Jul. 2023.

*/

drop table if exists housing_city;
create table if not exists housing_city (
period_begin                       text,
period_end                         text,
period_duration                     text,
region_type                        text,
region_type_id                      text,
table_id                            text,
is_seasonally_adjusted             text,
region                             text,
city                              text,
state_                             text,
state_code                         text,
property_type                      text,
property_type_id                    text,
median_sale_price                 text,
median_sale_price_mom             text,
median_sale_price_yoy             text,
median_list_price                 text,
median_list_price_mom             text,
median_list_price_yoy             text,
median_ppsf                       text,
median_ppsf_mom                   text,
median_ppsf_yoy                   text,
median_list_ppsf                  text,
median_list_ppsf_mom              text,
median_list_ppsf_yoy              text,
homes_sold                        text,
homes_sold_mom                    text,
homes_sold_yoy                    text,
pending_sales                     text,
pending_sales_mom                 text,
pending_sales_yoy                 text,
new_listings                      text,
new_listings_mom                  text,
new_listings_yoy                  text,
inventory                         text,
inventory_mom                     text,
inventory_yoy                     text,
months_of_supply                  text,
months_of_supply_mom              text,
months_of_supply_yoy              text,
median_dom                        text,
median_dom_mom                    text,
median_dom_yoy                    text,
avg_sale_to_list                  text,
avg_sale_to_list_mom              text,
avg_sale_to_list_yoy              text,
sold_above_list                   text,
sold_above_list_mom               text,
sold_above_list_yoy               text,
price_drops                       text,
price_drops_mom                   text,
price_drops_yoy                   text,
off_market_in_two_weeks           text,
off_market_in_two_weeks_mom       text,
off_market_in_two_weeks_yoy       text,
parent_metro_region                text,
parent_metro_region_metro_code      text,
last_updated                       text
);

drop table if exists city_housing_small;
create table if not exists city_housing_small as (
select * from housing_city
where region like 'Boston, MA'
or region like 'New York, NY'
or region like 'Philadelphia, PA'
or region like 'Chicago, IL'
or region like 'San Jose, CA'
or region like 'Los Angeles, CA'
or region like 'San Francisco, CA'
or region like 'El Paso, TX'
or region like 'Indianapolis, IN'
or region like 'Denver, CO'
or region like 'Austin, TX'
or region like 'Columbus, OH'
or region like 'Houston, TX'
or region like 'San Diego, CA'
or region like 'Washington, DC'
or region like 'Dallas, TX'
or region like 'Las Vegas, NV'
or region like 'Nashville, TN'
or region like 'Oklahoma City, OK'
or region like 'Phoenix, AZ'
or region like 'San Antonio, TX'
or region like 'Jacksonville, FL'
or region like 'Charlotte, NC'
or region like 'Fort Worth, TX'
or region like 'Seattle, WA'
or region like 'Portland, ME'
or region like 'Miami, FL'
or region like 'Hartford, CT'
or region like 'Orlando, FL'
or region like 'Cape Coral, FL'
or region like 'Tampa, FL'
	);

alter table city_housing_small
alter column period_duration type int using nullif(period_duration, '')::int,
alter column region_type_id type int using nullif(region_type_id, '')::int,
alter column table_id type int using nullif(table_id, '')::int,
alter column property_type_id type int using nullif(property_type_id, '')::int,
alter column median_sale_price type numeric using nullif(median_sale_price, '')::numeric,
alter column median_list_price type numeric using nullif(median_list_price, '')::numeric,
alter column median_ppsf type numeric using nullif(median_ppsf, '')::numeric,
alter column median_list_ppsf type numeric using nullif(median_list_ppsf, '')::numeric,
alter column homes_sold type numeric using nullif(homes_sold, '')::numeric,
alter column pending_sales type numeric using nullif(pending_sales, '')::numeric,
alter column new_listings type numeric using nullif(new_listings, '')::numeric,
alter column inventory type numeric using nullif(inventory, '')::numeric,
alter column months_of_supply type numeric using nullif(months_of_supply, '')::numeric,
alter column median_dom type numeric using nullif(median_dom, '')::numeric,
alter column avg_sale_to_list type numeric using nullif(avg_sale_to_list, '')::numeric,
alter column sold_above_list type numeric using nullif(sold_above_list, '')::numeric,
alter column price_drops type numeric using nullif(price_drops, '')::numeric,
alter column off_market_in_two_weeks type numeric using nullif(off_market_in_two_weeks, '')::numeric,
alter column parent_metro_region_metro_code type int using nullif(parent_metro_region_metro_code, '')::int;

alter table city_housing_small
alter column new_listings_yoy type numeric using nullif(new_listings_yoy, '')::numeric;

