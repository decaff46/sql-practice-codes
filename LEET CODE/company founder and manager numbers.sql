use leetcode; 

create table company(
	company_code varchar(10), 
    founder varchar(30)
);

insert into company values
('c1', 'monica'), ('c2', 'samanta');

create table lm (
	lm_code varchar(10), 
    company_code varchar(10)
); 
insert into lm values 
('lm1', 'c1'), ('lm2', 'c2'); 

create table sm ( 
	sm_code varchar(10), 
    lm_code varchar(10), 
    company_code varchar(10)
); 

insert into sm values
('sm1', 'lm1','c1'),('sm2', 'lm1','c1'),('sm3', 'lm2','c2'); 

create table m (
	m_code varchar(10), 
    sm_code varchar(10), 
    lm_code varchar(10), 
    company_code varchar(10)
); 

insert into m values 
('m1', 'sm1', 'lm1','c1'), ('m2', 'sm3', 'lm2','c2'), ('m3', 'sm3', 'lm2','c2'); 

create table e ( 
	emp_code  varchar(10), 
   	m_code varchar(10), 
    sm_code varchar(10), 
    lm_code varchar(10), 
    company_code varchar(10)
); 

insert into e values 
('e1', 'm1', 'sm1', 'lm1','c1'), 
('e2', 'm1', 'sm1', 'lm1','c1'), 
('e3', 'm2', 'sm3', 'lm2','c2'), 
('e4', 'm3', 'sm3', 'lm2','c2');


select * from company; 
select * from lm; 
select * from sm; 
select * from m; 
select * from e; 

select 
	c.company_code, 
    c.founder, 
    count(distinct lm.lm_code), 
    count(distinct sm.sm_code), 
    count(distinct m.m_code), 
    count(distinct e.emp_code)
from 
	company as c 
		inner join lm using (company_code)
		inner join sm using (company_code)
        inner join m using (company_code)
        inner join e using (company_code)
group by c.company_code, c.founder
order by c.company_code; 

-- or 
select 
	c.company_code, 
    c.founder, 
    count(distinct e.lm_code), 
    count(distinct e.sm_code), 
    count(distinct e.m_code), 
    count(distinct e.emp_code)
from 
	company as c 
		inner join e using (company_code)
group by c.company_code, c.founder
order by c.company_code; 

