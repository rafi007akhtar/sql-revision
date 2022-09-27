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
-----------------------------------------

/** Topic: WHERE
The WHERE clause is used to filter data by returning only those rows where one of the columns match a certain condition.
REMEMBER: WHERE is written after FROM and before ORDER BY.
*/

-- Write a query that pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT *
    FROM orders
    WHERE gloss_amt_usd >= 1000
LIMIT 5;

-- Write a query that pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
SELECT *
    FROM orders
    WHERE total_amt_usd < 500
LIMIT 10;

/** The WHERE statement can also be used with non-numeric data. We can use the = and != operators here.
REMEMBER: You need to be sure to use single quotes (just be careful if you have quotes in the original text) with the text data, not double quotes.
*/

-- Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.
SELECT name, website, primary_poc
    FROM accounts
    WHERE name = 'Exxon Mobil'
;

/** Commonly when we are using WHERE with non-numeric data fields, we use the LIKE, NOT, or IN operators. */
