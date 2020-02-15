use leetcode;

create table triagle( 
	A int, 
    B int, 
    C int);
    
insert into triagle values 
(20, 20, 23), 
(20, 20, 20),
(20, 21, 22), 
(13, 14, 30); 

select * from triagle; 
alter table triagle rename to triangle; 

select * from triangle; 

SELECT
  CASE 
    WHEN A + B <= C or A + C <= B or B + C <= A THEN 'Not A Triangle'
    WHEN A = B and B = C THEN 'Equilateral'
    WHEN A = B or A = C or B = C THEN 'Isosceles'
    WHEN A <> B and B <> C THEN 'Scalene'
  END 
FROM TRIANGLE;

/*
SELECT 
	CASE WHEN A + B <= C or A + C <= B or B + C <= A THEN 'Not A Triangle' END, 
    CASE WHEN A = B and B = C THEN 'Equilateral' END, 
    CASE WHEN A = B or A = C or B = C THEN 'Isosceles' END, 
    CASE WHEN A <> B and B <> C THEN 'Scalene' END
FROM triangle; -- 이렇게 하면 각각의 하나씩이 케이스가 되버림 !! 
*/

SELECT  
	CASE 
		WHEN A+B>C AND B+C>A AND A+C>B THEN
        CASE 
            WHEN A=B AND B=C THEN 'Equilateral'
            WHEN A=B or A=C OR B=C THEN 'Isosceles'
            ELSE 'Scalene'
        END
    ELSE 'Not A Triangle'
END 
FROM TRIANGLE ; 