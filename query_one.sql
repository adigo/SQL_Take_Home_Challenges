CREATE TABLE query_one (
	user_id int,
	page varchar(50),
	unix_timestamp bigint
);

COPY query_one
FROM 'C:\sampledb\query_one.csv' 
DELIMITER ',' 
CSV HEADER;

select * from query_one;

select 
user_id,
diff
from (
	select 
	user_id,
	unix_timestamp - LAG(unix_timestamp) over (partition by user_id order by unix_timestamp) as diff,
	row_number() over (partition by user_id order by unix_timestamp desc) as rownum
	from query_one
) a
where
rownum = 1;