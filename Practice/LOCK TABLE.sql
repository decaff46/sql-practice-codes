-- lock table

use classicmodels;
/*
A lock is a flag associated with a table. MySQL allows a client session to explicitly acquire a table lock for preventing 
other sessions from accessing the same table during a specific period.

A client session can acquire or release table locks only for itself. 
And a client session cannot acquire or release table locks for other client sessions.

LOCK TABLES table_name [READ | WRITE];
or  
LOCK TABLES table_name1 [READ | WRITE], 
            table_name2 [READ | WRITE],
             ... ;

UNLOCK TABLES;		
*/

create table if not exists message(
	id int not null auto_increment,
    message varchar(100) not null, 
    primary key(id)
    );

/*
A READ lock has the following features:

    A READ lock for a table can be acquired by multiple sessions at the same time.
    In addition, other sessions can read data from the table without acquiring the lock.
    
    The session that holds the READ lock can only read data from the table, but cannot write. 
    And other sessions cannot write data to the table until the READ lock is released. 
    The write operations from another session will be put into the waiting states until the READ lock is released.
    If the session is terminated, either normally or abnormally, MySQL will release all the locks implicitly. 
    This feature is also relevant for the WRITE lock.
*/

SELECT CONNECTION_ID();
INSERT INTO message(message) 
VALUES('Hello');

select * from message;
	
LOCK TABLE messages READ;
insert into message(message)
values('hi');
select * from message;

SELECT CONNECTION_ID();
INSERT INTO message(message) 
VALUES('Bye');

SHOW PROCESSLIST;

/*
A WRITE lock has the following features:

    The only session that holds the lock of a table can read and write data from the table.
    Other sessions cannot read data from and write data to the table until the WRITE lock is released.
*/

