use interview;

CREATE TABLE PLAYER (
ID INT,  
FIRST VARCHAR(25),
LAST VARCHAR(25),
YEAR INT  
);

INSERT INTO PLAYER (ID, FIRST, LAST, YEAR) VALUES (1, "Santo", "Alcala", 1977);
INSERT INTO PLAYER (ID, FIRST, LAST, YEAR) VALUES (2, "Santo", "Alcala", 1978);
INSERT INTO PLAYER (ID, FIRST, LAST, YEAR) VALUES (3, "Santo", "Alcala", 1979);
INSERT INTO PLAYER (ID, FIRST, LAST, YEAR) VALUES (4, "Santo", "Alcala", 1980);
INSERT INTO PLAYER (ID, FIRST, LAST, YEAR) VALUES (5, "Santo", "Aldred", 1993);
INSERT INTO PLAYER (ID, FIRST, LAST, YEAR) VALUES (6, "Santo", "Aldred", 1994);
INSERT INTO PLAYER (ID, FIRST, LAST, YEAR) VALUES (7, "Santo", "Royal",  1994);

# 3 consectutive: 
select * from player; 
# delete from player where id = 7; this is for deleting a row 
# alter table plyaer drop year; this will drop the column 
# drop table player; -- its for delete table 

set @n_year = 2;
select 
	distinct concat(first, ",", last) as full_name
from 
	(
		select 
			*, row_number()over(partition by last order by year) as rn 
		from 
			player

    ) as temp
where rn >= @n_year;