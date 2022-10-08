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




