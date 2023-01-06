# Advanced JOINs and Performance Tuning

## JOINS

Left joins include unmatched rows from the left table, which is indicated in the “FROM” clause.

Syntax:
```SQL
SELECT column_name(s)
FROM Table_A
LEFT JOIN Table_B ON Table_A.column_name = Table_B.column_name;
```

Right joins are similar to left joins, but include unmatched data from the right table -- the one that’s indicated in the JOIN clause.

Syntax:
```SQL
SELECT column_name(s)
FROM Table_A
RIGHT JOIN Table_B ON Table_A.column_name = Table_B.column_name;
```

In some cases, you might want to include unmatched rows from both tables being joined. You can do this with a full outer join.
A common application of this is when joining two tables on a timestamp.
```SQL
Syntax:
SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;
```

If you wanted to return unmatched rows only,
which is useful for some cases of data assessment,
you can isolate them by adding the following line to the end of the query:
```SQL
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL
```

Example:
```SQL
SELECT
a.*,
s.*
FROM accounts a
FULL OUTER JOIN sales_reps s
ON s.id = a.sales_rep_id
```

### JOINs with comparison operator.
Here, the JOIN clause will have two operations:
- one with an = sign
- one with a comparison operator (like <, > etc.)

You should't put the second without the first.

Also, using comparison operators may produce results that are difficult to predict.

**Note:**

If you recall from earlier lessons on joins, the join clause is evaluated before the where clause.
Filtering in the join clause will eliminate rows before they are joined, while filtering in the `WHERE` clause will leave those rows in and produce some nulls.

### Self JOINs
These are tables that join onto themselves.
These _always_ need aliases to distinguish b/w left and right tables.

One of the most common use cases for self JOINs is in cases where two events occurred, one after another.
Using inequalities in conjunction with self JOINs is common.

Syntax:
```SQL
SELECT col1, col2, ...
FROM tab t1
JOIN tab t2
ON t1.foreign_key = t2.foreign_key;
```

Note: Self JOIN is optimal when you want to show both parent and child relationships within a family tree.

## `UNION`, `UNION ALL`
The `UNION` operator is used to combine the result sets of 2 or more `SELECT` statements. It removes duplicate rows between the various `SELECT` statements.
Each `SELECT` statement within the `UNION` must have the same number of fields in the result sets with similar data types.
`UNION` removes duplicate rows but `UNION` ALL does not remove duplicate rows.

Syntax:
```SQL
SELECT col1, col2, col3
FROM tab1
UNION
SELECT cola, colb, colc
FROM tab2
;
```
---

## Performance Tuning
ne way to make a query run faster is to reduce the number of calculations that need to be performed. Some of the high-level things that will affect the number of calculations a given query will make include:
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

Example:

Unoptimized code:
```SQL
SELECT
    a.name,
    COUNT(*) AS web_events
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;
```

Optimized code, with pre-aggregation:
```SQL
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
```
This can also be done by pre-aggregating multiple tables in subs, and _then_ joining them. This is done to reduce the row count.

**Note**: `COUNT (DISTINCT *)` takes a lot more time than `COUNT` or even `FULL JOIN`, and therefore should be avoided by pre-aggregating the data.

## `EXPLAIN` keyword
It gives an estimate on the 'cost' running a statement.
It is not 100 % accurate, so don't use it as an absoulte measure.
Instead, use it as a reference.

Example:

Statement:
```SQL
EXPLAIN
SELECT
    a.name,
    COUNT(*) AS web_events
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;
```

Output:
```
Sort  (cost=230.78..231.66 rows=351 width=22)
  Sort Key: p.web_events DESC
  ->  Hash Join  (cost=206.50..215.94 rows=351 width=22)
        Hash Cond: (a.id = p.account_id)
        ->  Seq Scan on accounts a  (cost=0.00..8.51 rows=351 width=18)
        ->  Hash  (cost=202.12..202.12 rows=351 width=12)
              ->  Subquery Scan on p  (cost=195.10..202.12 rows=351 width=12)
                    ->  HashAggregate  (cost=195.10..198.61 rows=351 width=12)
                          Group Key: web_events.account_id
                          ->  Seq Scan on web_events  (cost=0.00..149.73 rows=9073 width=4)
```
---
