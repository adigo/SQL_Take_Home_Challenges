CREATE TABLE query_three (
	user_id int,
	date 	date
);

COPY query_three
FROM 'D:\myDownloads\query_three.csv'
DELIMITER ','
CSV HEADER;