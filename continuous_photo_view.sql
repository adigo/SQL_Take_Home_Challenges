drop table actions;

CREATE TABLE actions (
	session_id varchar(10),
	ts bigint,
	action varchar(20)
);

INSERT INTO actions VALUES ('s1', 123456789, 'ViewPhoto');
INSERT INTO actions VALUES ('s1', 123456790, 'ViewPhoto');
INSERT INTO actions VALUES ('s1', 123456791, 'ViewPhoto');
INSERT INTO actions VALUES ('s1', 123456795, 'ViewPhoto');
INSERT INTO actions VALUES ('s1', 123456796, 'ViewProduct');
INSERT INTO actions VALUES ('s1', 123456797, 'ViewPhoto');
INSERT INTO actions VALUES ('s1', 123456798, 'END');
INSERT INTO actions VALUES ('s2', 123456830, 'ViewProduct');
INSERT INTO actions VALUES ('s2', 123456831, 'ViewPhoto');
INSERT INTO actions VALUES ('s2', 123456832, 'Share');
INSERT INTO actions VALUES ('s2', 123456833, 'ViewPhoto');
INSERT INTO actions VALUES ('s2', 123456845, 'END');
INSERT INTO actions VALUES ('s3', 123456830, 'ViewPhoto');
INSERT INTO actions VALUES ('s3', 123456798, 'END');

-- What is the maximum # of consecutive photos viewed in every session?
-- s1 - 4
-- s2 - 1
-- s3 - 1
--
-- gaps-and-islands problem
with cte1 as (
	select 
	session_id,
	ts,
	action,
	row_number() over (partition by session_id order by ts) as rns,
	row_number() over (partition by session_id, action order by ts) as rnsa
	from actions
), cte2 as (
	select 
	session_id as id,
	count(*)as cnt
	from cte1
	where
	action = 'ViewPhoto'
	group by session_id, (rns - rnsa)
)
select
id,
max(cnt)
from cte2
group by 1