USE leetcode;

Create table If Not Exists Weather (Id int, RecordDate date, Temperature int);
Truncate table Weather;
insert into Weather (Id, RecordDate, Temperature) values ('1', '2015-01-01', '10');
insert into Weather (Id, RecordDate, Temperature) values ('2', '2015-01-02', '25');
insert into Weather (Id, RecordDate, Temperature) values ('3', '2015-01-03', '20');
insert into Weather (Id, RecordDate, Temperature) values ('4', '2015-01-04', '30');

-- find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.
SELECT 
	w2.id
FROM 
	weather as w1, weather as w2
WHERE
	w1.Temperature < w2.Temperature and w2.recorddate = date_add(w1.recorddate, interval 1 day);
    
## Answer 2
SELECT
    weather.id AS 'Id'
FROM
    weather JOIN
    weather w ON DATEDIFF(weather.recorddate, w.recorddate) = 1
        AND weather.Temperature > w.Temperature;