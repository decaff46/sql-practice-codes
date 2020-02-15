-- JSON FILE 

use classicmodels;
/* basic
CREATE TABLE table_name (
    ...
    json_column_name JSON,
    ... 
);

JSON column cannot have a default value. In addition, a JSON column cannot be indexed directly. 
Instead, you can create an index on a generated column that contains values extracted from the JSON column. 
When you query data from the JSON column, the MySQL optimizer will look for compatible indexes on virtual columns 
that match JSON expressions.
*/

CREATE TABLE events( 
  id int auto_increment primary key, 
  event_name varchar(255), 
  visitor varchar(255), 
  properties json, 
  browser json
);
describe events;

INSERT INTO events(event_name, visitor,properties, browser) 
VALUES (
  'pageview', 
   '1',
   '{ "page": "/" }',
   '{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }'
),
('pageview', 
  '2',
  '{ "page": "/contact" }',
  '{ "name": "Firefox", "os": "Windows", "resolution": { "x": 2560, "y": 1600 } }'
),
(
  'pageview', 
  '1',
  '{ "page": "/products" }',
  '{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }'
),
(
  'purchase', 
   '3',
  '{ "amount": 200 }',
  '{ "name": "Firefox", "os": "Windows", "resolution": { "x": 1600, "y": 900 } }'
),
(
  'purchase', 
   '4',
  '{ "amount": 150 }',
  '{ "name": "Firefox", "os": "Windows", "resolution": { "x": 1280, "y": 800 } }'
),
(
  'purchase', 
  '4',
  '{ "amount": 500 }',
  '{ "name": "Chrome", "os": "Windows", "resolution": { "x": 1680, "y": 1050 } }'
);

-- pull values out of the JSON columns, you use the column path operator ( ->):
select browser from events;
-- {"os": "Mac", "name": "Safari", "resolution": {"x": 1920, "y": 1080}}

select 
	id, 
	browser -> '$.name' as browser
from 
	events;
-- "safari","firefox", ... to remove the "" must go with ->> 
select 
	browser ->> '$.name' browser
from events;

-- count by os type
select 	id, browser -> '$.os' as type from events;

select
	browser ->> '$.os' as os_type,
	count(browser) as count
from 
	events
group by 
	browser ->> '$.os';


SELECT browser->>'$.name' browser, 
      count(browser)
FROM events
GROUP BY browser->>'$.name';

-- calculate the total revenue by the visitor:
select 
	visitor, 
    sum(properties ->> '$.amount') as revenue
from 
	events
where
	 properties->>'$.amount' > 0
group by 
	visitor;