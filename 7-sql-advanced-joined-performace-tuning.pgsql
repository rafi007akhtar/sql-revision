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

You can't have the second without the first.

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
;
-----------------------------------------
