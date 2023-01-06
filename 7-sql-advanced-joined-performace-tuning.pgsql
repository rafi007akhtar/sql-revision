-- NOTE: in many of the statements below, I am limiting only cause the # rows are too many.

/** Topic: JOINS

Left joins include unmatched rows from the left table, which is indicated in the “FROM” clause.
Syntax:
SELECT column_name(s)
FROM Table_A
LEFT JOIN Table_B ON Table_A.column_name = Table_B.column_name;

Right joins are similar to left joins, but include unmatched data from the right table -- the one that’s indicated in the JOIN clause.
Syntax:
SELECT column_name(s)
FROM Table_A
RIGHT JOIN Table_B ON Table_A.column_name = Table_B.column_name;

In some cases, you might want to include unmatched rows from both tables being joined. You can do this with a full outer join.
A common application of this is when joining two tables on a timestamp.
Syntax:
SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;

If you wanted to return unmatched rows only,
which is useful for some cases of data assessment,
you can isolate them by adding the following line to the end of the query:
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL
*/

-- Write a query to get:
-- each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
-- but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)
SELECT
a.*,
s.*
FROM accounts a
FULL OUTER JOIN sales_reps s
ON s.id = a.sales_rep_id
LIMIT 15;
-----------------------------------------

/** Topic: JOINs with comparison operator.

Here, the JOIN clause will have two operations:
- one with an = sign
- one with a comparison operator (like <, > etc.)

You should't put the second without the first.

Also, using comparison operators may produce results that are difficult to predict.

Note:
If you recall from earlier lessons on joins, the join clause is evaluated before the where clause.
Filtering in the join clause will eliminate rows before they are joined, while filtering in the WHERE clause will leave those rows in and produce some nulls.
*/

SELECT
    a.name account_name,
    a.primary_poc primary_contact,
    s.name sales_rep
FROM accounts a
LEFT JOIN sales_reps s
ON a.sales_rep_id = s.id
AND a.primary_poc < s.name
LIMIT 15;
-----------------------------------------

/** Topic: Self JOINs

These are tables that join onto themselves.
These ALWAYS need aliases to distinguish b/w left and right tables.

One of the most common use cases for self JOINs is in cases where two events occurred, one after another.
Using inequalities in conjunction with self JOINs is common.

Syntax:
SELECT col1, col2, ...
FROM tab t1
JOIN tab t2
ON t1.foreign_key = t2.foreign_key;

Note: Self JOIN is optimal when you want to show both parent and child relationships within a family tree.
*/

SELECT
    w1.id AS w1_id,
    w1.account_id AS w1_account_id,
    w1.occurred_at AS w1_occured_at,
    w1.channel AS w1_channel,
    w2.id AS w2_id,
    w2.account_id AS w2_account_id,
    w2.occurred_at AS w2_occured_at,
    w2.channel AS w2_channel
FROM web_events w1
LEFT JOIN web_events w2
ON w1.account_id = w2.account_id
AND w2.occurred_at > w1.occurred_at
AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 DAY'
ORDER BY w1.account_id, w1.occurred_at
LIMIT 15;
-----------------------------------------

/** Topic: UNION, UNION ALL

The UNION operator is used to combine the result sets of 2 or more SELECT statements. It removes duplicate rows between the various SELECT statements.
Each SELECT statement within the UNION must have the same number of fields in the result sets with similar data types.
UNION removes duplicate rows but UNION ALL does not remove duplicate rows.

Syntax:
SELECT col1, col2, col3
FROM tab1
UNION
SELECT cola, colb, colc
FROM tab2
;
*/

WITH tab1 AS (SELECT * FROM accounts LIMIT 15)
SELECT * FROM tab1
UNION ALL (SELECT * FROM accounts LIMIT 15)
;

-- Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table.
-- Add a WHERE clause to each of the tables that you unioned in the query above, filtering the first table where name equals Walmart and filtering the second table where name equals Disney. Inspect the results then answer the subsequent quiz.
SELECT * FROM accounts WHERE name = 'Walmart'
UNION ALL
SELECT * FROM accounts WHERE name = 'Disney';

-- Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table in a common table expression and name it double_accounts. Then do a COUNT the number of times a name appears in the double_accounts table. If you do this correctly, your query results should have a count of 2 for each name.
WITH double_accounts AS (
  SELECT * FROM accounts
  UNION ALL
  SELECT * FROM accounts
)
SELECT name, COUNT(name) FROM double_accounts
GROUP BY name
LIMIT 15;
-----------------------------------------

/** Topic: Performance tuning

One way to make a query run faster is to reduce the number of calculations that need to be performed. Some of the high-level things that will affect the number of calculations a given query will make include:
- Table size
- Joins
- Aggregations

Query runtime is also dependent on some things that you can’t really control related to the database itself:
- Other users running queries concurrently on the database
- Database software and optimization (e.g., Postgres is optimized differently than Redshift)

Remember:
- Limiting the dataset will save time in the processing.
- Aggregations are costly, and happen BEFORE you limit the data. So limiting in an aggregation will not be of much help.
- Instead, limit the data first and put it in a sub / CTE, and then perform aggregation on it.

Also:
- If you have time series data, limiting to a small time window can make your queries run more quickly.
- Testing your queries on a subset of data, finalizing your query, then removing the subset limitation is a sound strategy.
- When working with subqueries, limiting the amount of data you’re working with in the place where it will be executed first will have the maximum impact on query run time.
- You can pre-aggregate data of a table of large size before performing join with some other table.

Important: worry about the accuracy of the results before worrying about the run speed.
*/

-- Optimize the following query by placing the join after the aggreation:
/**
SELECT
    a.name,
    COUNT(*) AS web_events
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;
*/

WITH pre_aggregated_data AS (
    SELECT account_id, COUNT(*) AS web_events
    FROM web_events
    GROUP BY 1
)
SELECT
    a.name,
    p.web_events
FROM pre_aggregated_data p
JOIN accounts a
ON p.account_id = a.id
ORDER BY 2 DESC
LIMIT 15;  -- this line is not a part of the solution

/** EXPLAIN keyword gives an estimate on the 'cost' running a statement.
It is not 100 % accurate, so don't use it as an absoulte measure.
Instead, use it as a reference.
*/

-- Use explain to calculate the cost of the above two queries, and see how much optimized the second one is.
EXPLAIN
SELECT
    a.name,
    COUNT(*) AS web_events
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;
-- returned cost as 0..351 approx

EXPLAIN
WITH pre_aggregated_data AS (
    SELECT account_id, COUNT(*) AS web_events
    FROM web_events
    GROUP BY 1
)
SELECT
    a.name,
    p.web_events
FROM pre_aggregated_data p
JOIN accounts a
ON p.account_id = a.id
ORDER BY 2 DESC;
-- returned cost as 0..230 approx

-- Optimize the following by pre-aggregating the needed joins into subs.
/**
SELECT o.occurred_at AS date,
       a.sales_rep_id,
       o.id AS order_id,
       we.id AS web_event_id
FROM   accounts a
JOIN   orders o
ON     o.account_id = a.id
JOIN   web_events we
ON     DATE_TRUNC('day', we.occurred_at) = DATE_TRUNC('day', o.occurred_at)
ORDER BY 1 DESC;
*/

SELECT
	COALESCE(orders.date, web_events.date) AS date,
    orders.active_sales_reps,
    orders.orders,
    web_events.web_visits
FROM (
  SELECT
      DATE_TRUNC('day', o.occurred_at) date,
      COUNT(a.sales_rep_id) active_sales_reps,
      COUNT(o.id) orders
  FROM accounts a
  JOIN orders o
  ON o.account_id = a.id
  GROUP BY 1
) orders

FULL JOIN (
  SELECT
      DATE_TRUNC('day', we.occurred_at) date,
      COUNT(we.id) web_visits
  FROM web_events we
  GROUP BY 1
) web_events

ON web_events.date = orders.date
ORDER BY 1 DESC
LIMIT 15;  -- not a part of the solution
-----------------------------------------

