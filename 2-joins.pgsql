-- NOTE: in all the statements below, I am limiting only cause the # rows are too many.

/** Join #1: INNER JOIN
We use ON clause to specify a JOIN condition which is a logical statement to combine the table in FROM and JOIN statements.
*/

SELECT orders.*, accounts.*
    FROM orders
    JOIN accounts
    ON orders.account_id = accounts.id
LIMIT 10;

-- Try pulling all the data from the accounts table, and all the data from the orders table.
SELECT *
    FROM orders
    JOIN accounts
    ON orders.account_id = accounts.id
LIMIT 10;

-- Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT
    orders.standard_qty, orders.gloss_qty, orders.poster_qty,
    accounts.primary_poc, accounts.website
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
LIMIT 10;

/** REMEMBER: it is FOREIGN_KEY = PRIMARY_KEY when joining two tables.
In the above statement, account_id is the foreign key for orders, and id is the primary key for accounts.id

Also:
Foreign keys are always associated with a primary key, and they are associated with the crow-foot notation above to show they can appear multiple times in a particular table.
*/
-----------------------------------------

/** Topic: ALIASING

Syntax for aliasing table names:
    FROM tablename AS aliasname
Alternatively, skip the AS statement:
    FROM tablename aliasname

Syntax for aliasing column name:
    SELECT colname AS c1
Alternatively, skip the AS statement:
    SELECT colname c1
*/

-- Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
SELECT
    a.name, a.primary_poc,
    w.occurred_at, w.channel
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart'
LIMIT 10;

-- Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT
    r.name,
    s.name,
    a.name
FROM sales_reps AS s
JOIN region AS r
ON s.region_id = r.id
JOIN accounts AS a
ON a.sales_rep_id = s.id
ORDER BY a.name
LIMIT 10;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
SELECT
    r.name AS region,
    a.name AS "account name",
    o.total_amt_usd / (o.total + 0.01) unit_price
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
LIMIT 10;
-----------------------------------------





