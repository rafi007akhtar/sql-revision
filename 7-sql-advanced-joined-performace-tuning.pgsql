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

