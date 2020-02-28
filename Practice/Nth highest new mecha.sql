use classicmodels;

# Get the nth highest record example:
select * from products limit 1;
 
-- top 10 items by buyprice
SELECT productName, buyPrice
FROM products
GROUP BY productName
ORDER BY buyPrice DESC
limit 10;

 -- 2nd highest item by buyprice:
SELECT productName, buyPrice
FROM products
GROUP BY productName
ORDER BY buyPrice DESC
limit 1, 1;
-- or 
SELECT productName, buyPrice
FROM products p1
WHERE buyPrice < (select buyPrice from products p2 group by productName order by buyPrice DESC limit 1)
GROUP BY productName
ORDER BY buyPrice DESC
LIMIT 1;

-- 3rd LIMIT (n-1),1 
SELECT 
	productName, buyPrice
FROM products
GROUP BY productName
ORDER BY buyPrice DESC
LIMIT 2,1; 

-- or 
SELECT 
    productName, buyPrice
FROM
    products a
WHERE -- n - 1
    3 = (SELECT 
            COUNT(productCode)
        FROM
            products b
        WHERE
            b.buyPrice > a.buyPrice);

-- 4th and 5th LIMIT (n-1),1 
SELECT 
	productName, buyPrice
FROM products
GROUP BY productName
ORDER BY buyPrice DESC
LIMIT 2,2;

-- or 
SELECT 
	productName, buyPrice
FROM 
	(select productName, buyPrice, rank()over(order by buyPrice DESC) as rnk
     from products) as temp
where rnk = 4 or rnk = 5; 

-- or 
SELECT 
    productName, buyPrice
FROM
    products a
WHERE -- n - 1
    3 = (SELECT 
            COUNT(productCode)
        FROM
            products b
        WHERE
            b.buyPrice > a.buyPrice)
	or
    4 = (SELECT 
            COUNT(productCode)
        FROM
            products b
        WHERE
            b.buyPrice > a.buyPrice);