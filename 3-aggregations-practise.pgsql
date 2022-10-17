-- NOTE: in many the statements below, I am limiting only cause the # rows are too many.

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

/** Topic: SUM
SUM can only work on numeric columns.
It will add all the non-NULL cells in the column, and ignore the NULLs.
*/

-- Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_amt_usd)
    FROM orders
;

-- Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_amt_usd)
    FROM orders
;

-- Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd) FROM orders;

-- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
SELECT
    standard_amt_usd + gloss_amt_usd "total of standard and gloss"
FROM orders
LIMIT 10;

-- Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(standard_amt_usd) / SUM(standard_qty) standard_amt_per_unit
FROM orders;
-----------------------------------------

/** Topic: MIN, MAX, AVG
Functionally, MIN and MAX are similar to COUNT in that they can be used on non-numerical columns.
Depending on the column type, MIN will return the lowest number, earliest date, or non-numerical value as early in the alphabet as possible.
As you might suspect, MAX does the opposite—it returns the highest number, the latest date, or the non-numerical value closest alphabetically to "Z."

Similar to other software AVG returns the mean of the data
- that is the sum of all of the values in the column divided by the number of values in a column.
This aggregate function again ignores the NULL values in both the numerator and the denominator.
*/

-- When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at) FROM orders AS earliest_order;

-- Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at earliest_order_no_aggregate
    FROM orders
ORDER BY occurred_at
LIMIT 1;

-- When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at) FROM orders AS latest_order;

-- Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at latest_order_no_aggregate
    FROM orders
ORDER BY occurred_at DESC
LIMIT 1;

-- Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
SELECT
    AVG(standard_amt_usd) standard_mean,
    AVG(gloss_amt_usd) gloss_mean,
    AVG(poster_amt_usd) poster_mean,
    AVG(standard_qty) standard_unit,
    AVG(gloss_qty+0.01) gloss_unit,
    AVG(poster_qty+0.01) poster_unit
FROM orders;

/** Difference b/w AVG and SUM/COUNT.
AVG(item) exlcudes NULL from both numberator and denominator.
If NULL rows are also to be included, the expression should be
SUM(item)/COUNT(item)
*/
-----------------------------------------





