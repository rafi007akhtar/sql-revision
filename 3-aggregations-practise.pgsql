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

/** Topic: GROUP BY
GROUP BY can be used to aggregate data within subsets of the data.
For example, grouping for different accounts, different regions, or different sales representatives.
GROUP BY goes b/w WHERE and ORDER BY.

Note: SQL evaluates the aggregations before the LIMIT clause.

Rule of thumb: Any column in a SELECT statement not being aggregated should be in the GROUP BY if the statement contains aggregations.
*/

-- Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT
    a.name account_name, o.occurred_at order_date
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;

-- Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT
    a.name account_name, SUM(o.total_amt_usd) total_sales
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
GROUP BY a.name
LIMIT 10;

-- Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT
    w.occurred_at date, w.channel,
    a.name account_name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

-- Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT
    channel, COUNT(channel)
FROM web_events
GROUP BY channel;

-- Who was the primary contact associated with the earliest web_event?
SELECT
    a.primary_poc "primary contact for earliest web_event"
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY occurred_at
LIMIT 1;

-- What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT
    a.name account_name,
    MIN(o.total_amt_usd) smallest_order
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY smallest_order
LIMIT 10;

-- Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT
    r.name region,
    COUNT(s.name) number_of_reps
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER BY number_of_reps;

/** GROUP BY and ORDER BY can have multiple columns in a statement.
The order of columns mentioned in GROUP BY does not matter.
The order of columns mentioned in ORDER BY determines which sorting will happen first, L to R.
*/

-- For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
SELECT
    a.name account_name,
    AVG(o.standard_qty) standard_paper_average,
    AVG(o.gloss_qty) glossy_paper_average,
    AVG(o.poster_qty) poster_average
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
LIMIT 10;

-- For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT
    a.name account_name,
    AVG(o.standard_amt_usd) standard_amt_avg,
    AVG(o.gloss_amt_usd) glossy_amt_avg,
    AVG(o.poster_amt_usd) poster_amt_avg
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
LIMIT 10;

-- Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT
    s.name sales_rep,
    w.channel,
    COUNT(w.channel) channel_occurences
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY sales_rep, w.channel
ORDER BY channel_occurences DESC
LIMIT 10;

-- Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT
    r.name region,
    w.channel,
    COUNT(w.channel) channel_occurences
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY region, w.channel
ORDER BY channel_occurences DESC;
-----------------------------------------
