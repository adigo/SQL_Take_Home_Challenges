# table name: friending # sender_id | receiver_id | sent_date | accepted_date | sender_country 
# table_name: fraud # | userid | fraud_type | 
# What percentage of fraud users sent more than 10 friend requests yesterday for each type of fraud?


select
fraud,
avg(if(cnt > 10, 1, 0)) * 100 as percentage
from (
	select
	userid,
	fraud_type as fraud,
	count(*) as cnt
	from friending, fraud
	where 
	userid = sender_id
	and sent_date = DATE_SUB(curdate(), INTERVAL 1 DAY)
	group by userid, fraud_type
)
group by fraud