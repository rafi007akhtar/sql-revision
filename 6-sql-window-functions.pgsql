-- NOTE: in many the statements below, I am limiting only cause the # rows are too many.

/** Topic: Window functions.

A window function performs a calculation across a set of table rows that are somehow related to the current row.
This is comparable to the type of calculation that can be done with an aggregate function.
But unlike regular aggregate functions, use of a window function does not cause rows to become grouped into a single output row — the rows retain their separate identities.
Behind the scenes, the window function is able to access more than just the current row of the query result.

A window function call always contains an OVER clause directly following the window function's name and argument(s).
The OVER clause determines exactly how the rows of the query are split up for processing by the window function.

The PARTITION BY list within OVER specifies dividing the rows into groups, or partitions, that share the same values of the PARTITION BY expression(s).

There is another important concept associated with window functions: for each row, there is a set of rows within its partition called its window frame.
Many (but not all) window functions act only on the rows of the window frame, rather than of the whole partition.
By default, if ORDER BY is supplied then the frame consists of all rows from the start of the partition up through the current row, plus any following rows that are equal to the current row according to the ORDER BY clause.
When ORDER BY is omitted the default frame consists of all rows in the partition. 
*/

-- Create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. Your final table should have two columns: one with the amount being added for each new row, and a second with the running total.
SELECT
    standard_amt_usd,
    sum(standard_amt_usd) OVER (ORDER BY occurred_at) running_total
FROM orders
LIMIT 15;

-- Create a running total of standard_amt_usd (in the orders table) over order time, but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable.
-- Your final table should have three columns:
-- * One with the amount being added for each row,
-- * one for the truncated date,
-- * and a final column with the running total within each year.
SELECT
    standard_amt_usd,
    date_trunc('year', occurred_at) years,
    sum(standard_amt_usd)
        OVER (PARTITION BY date_trunc('year', occurred_at) ORDER BY occurred_at)
        running_total
FROM orders
LIMIT 15;

/** Topics: ROW_NUMBER and RANK
The RANK() function produces a numerical rank within the current row's partition for each distinct ORDER BY value, in the order defined by the ORDER BY clause.
RANK needs no explicit parameter, because its behavior is entirely determined by the OVER clause.

row_number() -> Returns the number of the current row within its partition, counting from 1.

dense_rank() -> Returns the rank of the current row, without gaps; this function effectively counts peer groups.
*/

-- Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition. Your final table should have these four columns.
SELECT
    id,
    account_id,
    total,
    rank() OVER (PARTITION BY account_id ORDER BY total DESC) total_rank
FROM orders
LIMIT 15;
