# Subqueries and Temporary Tables

## Subquery
- The inner query will run first, and then the outer one.
    ```sql
    SELECT col1, col2, ... FROM (
        SELECT colA, colB, ... FROM tab
    ) t;
    ```
    Here, it is mandatory to alias the inner table.
- It can also be used as a condition to be put in clauses.
    - single value to be put in clauses like `WHERE`, `HAVING` `CASE`
    ```sql
    SELECT t1.name FROM t1
    WHERE t1.name = (SELECT names FROM t2 WHERE id=1);
    ```
    - multiple values to be put in the `IN` clause
    ```sql
    SELECT t1.name FROM t1
    WHERE t1.name IN (SELECT names FROM t2);
    ```

## Common Table Expression (CTE)
- The WITH statement is often called a Common Table Expression or CTE. It is used the save a subquery in the DB which can then be used in another query.
- This way, the inner subquery need not run multiple times, thus saving performance.
- The WITH has to be clubbed with another statement. It can't just exist on its own.

Like this:

```sql
WITH t AS (SELECT col1, col2 FROM tab)
SELECT t.name
FROM t
JOIN tab
ON condition
AND t.name IN tab.last_name;
```

---

