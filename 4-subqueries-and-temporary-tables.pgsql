-- NOTE: in many the statements below, I am limiting only cause the # rows are too many.

/** Topic: Subquery

A subquery is a query within a query. The inner query runs first, and table it creates is queried by the outer query.

Here, it is mandatory to put an alias for the inner query.
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
