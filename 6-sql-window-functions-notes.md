# Window Functions

All Window functions (docs): https://www.postgresql.org/docs/8.4/functions-window.html

---

A window function performs a calculation across a set of table rows that are somehow related to the current row. <br>
This is comparable to the type of calculation that can be done with an aggregate function. <br>
But unlike regular aggregate functions, use of a window function does not cause rows to become grouped into a single output row — the rows retain their separate identities. <br>
Behind the scenes, the window function is able to access more than just the current row of the query result.

## `OVER` and `PARTITION BY`
A window function call always contains an `OVER` clause directly following the window function's name and argument(s). <br>
The `OVER` clause determines exactly how the rows of the query are split up for processing by the window function.

The `PARTITION BY` list within `OVER` specifies dividing the rows into groups, or partitions, that share the same values of the `PARTITION BY` expression(s).

There is another important concept associated with window functions: for each row, there is a set of rows within its partition called its **window frame**.
Many (but not all) window functions act only on the rows of the window frame, rather than of the whole partition. <br>
By default, if `ORDER BY` is supplied then the frame consists of all rows from the start of the partition up through the current row, plus any following rows that are equal to the current row according to the `ORDER BY` clause.
When `ORDER BY` is omitted the default frame consists of all rows in the partition. 

Example: A running total of standard_amt_usd (in the orders table) over order time with no date truncation.
```SQL
SELECT
    standard_amt_usd,
    sum(standard_amt_usd) OVER (ORDER BY occurred_at) running_total
FROM orders
```

## `ROW_NUMBER` and `RANK`

The `RANK()` function produces a numerical rank within the current row's partition for each distinct ORDER BY value, in the order defined by the `ORDER BY` clause. <br>
`RANK` needs no explicit parameter, because its behavior is entirely determined by the `OVER` clause.

- `row_number()` -> Returns the number of the current row within its partition, counting from 1.

- `dense_rank()` -> Returns the rank of the current row, without gaps; this function effectively counts peer groups.
*/

Example: Ranking the total amount of paper ordered (from highest to lowest) for each account using a partition.
```SQL
SELECT
    id,
    account_id,
    total,
    rank() OVER (PARTITION BY account_id ORDER BY total DESC) total_rank
FROM orders
```

## Alias for window functions.

The value of the `OVER` clause can be replaced with an alias.
The alias name is preceded by a `WINDOW` keyword, that goes between `WHERE` and `GROUP BY`.

Syntax:
```SQL
WINDOW alias_name AS (PARTITION value)
```

Example:
```SQL
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       SUM(standard_qty) OVER account_year_window AS sum_std_qty,
       COUNT(standard_qty) OVER account_year_window AS count_std_qty,
       AVG(standard_qty) OVER account_year_window AS avg_std_qty,
       MIN(standard_qty) OVER account_year_window AS min_std_qty,
       MAX(standard_qty) OVER account_year_window AS max_std_qty
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at))
```

## `LAG` and `LEAD`

These are used to compare between two consecutive rows.
- `LAG(agg) OVER (partition)` of the current row is the aggregate value of the previous row.
- `LEAD(agg) OVER (partition)` of the current row is the aggregate value of the next row.

The difference between previous row aggregate and current row aggregate is called the _lag difference_.
The difference between next row aggregate and current row aggregate is called the _lead difference_.

Example: a query to perform lag and lead differences for the standard sales of an order based on account.
```SQL
SELECT
    account_id,
    standard_sum,
    LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
    LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
    standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
    LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM
(
    SELECT
        account_id,
        SUM(standard_qty) AS standard_sum
    FROM orders
    GROUP BY 1
) sub;
```

# `NTILE`'s

You can use window functions to identify what percentile (or quartile, or any other subdivision) a given row falls into. The syntax is `NTILE(*# of buckets*)`. In this case, `ORDER BY` determines which column to use to determine the ntiles.

### Note:
In cases with relatively few rows in a window, the NTILE function doesn’t calculate exactly as you might expect.<br>
For example, If you only had two records and you were measuring percentiles, you’d expect one record to define the 1st percentile, and the other record to define the 100th percentile.<br>
Using the NTILE function, what you’d actually see is one record in the 1st percentile, and one in the 2nd percentile.

In other words, when you use a `NTILE` function but the number of rows in the partition is less than the `NTILE(number of groups)`, then `NTILE` will divide the rows into as many groups as there are members (rows) in the set but then stop short of the requested number of groups.
If you’re working with very small windows, keep this in mind and consider using quartiles or similarly small bands.

Example:
```SQL
SELECT
    account_id,
    occurred_at,
    standard_qty,
    ntile(4) OVER (PARTITION BY account_id ORDER BY standard_qty DESC) standard_quartile
FROM orders
ORDER BY account_id DESC;
```

---

