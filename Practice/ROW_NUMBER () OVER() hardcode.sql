use classicmodels;

# hard code row_number()
SET @row_number = 0; 
SELECT 
    (@row_number:=@row_number + 1) AS rn, 
    firstName, 
    lastName
FROM
    employees
ORDER BY firstName, lastName    
LIMIT 5;

-- or
SELECT 
    temp.rn, 
    firstName, 
    lastName
FROM
    (select *, @row_number := @row_number +1 as rn
    from employees) as temp
where rn < 5;

--  add a row number, and the row number is reset whenever the customer number changes:
set @rn = 0;

## row_number() over(partition by) hard code: 
select 
	@rn := (case 
				when @customer_num = customerNumber then @rn := @rn +1
			else @rn:= 1
            end) as rn_num, 
    @customer_num := customerNumber as customerNumber, 
    paymentDate, 
    amount
from 
	payments
order by customerNumber; 

-- check if the same 
select 
	row_number()over(partition by customerNumber order by customerNumber) as rn, 
    customerNumber, 
    paymentDate, 
    amount
from 
	payments;