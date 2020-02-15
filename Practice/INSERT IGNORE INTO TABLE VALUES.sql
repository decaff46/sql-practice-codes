-- INSERT IGNOR INTO TABLE(COLUMNS) VALUES (),(),...;
use classicmodels;

/*
When you use the INSERT statement to add multiple rows to a table and if an error occurs during the processing, 
MySQL terminates the statement and returns an error. As the result, no rows are inserted into the table.

However, if you use the INSERT IGNORE statement, the rows with invalid data that cause the error are ignored 
and the rows with valid data are inserted into the table.
*/

CREATE TABLE subscribers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(50) NOT NULL UNIQUE -- giving uniq value to email 
);

INSERT INTO subscribers(email)
VALUES('john.doe@gmail.com');

insert ignore into subscribers(email) 
VALUES('john.doe@gmail.com'), 
      ('jane.smith@ibm.com');
SHOW WARNINGS;

select * from subscribers;

	
CREATE TABLE tokens (
    s VARCHAR(6)
);
INSERT INTO tokens VALUES('abcdefg');
show warnings;
INSERT IGNORE INTO tokens VALUES('abcdefg');
select * from tokens;