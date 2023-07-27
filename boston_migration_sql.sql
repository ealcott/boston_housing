create schema if not exists boston;

set search_path to boston;

/*
Migration data from Redfin, a national real estate brokerage. 
Redfin Data Center uses data obtained from those relocating using Redfin services. 
Their data center can be found here: https://www.redfin.com/news/data-center/ 
And citation here:
"Migration Housing Market Data - Redfin." Redfin News Data Center, www.redfin.com/news/data-center/migration/. 
Accessed 6 Jun. 2023.
*/
drop table if exists migration;
create table if not exists migration (
	date_ date,
	origin text,
	origin_display text,
	origin_state text,
	destination_city text,
	destination_display text,
	destination_state text,
	pct_of_origin_to_dest text, /*convert to decimal after manual input*/
	pct_of_dest_from_origin text,
	dest_percent_leavers text,
	origin_percent_dest_incomers text
);

select * from migration
limit 10;

select count(*) from migration;

update migration
set pct_of_origin_to_dest = replace(pct_of_origin_to_dest, '%', ''),
pct_of_dest_from_origin = replace(pct_of_dest_from_origin, '%', ''),
dest_percent_leavers = replace(dest_percent_leavers, '%', ''),
origin_percent_dest_incomers = replace(origin_percent_dest_incomers, '%', '');

alter table migration
alter column pct_of_origin_to_dest type numeric using (pct_of_origin_to_dest::numeric),
alter column pct_of_dest_from_origin type numeric using (pct_of_dest_from_origin::numeric);

update migration
set dest_percent_leavers = case when
	dest_percent_leavers = '' then null
	else dest_percent_leavers::numeric
	end,
	origin_percent_dest_incomers = case when
	origin_percent_dest_incomers = '' then null
	else origin_percent_dest_incomers::numeric
end;

alter table migration
alter column dest_percent_leavers type numeric using (dest_percent_leavers::numeric),
alter column origin_percent_dest_incomers type numeric using
(origin_percent_dest_incomers::numeric);

update migration
set pct_of_origin_to_dest = round(pct_of_origin_to_dest/100, 3),
pct_of_dest_from_origin = round(pct_of_dest_from_origin/100, 3),
dest_percent_leavers = round(dest_percent_leavers/100, 3),
origin_percent_dest_incomers = round(origin_percent_dest_incomers/100, 3);

alter table migration add column city text;
update migration
set city = left(destination_display, -4);

create table migration_boston as (
select * from migration
where origin_display = 'Boston, MA'
order by date_ desc, dest_percent_leavers DESC nulls last
	);
select * from migration_boston
where destination_display = 'Boston, MA'
order by date_ desc;