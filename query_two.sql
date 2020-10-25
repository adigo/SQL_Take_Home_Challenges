CREATE TABLE data_mobile (
	user_id int,
	page varchar(50)
);

CREATE TABLE data_web (
	user_id int,
	page varchar(50)
);

COPY data_mobile
FROM 'D:\weChat\WeChat Files\wxid_0svhdk7ar8sl22\FileStorage\File\2020-10\query_two_mobile.csv' 
DELIMITER ',' 
CSV HEADER;

COPY data_web
FROM 'D:\weChat\WeChat Files\wxid_0svhdk7ar8sl22\FileStorage\File\2020-10\query_two_web.csv' 
DELIMITER ',' 
CSV HEADER;


with inBoth as (
	select 
	mo.user_id
	from data_mobile mo, data_web we
	where
	mo.user_id = we.user_id 
), inMobileOnly as (
	select
	mo.user_id
	from data_mobile mo
	left join data_web we on 
	mo.user_id = we.user_id 
	where
	we.user_id is null
), inWebOnly as (
	select we.user_id
	from data_web we
	left join data_mobile mo on
	we.user_id = mo.user_id
	where
	mo.user_id is null
)
select 
100 * (select count(*) from inMobileOnly) / ((select count(*) from inBoth) + (select count(*) from inMobileOnly) + (select count(*) from inWebOnly)) as mobile_only,
100 * (select count(*) from inWebOnly) / ((select count(*) from inBoth) + (select count(*) from inMobileOnly) + (select count(*) from inWebOnly)) as web_only,
100 * (select count(*) from inBoth) / ((select count(*) from inBoth) + (select count(*) from inMobileOnly) + (select count(*) from inWebOnly)) as both
;