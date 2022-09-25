/** Topic: LIMIT
`LIMIT n` returns returns the first `n` rows of the select statement.
If # of rows < n, then it returns all the rows
*/
SELECT *
    FROM orders
LIMIT 10;

-- Write a query that displays all the data in the occurred_at, account_id, and channel columns of the web_events table, and limits the output to only the first 15 rows.
SELECT occurred_at, account_id, channel
    FROM web_events
LIMIT 15;
-----------------------------------------

/** Topic: ORDER BY
The ORDER BY statement allows us to sort our results using the data in any column.
REMEMBER:
    - ORDER BY results are not permanent, so when you use ORDER BY in a SQL query, your output will be sorted that way, but then the next query you run will encounter the unsorted data again.
    - The ORDER BY statement always comes in a query after the SELECT and FROM statements, but before the LIMIT statement. If you are using the LIMIT statement, it will always appear last.
    - DESC can be added after the column in your ORDER BY statement to sort in descending order, as the default is to sort in ascending order.
*/

-- Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
SELECT id, occurred_at, total_amt_usd
    FROM orders
    ORDER BY occurred_at
LIMIT 10;

-- Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
    FROM orders
    ORDER BY total_amt_usd DESC
LIMIT 5;

-- Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
    FROM orders
    ORDER BY total_amt_usd
LIMIT 20;

/** When you provide a list of columns in an ORDER BY command, the sorting occurs using the leftmost column in your list first, then the next column from the left, and so on.
We still have the ability to flip the way we order using DESC.
*/

-- Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).
SELECT id, account_id, total_amt_usd
    FROM orders
    ORDER BY account_id, total_amt_usd DESC
LIMIT 10; -- limiting only cause the # rows are too many


-- Now write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).
SELECT id, account_id, total_amt_usd
    FROM orders
    ORDER BY total_amt_usd DESC, account_id
LIMIT 10; -- limiting only cause the # rows are too many

