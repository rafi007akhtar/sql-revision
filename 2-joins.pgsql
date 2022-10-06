/** Join #1: INNER JOIN
We use ON clause to specify a JOIN condition which is a logical statement to combine the table in FROM and JOIN statements.
*/

SELECT orders.*, accounts.*
    FROM orders
    JOIN accounts
    ON orders.account_id = accounts.id
LIMIT 10;