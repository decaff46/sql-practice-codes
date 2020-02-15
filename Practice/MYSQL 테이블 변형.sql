/*
DROP TABLE  = TRUNCATE TABLE 
DELETE FROM TABLE WHERE condition --> this delete rows

CREATE TABLE

UPDATE TABLE [LOW PRIORITY | IGNORE] TABLE SET *** = ***, ***= *** WHERE condition; 
    The LOW_PRIORITY modifier instructs the UPDATE statement to delay the update until there is no connection reading data from the table. The LOW_PRIORITY takes effect for the storage engines that use table-level locking only such as MyISAM, MERGE, and MEMORY.
    The IGNORE modifier enables the UPDATE statement to continue updating rows even if errors occurred. The rows that cause errors such as duplicate-key conflicts are not updated.


ALTER TABLE *** ADD/MODIFY/CHANGE (orig-col name new-col name)/ DROP col-name [first | after col-name] 
ALTER TABLE RENAME == this is for changing tabble name
*/