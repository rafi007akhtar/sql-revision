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

