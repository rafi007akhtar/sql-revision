# SQL Aggregations

## Basic aggregations

The following aggregations were covered.

1. `COUNT(col)` to count the number of rows in a table / column.
    - Use `COUNT(*)` to count all rows.
2. `SUM(col)` to sum all _numeric_ values in a column.
3. `MIN(col)` to get the lowest value in a column.
4. `AVG(col)` to get the arithmetic mean of all numeric, non-null values in a column.
    - For including the `NULL` values in the average calculation, go with `SUM(col)/COUNT(col)`.
5. `GROUP BY col` used for aggregating data within subsets of data.
    - It can also be used on multiple columns: `GROUP BY col1, col2, ...`
    - Instead of the column names, their indexes in the `SELECT` statement can also be used.
    ```SQL
    SELECT name, age, dob
    FROM info
    GROUP BY 1, 2 -- shows dob in groups of (name, age)
    ```
    - Same indexing is possible with `ORDER BY` as well (`ORDER BY 1`).
6. `DISTINCT` is used to filter out duplicate rows in a `SELECT` statement: `SELECT DISTINCT name FROM info`.
7. `HAVING` is a `WHERE` subsitute for conditions that involve aggregations.

## Date functions.

SQL follows dates in **YYYY-MM-DD hh:min:s** format for ease of sorting.

The following date functions were covered.
1. `DATE_PART(field, date)` to extract a field from a given date.
    ```SQL
    -- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least.
    SELECT
        DATE_PART('year', occurred_at) years,
        SUM(total_amt_usd) sale
    FROM orders
    GROUP BY 1
    ORDER BY 2 DESC;
    ```
2. `DATE_TRUNC(field, date)` to reset all parts of a date beyond `field`.
    ```SQL
    -- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
    SELECT
        date_trunc('month', occurred_at),
        SUM(gloss_amt_usd) gloss_amt_total
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    WHERE a.name = 'Walmart'
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1;
    ```

## Case
It's like an if-else block.

Syntax:
```
SELECT col1, col2, ...
CASE
    WHEN condition1 THEN val1
    WHEN condition2 THEN val2
    ...
    ELSE val END
AS col_name
FROM table;
```

This creates a new column `col_name` in the table with values for each row based on the given condiion.
```SQL
-- Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
SELECT
    account_id, total_amt_usd,
CASE
    WHEN total_amt_usd > 3000 THEN 'Large'
    ELSE 'Small' END
AS order_level
FROM orders
LIMIT 25;
```
---
