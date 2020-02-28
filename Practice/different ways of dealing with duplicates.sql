use classicmodels; 

## dealing with duplicates: 
drop table if exists contacts2;
CREATE TABLE contacts2 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL
);
INSERT INTO contacts2 (first_name,last_name,email) 
VALUES ('Carine ','Schmitt','carine.schmitt@verizon.net'),
       ('Jean','King','jean.king@me.com'),
       ('Peter','Ferguson','peter.ferguson@google.com'),
       ('Janine ','Labrune','janine.labrune@aol.com'),
       ('Jonas ','Bergulfsen','jonas.bergulfsen@mac.com'),
       ('Janine ','Labrune','janine.labrune@aol.com'),
       ('Susan','Nelson','susan.nelson@comcast.net'),
       ('Zbyszek ','Piestrzeniewicz','zbyszek.piestrzeniewicz@att.net'),
       ('Roland','Keitel','roland.keitel@yahoo.com'),
       ('Julie','Murphy','julie.murphy@yahoo.com'),
       ('Kwai','Lee','kwai.lee@google.com'),
       ('Jean','King','jean.king@me.com'),
       ('Susan','Nelson','susan.nelson@comcast.net'),
       ('Roland','Keitel','roland.keitel@yahoo.com');
select * from contacts;

--  find rows that have duplicate emails :
select 
	* , count(*) as num
from 
	contacts
group by 
	email
having count(*) > 1;

-- find duplicate rows based on multiple columns instead of one:
select 
	first_name, count(first_name), 
    last_name, count(last_name),
    email, count(email)
from 
	contacts
group by 
	first_name, last_name, email 
having count(first_name) >1 and count(last_name) >1 and count(email) > 1;

-- find the ones are not duplicated:
select 
	* 
from 
	contacts
group by
	email
having count(*) = 1;

-- or
select * from contacts where email not in 
	(select email from contacts group by email having count(*) >1); 

-- delete duplicate rows and keep the lowest id:
SET SQL_SAFE_UPDATES = 0;
DELETE c1 
FROM contacts c1
	INNER JOIN contacts c2 
WHERE
    c1.id > c2.id AND 
    c1.email = c2.email;
    
select *,count(*)
from contacts 
group by email;

rename table contacts to contacts_deduped;
select * from contacts_deduped;
-- alter table contacts rename contacts_dedup; 

create table conctact_duplicated like contacts2;

-- checking if the table is created well 
select * from conctact_duplicated;

-- migrating the information with no duplicates
INSERT INTO conctact_duplicated
SELECT * 
FROM contacts2 
GROUP BY email;

-- check if the result is the same:
select * from contacts_deduped;

-- comparing table:
SELECT
	*
FROM 
	(
		select * from conctact_duplicated
        UNION 
        select * from contacts_deduped
	) as temp
GROUP BY email
HAVING COUNT(*) = 1;

-- seems about right now delete!
#DROP TABLE contacts;
 
ALTER TABLE conctact_duplicated
RENAME TO contacts;

-- remove duplicates with row_number(): 
select * from contacts2; -- make sure there are duplicates!


create table contacts3 like contacts2;
select * from contacts3; -- make sure its empty
# insert into contacts3

insert into contacts3
select 
	id,first_name, last_name, email
from 
	(select *, row_number()over(partition by email order by id DESC) as rn
	 from contacts2) as temp
where 
	rn = 1;
select * from contacts3;