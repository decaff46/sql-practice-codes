USE `lec.2.pract`;

CREATE TABLE emp_super (
	person		varchar(25),
	supervisor	varchar(25)
);

INSERT INTO emp_super
VALUES ('Bob', 'Alice');

INSERT INTO emp_super
VALUES ('Mary', 'Susan');

INSERT INTO emp_super
VALUES ('Alice', 'David');

INSERT INTO emp_super
VALUES ('David', 'Mary');


-- looking for bobs advisor
SELECT person,  supervisor
FROM emp_super
WHERE person LIKE "Bo%";

-- look for bob's supervisor's supervisor
SELECT B.person, A.supervisor 
FROM emp_super As B, emp_super AS A 
WHERE A.person = "Alice";  -- this is wrong
			
SELECT person, supervisor 
FROM emp_super  
WHERE person = "Alice";             


SELECT 	person, supervisor 
FROM 	emp_super 
WHERE 	person = (SELECT supervisor 
				  FROM emp_super
				  WHERE person = "Bob") ;
                                        
-- Can you find ALL the supervisors (direct and indirect) of “Bob”?
select distinct s.person, s.supervisor,t.supervisor as 'head supervisor' 
from emp_super AS s, emp_super AS t 
where LOWER(s.person) LIKE LOWER ('%Bob%') AND s.supervisor = t.person ;


select distinct s.person, s.supervisor, t.supervisor as 'head supervisor' 
from emp_super AS s, emp_super AS t 
where s.person LIKE '%Bob%' AND s.supervisor = t.person ;

                                    
/*-- stackoverflow answer
with test (person, supervisor) as
  (select 'bob', 'alice'   from dual union all
   select 'mary', 'susan'  from dual union all
   select 'alice', 'david' from dual union all
   select 'david', 'mary'  from dual
  )
  
select sys_connect_by_path(supervisor, '->') sv
from test
start with person = 'bob'
connect by person = prior supervisor; */

                                     