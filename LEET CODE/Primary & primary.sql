use leetcode; 

SET @a := 1; 
SET @b := 1;

SELECT GROUP_CONCAT(prime SEPARATOR '&') 
FROM
    (SELECT @a := @a + 1 AS prime 
     FROM
        information_schema.tables as t1, -- needs two tables because it has less than 1000
        information_schema.tables as t2) as primes
WHERE 
    prime <= 1000 AND 
    NOT EXISTS(
        SELECT denominator FROM
        (SELECT @b := @b + 1 AS denominator 
         FROM
            information_schema.tables as t3,
            information_schema.tables as t4) as denominators
         WHERE denominator <=1000 AND 
            MOD(prime, denominator) = 0 AND 
            prime <> denominator AND
            denominator > 1);