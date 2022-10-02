# Basic SQL Commands

This table was obtained from [this](https://learn.udacity.com/courses/ud198/lessons/f72745e9-2fc9-4439-9f9d-3dbcea46a6c3/concepts/b6a2123c-81b5-486b-abba-27fad26dd473) Udacity page.

| Statement | How to Use It                      | Other Details                                          |
|-----------|------------------------------------|--------------------------------------------------------|
| SELECT    | SELECT Col1, Col2, ...             | Provide the columns you want                           |
| FROM      | FROM Table                         | Provide the table where the columns exist              |
| LIMIT     | LIMIT 10                           | Limits based number of rows returned                   |
| ORDER BY  | ORDER BY Col                       | Orders table based on the column.  Used with DESC.     |
| WHERE     | WHERE Col &gt; 5                   | A conditional statement to filter your results         |
| LIKE      | WHERE Col LIKE '%me%'              | Only pulls rows where column has 'me' within the text  |
| IN        | WHERE Col IN ('Y', 'N')            | A filter for only rows with column of 'Y' or 'N'       |
| NOT       | WHERE Col NOT IN ('Y', 'N')        | NOT is frequently used with LIKE and IN                |
| AND       | WHERE Col1 &gt; 5 AND Col2 &lt; 3  | Filter rows where two or more conditions must be true  |
| OR        | WHERE Col1 &gt; 5 OR Col2 &lt; 3   | Filter rows where at least one condition must be true  |
| BETWEEN   | WHERE Col BETWEEN 3 AND 5          | Often easier syntax than using an AND                  |

