-- City column starts with the letter "a":
WHERE City LIKE 'a%'

-- City column ends with the letter "a":
WHERE city LIKE '%a';

-- City column contains the letter "a".
WHERE City LIKE '%a%';

-- starts with letter "a" and ends with the letter "b":
WHERE City LIKE 'a%b';

-- City column does NOT start with the letter "a".
WHERE City NOT LIKE 'a%';

-- second letter of the City is an "a".
WHERE City LIKE '_a%'; -- no comma seperation

--  first letter of the City is an "a" or a "c" or an "s":
WHERE City LIKE '[acs]%'; -- no comma seperation

-- first letter of the City starts with anything from an "a" to an "f":
WHERE City LIKE '[a-f]%';

-- first letter of the City is NOT an "a" or a "c" or an "f":
WHERE City LIKE '[^acf]%';