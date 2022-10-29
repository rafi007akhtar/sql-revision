-- NOTE: in many the statements below, I am limiting only cause the # rows are too many.

/** Topic: Subquery

A subquery is a query within a query. The inner query runs first, and table it creates is queried by the outer query.

Here, it is mandatory to put an alias for the inner query (for most cases).
*/

-- Find the number of events that occur for each day for each channel.
SELECT channel, avg(event_count) FROM (
    SELECT
        date_trunc('day', occurred_at) days,
        channel,
        COUNT(*) event_count
    FROM web_events
    GROUP BY 1, 2
) AS sub
GROUP BY 1;

/**
Conditional subqueries are those that return only one value that can then be used in a WHERE, HAVING, or CASE clause.

If it returns multiple values, it can only be used with an IN clause.

In this case, you should not put an alias for the inner query.
*/

-- Pull the first month/year combo from the orders table. Then to pull the average for each paper type, and the total amount spent.
SELECT
    avg(o.standard_qty) standard_avg,
    avg(o.gloss_qty) gloss_avg,
    avg(o.poster_qty) poster_avg,
    sum(o.total_amt_usd) total_amt_spent
FROM orders o
JOIN (
    SELECT
    date_trunc('month', min(occurred_at)) earliest_order
    FROM orders
) sub
ON date_part('year', o.occurred_at) = date_part('year', sub.earliest_order)
AND date_part('month', o.occurred_at) = date_part('month', sub.earliest_order)
;

-- Alternatively, this is the official solution, which also makes sense.
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);




