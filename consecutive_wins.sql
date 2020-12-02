-- http://nimishgarg.blogspot.com/2013/12/sql-puzzle-consecutive-wins.html
create table team_stats
(
	team_name   varchar(100),
    match_date  date,
	result      char(1)
);

insert into team_stats values ('TeamA', '1-JAN-2012'::date, 'W');
insert into team_stats values ( 'TeamA', '2-JAN-2012'::date,'W');
insert into team_stats values ( 'TeamA', '3-JAN-2012'::date,'W');
insert into team_stats values ( 'TeamB', '4-JAN-2012'::date,'W');
insert into team_stats values ( 'TeamB', '5-JAN-2012'::date,'W');
insert into team_stats values ( 'TeamB', '6-JAN-2012','W');
insert into team_stats values ( 'TeamA', '7-JAN-2012','L');
insert into team_stats values ( 'TeamA', '8-JAN-2012','W');
insert into team_stats values ( 'TeamA', '10-JAN-2012','W');

-- returns the team or teams that has/have the highest winning streak (consecutive wins) 
-- and the number of consecutive wins also.

with cte1 as (
	select 
	team_name,
--	match_date,
--	result,
	row_number() over (partition by team_name order by match_date) as rnn,
	row_number() over (partition by team_name, result order by match_date) as rnnr
	from team_stats
--	order by team_name, match_date
), cte2 as (
	select 
	team_name,
	count(*) as streak,
	rank() over (order by count(*) desc) as rnk
	from cte1
	group by team_name, (rnn - rnnr)
)
select team_name, streak from cte2 where rnk = 1;