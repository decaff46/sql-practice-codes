use leetcode;
drop table test;

create table hackers
(
	hacker_id int, 
    name varchar(20)
); 

insert into hackers values	
(4071, 'Rose'), (4086, 'Ange'), (26071, 'Frank'), 
(49438, 'Patrik'), (74842, 'Lisa'), (80305, 'Kimy'), 
(84072, 'Bonnie'), (87868, 'Michael'), (92118, 'Tod');

create table submission( 
	submission_id int, 
    hacker_id int, 
    challenge_id int, 
    score int
); 

insert into submission values
(67194, 74842, 63132, 76),
(64479, 74842, 19797, 98), 
(40742, 26071, 49593, 20), 
(17513, 4806, 19797, 32),
(69846, 80305, 19797, 19), 
(41002, 26071, 89343, 36), 
(31093, 26071, 19797, 2), 
(81614, 84072, 49593, 100), 
(44829, 26071, 89343, 17), 
(75147, 80305, 49593, 48), 
(14115, 4806, 49593, 76), 
(6943, 4071, 19797, 95),
(12855, 4806, 25917, 13), 
(73343, 80305, 49593, 42),
(84264, 84072, 63132, 0),
(9951, 4071, 49593, 43),
(26363, 26071, 19797, 29),
(10063, 4071, 49593, 96); 


SELECT 
    h.hacker_id, h.name, sum(s.score) as total
FROM 
    Hackers as h join 
        submission as s using (hacker_id)
GROUP BY 
    h.hacker_id, h.name 
HAVING 
    total <> 0 
    OR 
    total IN
    (
        select sum(score) as scr_same
        from submission
        group by hacker_id
        having 
            count(scr_same) = 1
    ) 
    
ORDER BY 
    total DESC, hacker_id ASC; 
    
    