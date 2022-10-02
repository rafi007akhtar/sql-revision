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
-----------------------------------------

/** Topic: Derived columns and aliasing
Creating a new column that is a combination of existing columns is known as a derived column (or "calculated" or "computed" column). Usually you want to give a name, or "alias," to your new column using the AS keyword.

This derived column, and its alias, are generally only temporary, existing just for the duration of your query. The next time you run a query and access this table, the new column will not be there.

Order of arithmetic operations will happen using the PEDMAS rule.
*/

-- Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. Limit the results to the first 10 orders, and include the id and account_id fields.
SELECT
    id,
    account_id,
    standard_amt_usd / standard_qty AS unit_price
FROM orders
LIMIT 10;

-- Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd. (Try to do this without using the total column.) Display the id and account_id fields also. NOTE - you will receive an error with the correct solution to this question. This occurs because at least one of the values in the data creates a division by zero in your formula. You will learn later in the course how to fully handle this issue. For now, you can just limit your calculations to the first 10 orders, as we did in question #1, and you'll avoid that set of data that causes the problem.
SELECT
    id,
    account_id,
    (poster_amt_usd / (standard_amt_usd + gloss_amt_usd + poster_amt_usd)) * 100 AS revenue_percentage
FROM orders
LIMIT 10;
-----------------------------------------

/** Topic: LIKE
The LIKE operator is frequently used with %. The % tells us that we might want any number of characters leading up to a particular set of characters or following a certain set of characters.

Remember you will need to use single quotes for the text you pass to the LIKE operator.
*/

-- Use the accounts table to find
-- All the companies whose names start with 'C'.
SELECT *
    FROM accounts
    WHERE name LIKE 'C%'
LIMIT 5; -- limiting only cause the # rows are too many

-- All companies whose names contain the string 'one' somewhere in the name.
SELECT *
    FROM accounts
    WHERE name LIKE '%one%'
LIMIT 10; -- limiting only cause the # rows are too many

-- All companies whose names end with 's'.
SELECT *
    FROM accounts
    WHERE name LIKE '%s'
LIMIT 10; -- limiting only cause the # rows are too many
-----------------------------------------

/** Topic: IN
This operator allows you to use an =, but for more than one item of that particular column.
*/
-- Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
    FROM accounts
    WHERE name IN ('Walmart', 'Target', 'Nordstrom')
;

-- Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
SELECT *
    FROM web_events
    WHERE channel IN ('orgnaic', 'adwords')
LIMIT 20; -- limiting only cause the # rows are too many
-----------------------------------------

/** Topic: NOT
The NOT operator is an extremely useful operator for working with the previous two operators we introduced: IN and LIKE. By specifying NOT LIKE or NOT IN, we can grab all of the rows that do not meet a particular criteria.
*/
-- Use the accounts table to find:

-- All the companies whose names do not start with 'C'.
SELECT *
    FROM accounts
    WHERE name NOT LIKE 'C%'
LIMIT 5; -- limiting only cause the # rows are too many

-- All companies whose names do not contain the string 'one' somewhere in the name.
SELECT *
    FROM accounts
    WHERE name NOT LIKE '%one%'
LIMIT 10; -- limiting only cause the # rows are too many

-- All companies whose names do not end with 's'.
SELECT *
    FROM accounts
    WHERE name NOT LIKE '%s'
LIMIT 10; -- limiting only cause the # rows are too many
-----------------------------------------

/** Topic: AND, BETWEEN
The AND operator is used within a WHERE statement to consider more than one logical clause at a time. Each time you link a new statement with an AND, you will need to specify the column you are interested in looking at.

Sometimes we can make a cleaner statement using BETWEEN than we can using AND. Particularly this is true when we are using the same column for different parts of our AND statement.

Remember: BETWEEN is inclusive, so
`BETWEEN a AND b` would include a and b.
*/

-- Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
SELECT *
    FROM orders
    WHERE standard_qty > 1000
    AND poster_qty = 0
    AND gloss_qty = 0
;

-- Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.
SELECT *
    FROM accounts
    WHERE name NOT LIKE 'C%'
    AND name LIKE '%s'
LIMIT 10; -- limiting only cause the # rows are too many

-- Write a query that displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. Then look at your output to see if the BETWEEN operator included the begin and end values or not.
SELECT occurred_at, gloss_qty
    FROM orders
    WHERE gloss_qty BETWEEN 24 and 29
LIMIT 10; -- limiting only cause the # rows are too many

-- Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.
SELECT *
    FROM web_events
    WHERE channel IN ('organic', 'adwords')
    AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
    ORDER BY occurred_at DESC
LIMIT 10; -- limiting only cause the # rows are too many

/** NOTE: While BETWEEN is generally inclusive of endpoints, it assumes the time is at 00:00:00 (i.e. midnight) for dates. This is the reason why the right-side endpoint of the period is set at '2017-01-01'. */
-----------------------------------------

/** Topic: OR
It will combine conditions and return rows on which any one of those conditions is true.

When combining multiple of these operations, we frequently might need to use parentheses to assure that logic we want to perform is being executed correctly.
*/
-- Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.
SELECT id
    FROM orders
    WHERE gloss_qty > 4000
    OR poster_qty > 4000
;

-- Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
SELECT *
    FROM orders
    WHERE standard_qty = 0
    OR (
        gloss_qty > 1000
        OR poster_qty > 1000
    )
LIMIT 10; -- limiting only cause the # rows are too many


-- Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
SELECT name
    FROM accounts
    WHERE (
        name LIKE 'C%'
        OR name LIKE 'W%')
    AND (
        primary_poc LIKE '%ana%'
        OR primary_poc LIKE '%Ana%'
    )
    AND primary_poc NOT LIKE '%eana%'
;
-----------------------------------------
