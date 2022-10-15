/**
JOINs are used for row-level data, and aggregates for column-level.
In practice, row-level data can only be so useful. As the dataset becomes more familiar, aggregates will be performed more often than joins.
Reason: Joins give you many rows of data, while aggregates summarize the data in a single line.
*/

/** Topic: NULLs
NULLs are a datatype that specifies where no data exists in SQL.
They are often ignored in our aggregation functions, which you will get a first look at in the next concept using COUNT.
*/

-- From the accounts table, find all the accounts that do not have a POC.
SELECT *
    FROM accounts
WHERE primary_poc IS NULL
;

-- From the accounts table, find all the first 10 rows that have a POC.
SELECT *
    FROM accounts
WHERE primary_poc IS NOT NULL
LIMIT 10;

/** NOTE: NULL will not work with "=". It can only work with IS.
Reason: NULL is not a value. It is a property of the data.
For the same reason, it will not work with !. It will only work with NOT.
*/
-----------------------------------------

/** Topic: COUNT
It counts the number of rows in the query that have at least one non-NULL value.
In most cases, it is equal to the number of rows in the query.
*/

-- Count all rows in the accounts table.
SELECT COUNT(*)
    FROM accounts
;

-- Count all rows in the accounts table that have a POC.
SELECT COUNT(primary_poc)
    FROM accounts
;

-- Count all the orders that took place in 2016. Name the count orders_2016.
SELECT COUNT(*) orders_2016  -- you can also write AS for the alias
    FROM orders
WHERE occurred_at BETWEEN '2016-01-01' AND '2016-12-31'
;

/** NOTE: COUNT is the an aggregator function that can work on non-numberic data.
Most others will need numberic data only.
*/
-----------------------------------------

