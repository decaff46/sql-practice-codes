use classicmodels; 

CREATE TABLE category (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  title varchar(255) NOT NULL,
  parent_id int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (parent_id) REFERENCES category (id) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- root/parent node
INSERT INTO category(title,parent_id) 
VALUES('Electronics',NULL); 

-- non-parent node
INSERT INTO category(title,parent_id) 
VALUES('Laptops & PC',1);
 
INSERT INTO category(title,parent_id) 
VALUES('Laptops',2);
INSERT INTO category(title,parent_id) 
VALUES('PC',2);
 
INSERT INTO category(title,parent_id) 
VALUES('Cameras & photo',1);
INSERT INTO category(title,parent_id) 
VALUES('Camera',5);
 
INSERT INTO category(title,parent_id) 
VALUES('Phones & Accessories',1);
INSERT INTO category(title,parent_id) 
VALUES('Smartphones',7);
 
INSERT INTO category(title,parent_id) 
VALUES('Android',8);
INSERT INTO category(title,parent_id) 
VALUES('iOS',8);
INSERT INTO category(title,parent_id) 
VALUES('Other Smartphones',8);
 
INSERT INTO category(title,parent_id) 
VALUES('Batteries',7);
INSERT INTO category(title,parent_id) 
VALUES('Headsets',7);
INSERT INTO category(title,parent_id) 
VALUES('Screen Protectors',7);

-- check 
select * from category; 
 
-- alter table category drop column node_type;
-- assign type: 
/* 
alter table category 
	add type varchar(10);
alter table category rename column type to node_type; 

INSERT INTO category (node_type)(
SELECT 
    IF(parent_id IS NULL, 'Root', IF(c.id in (SELECT c2.parent_id FROM category as c2), 'Inner', 'Leaf'))
FROM 
    category as c); -- this one fails
    
update category 
set node_type = 'Root' 
where (
SELECT 
    IF(parent_id IS NULL, 'Root', IF(c.id in (SELECT c2.parent_id FROM category as c2), 'Inner', 'Leaf'))
FROM 
    category as c); 
 */
-- Finding the root node
SELECT 
	*
FROM 
	category
WHERE
	parent_id IS NULL; 

-- Finding the immediate children of a node
SELECT 
	* 
FROM 
	category
WHERE 
	parent_id = 1;

-- Finding the leaf nodes: The leaf nodes are the nodes that have no children
select * from category; 

SELECT 
	c1.* 
FROM 
	category c1 LEFT JOIN category c2 ON c1.id = c2.parent_id
WHERE 
	c2.id IS NULL ; 
    
-- Finding the LEAF nodes v2
SELECT 
	distinct c2.* 
FROM 
	category c1 JOIN category c2 on c1.id = c2.parent_id
WHERE
	c1.parent_id IS NOT NULL ;
    
-- Finidng inner nodes 
SELECT 
	distinct c1.* 
FROM 
	category c1 RIGHT JOIN category c2 on c1.id = c2.parent_id
WHERE
	c1.parent_id IS NOT NULL;
    
-- assigning type
SELECT 
	temp.* 
FROM 
	(SELECT Id, title, 
		IF(parent_id IS NULL, 'ROOT', 
			IF(c1.id IN (SELECT c2.parent_id FROM category c2) , 'INNER', "LEAF")) as node_type
	FROM category c1) as temp ;

-- Querying the whole tree: 
select * from category;
WITH RECURSIVE tree AS
(
	SELECT 
		id, title, title as path
	FROM 
		category 
	WHERE 
		parent_id IS NULL -- anchor
	UNION ALL 
    SELECT 
		c.id, c.title, concat(tr.path, ' -> ', c.title)
	FROM 
		category c INNER JOIN tree tr ON c.parent_id = tr.id -- recursive
)
SELECT * FROM tree ORDER BY path; 

-- gets the sub-tree of Phone & Accessories whose id is 7: 
WITH RECURSIVE sub_tree AS
(
	SELECT 
		id, title, title as path
	FROM 
		category 
	WHERE 
		parent_id = 7 -- anchor
	UNION ALL 
	SELECT 
		c.id, c.title, concat(sub.path, " -> ", c.title) 
	FROM 
		category c INNER JOIN sub_tree sub ON sub.id = c.parent_id
)

SELECT * FROM sub_tree ORDER BY path; 
        
-- To query a single path from bottom to top e.g., from iOS to Electronics:
select * from category; 
WITH RECURSIVE bottom_top AS
(
	SELECT 
		*, title as path 
	FROM 
		category 
	WHERE
		id = 10 -- bottom 
	UNION ALL 
    SELECT 
		c.id, c.title, c.parent_id, concat(bt.path, " -> ", c.title)
	FROM 
		bottom_top bt JOIN category c ON bt.parent_id = c.id
)
SELECT * FROM bottom_top;

-- SET @@cte_max_recursion_depth = 10000000;

-- root node is 0, each node underneath has a level that equals its parent node’s level plus 1: 

WITH RECURSIVE lvl AS
(
	SELECT 
		*, 0 lvl
	FROM 
		category
	WHERE
		parent_id IS NULL 
    UNION ALL 
	SELECT
		c.*, lvl+1
	FROM 
		category c INNER JOIN lvl ON c.parent_id = lvl.id
)
SELECT * FROM lvl ORDER by lvl; 

-- delete the Laptops & PC node and its children ( Laptops, PC):
DELETE FROM category WHERE id = 2;
select * from category; 

-- delete a non-leaf node and promote its descendants:
/* 
    First, update the parent_id of the immediate children of the node to the id of the new parent node.
    Then, delete the node.
*/
-- to delete the Smartphones node and promote its children such as Android, iOS, Other Smartphones nodes:
-- 1. update the parent_id of the immediate children of the node to the id of the new parent node.
UPDATE category 
SET parent_id = 7 -- Phone & Accessories
WHERE parent_id = 5 -- 