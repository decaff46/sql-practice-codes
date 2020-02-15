use classicmodels;

-- TRUNCATE TABLE: TRUNCATE TABLE statement allows you to delete all data in a table.
/*
 TRUNCATE TABLE statement is more efficient than the DELETE statement 
 because it drops and recreates the table instead of deleting rows one by one.
 
TRUNCATE [TABLE] table_name;

The TABLE keyword is optional. 
However, it is a good practice to use the TABLE keyword to distinguish between the TRUNCATE TABLE statement and the TRUNCATE() function.

If there is any FOREIGN KEY constraints from other tables which reference the table that you truncate, 
the TRUNCATE TABLE statement will fail.

Because a truncate operation causes an implicit commit, therefore, it cannot be rolled back.

The TRUNCATE TABLE statement resets value in the AUTO_INCREMENT  column to its start value if the table has an AUTO_INCREMENT column.

The TRUNCATE TABLE statement does not fire DELETE triggers associated with the table that is being truncated.

Unlike a DELETE statement, the number of rows affected by the TRUNCATE TABLE statement is 0, which should be interpreted as no information.
*/

CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL
)  ENGINE=INNODB;

-- insert dummy data to the books table by using the following stored procedure:

DELIMITER $$
CREATE PROCEDURE load_book_data(IN num INT(4))
BEGIN
    DECLARE counter INT(4) DEFAULT 0;
    DECLARE book_title VARCHAR(255) DEFAULT '';
 
    WHILE counter < num DO
      SET book_title = CONCAT('Book title #',counter);
      SET counter = counter + 1;
 
      INSERT INTO books(title)
      VALUES(book_title);
    END WHILE;
END$$
 
DELIMITER ;
CALL load_book_data(10000);
select * from books;
truncate books;

-- comparing drop and truncate
create table book_test like books;
insert into book_test select * from books;
select * from book_test;

drop table book_test;

