use leetcode; 

create table tree (
	N int, P int); 
    
insert into tree 
values 
	(1,2),
	(3,2), 
    (6,8), 
    (9,8), 
    (2,5), 
    (8,5), 
    (5, NULL);
    
select * from tree; 

SELECT N, IF(P IS NULL, 'Root', IF(B.N in (SELECT P FROM tree), 'Inner', 'Leaf')) 
FROM tree AS B 
ORDER BY N; -- exists 는 사용 할 수 없다 

SELECT N, IF(P IS NULL, 'Root', IF((SELECT COUNT(*) FROM tree WHERE P=B.N)>0, 'Inner', 'Leaf')) 
FROM tree AS B 
ORDER BY N;