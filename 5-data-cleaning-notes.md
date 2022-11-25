# Data Cleaning

The following data cleaning tools were taught.

1. LEFT(text, len): Pull the first `len` characters from the string `text` (L to R)
2. RIGHT(text, len): Pull the first `len` characters from the string `text` (R to L)
3. LENGTH(text): return the number of characters in `text`

    > When Using functions within functions, the inner functions will be evaluated first, and then the outer ones.
4. `POSITION(char IN col)` and `STRPOS(col, char)` are used to find the position of a character in a string (1-indexed, case-sensitive).
5. Strings can concatenated using the CONCAT function, or the pipe operator.
Syntax:
    ```sql
    CONCAT(str1, str2, str3, ...)
    str1 || str2 || str3 || ...
    ```
6. `COALESCE(col_name, value_if_null)` It is used to fill NULL values in a column with a specified non-NULL value.
