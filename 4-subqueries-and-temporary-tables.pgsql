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

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT t3.rep_name, t3.region_name, t3.total_sales
FROM (
    SELECT region_name, max(total_sales) max_total_sales
    FROM (
        SELECT
            s.name rep_name,
            r.name region_name,
            sum(o.total_amt_usd) total_sales
        FROM orders o
        JOIN accounts a
        ON o.account_id = a.id
        JOIN sales_reps s
        ON a.sales_rep_id = s.id
        JOIN region r
        ON s.region_id = r.id
        GROUP BY 1, 2
        ORDER BY 3 DESC
    ) t1
    GROUP BY 1
) t2
JOIN (
    SELECT
            s.name rep_name,
            r.name region_name,
            sum(o.total_amt_usd) total_sales
        FROM orders o
        JOIN accounts a
        ON o.account_id = a.id
        JOIN sales_reps s
        ON a.sales_rep_id = s.id
        JOIN region r
        ON s.region_id = r.id
        GROUP BY 1, 2
        ORDER BY 3 DESC
) t3
ON t3.region_name = t2.region_name
AND t3.total_sales = t2.max_total_sales;
-- By far, this was the toughest one. And I wouldn't go so far as to say I understood it completely.

-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
SELECT r.name, count(o.total)
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name = (
    SELECT r.name
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    JOIN sales_reps s
    ON a.sales_rep_id = s.id
    JOIN region r
    ON s.region_id = r.id
    GROUP BY r.name
    ORDER BY sum(o.total_amt_usd) DESC
    LIMIT 1
)
GROUP BY 1;

-- Official solution, which also makes sense but takes one extra nesting.
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);

-- How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
SELECT count (*) FROM (
    SELECT
        a.name, sum(o.total)
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    GROUP BY a.name
    HAVING sum(o.total) > (
        SELECT
            sum(o.total) total_purchase
        FROM orders o
        JOIN accounts a
        ON o.account_id = a.id
        GROUP BY a.name
        ORDER BY sum(o.standard_qty) DESC
        LIMIT 1
    )
) t;

-- Official solution, which also makes sense but takes one extra nesting.
SELECT COUNT(*)
FROM (SELECT a.name
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY 1
       HAVING SUM(o.total) > (SELECT total 
                   FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) inner_tab)
             ) counter_tab;

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
SELECT a.name, w.channel, count(*) events_count
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.id = (
    SELECT
        o.account_id aid
    FROM accounts a
    JOIN orders o
    ON o.account_id = a.id
    GROUP BY 1
    ORDER BY sum(o.total_amt_usd) DESC
    LIMIT 1
)
GROUP BY 1, 2
ORDER BY 3 DESC;
-- not putting the official soln for this one as it is similar to the previous ones.

-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT avg(t.top_amt) FROM (
    SELECT account_id, sum(total_amt_usd) top_amt
    FROM orders
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
) t;

-- What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.
SELECT avg(t.avg_spent)
FROM (
    SELECT account_id, avg(total_amt_usd) avg_spent
    FROM orders
    GROUP BY 1
    HAVING avg(total_amt_usd) > (
        SELECT avg(total_amt_usd) FROM orders
    )
    ORDER BY 2
) t;
-----------------------------------------

/** Topic: WITH statement, and CTEs

The WITH statement is often called a Common Table Expression or CTE. It is used the save a subquery in the DB which can then be used in another query.
This way, the inner subquery need not run multiple times, thus saving performance.
*/

-- Find the average number of events for each channel per day, using a CTE.
-- First, create a CTE using WITH and put the inner query in it.
WITH events AS (
    SELECT
        DATE_TRUNC('day',occurred_at) AS day,
        channel,
        COUNT(*) as events
    FROM web_events 
    GROUP BY 1,2
)
-- Now, use the events CTE and perform the outer query.
SELECT channel, avg(events)
FROM events
GROUP BY 1
ORDER BY 2 DESC;
/** NOTEs:
* I did not see any new table inside the DB after running these statements.
* The WITH has to be clubbed with another statement. It can't just exist on its own.
*/

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
WITH sales_region AS (
    SELECT
        s.name rep_name,
        r.name region_name,
        sum(o.total_amt_usd) total_sales
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    JOIN sales_reps s
    ON a.sales_rep_id = s.id
    JOIN region r
    ON s.region_id = r.id
    GROUP BY 1, 2
    ORDER BY 3 DESC
)
SELECT t3.rep_name, t3.region_name, t3.total_sales
FROM (
    SELECT region_name, max(total_sales) max_total_sales
    FROM sales_region
    GROUP BY 1
) t2
JOIN sales_region t3
ON t3.region_name = t2.region_name
AND t3.total_sales = t2.max_total_sales;

-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
WITH largest_sales_region AS (
    SELECT
        r.id region_id,
        r.name,
        count(o.total) order_count
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    JOIN sales_reps s
    ON a.sales_rep_id = s.id
    JOIN region r
    ON s.region_id = r.id
    GROUP BY r.id, r.name
    ORDER BY sum(o.total_amt_usd) DESC
    LIMIT 1
)
SELECT order_count FROM largest_sales_region;

-- How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
WITH t1 AS (
    SELECT
        sum(o.total) total_purchase
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    GROUP BY a.name
    ORDER BY sum(o.standard_qty) DESC
    LIMIT 1
), t2 AS (
    SELECT
        a.name,
        sum(o.total) total
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    GROUP BY a.name
    HAVING sum(o.total) > (SELECT total_purchase FROM t1)
)
SELECT count(*) FROM t2;
/** NOTE: This is how you make CTEs of two or more tables. */

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
WITH t1 AS (
    SELECT
        o.account_id aid
    FROM accounts a
    JOIN orders o
    ON o.account_id = a.id
    GROUP BY 1
    ORDER BY sum(o.total_amt_usd) DESC
    LIMIT 1
), t2 AS (
    SELECT a.name, w.channel, count(*) events_count
    FROM web_events w
    JOIN accounts a
    ON w.account_id = a.id
    WHERE a.id = (SELECT * FROM t1)
    GROUP BY 1, 2
    ORDER BY 3 DESC
)
SELECT * FROM t2;

-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
WITH t AS (
    SELECT account_id, sum(total_amt_usd) top_amt
    FROM orders
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
)
SELECT avg(top_amt) FROM t;

-- What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders
WITH t1 AS (SELECT avg(total_amt_usd) FROM orders),
t2 AS (
    SELECT account_id, avg(total_amt_usd) avg_spent
    FROM orders
    GROUP BY 1
    HAVING avg(total_amt_usd) > (SELECT * FROM t1)
    ORDER BY 2
)
SELECT avg(avg_spent) FROM t2;
-----------------------------------------

