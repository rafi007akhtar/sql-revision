-- NOTE: in many the statements below, I am limiting only cause the # rows are too many.

/**
Data cleaning is used to:
- clean and restructure messy data
- convert columns to different data types
- manipulating NULLs
*/

/** Topic: LEFT, RIGHT, LENGTH
- LEFT(text, len): Pull the first `len` characters from the string `text` (L to R)
- RIGHT(text, len): Pull the first `len` characters from the string `text` (R to L)
- LENGTH(text): return the number of characters in `text`

When Using functions within functions, the inner functions will be evaluated first, and then the outer ones.
*/

-- In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.
SELECT
    right(website, 3) "domain",
    COUNT(*) number_of_companies
FROM accounts
GROUP BY 1;

-- There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
SELECT
    left(upper(name), 1) first_letter,
    COUNT(*) number_of_companies
FROM accounts
GROUP BY 1
ORDER BY 1;

-- Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?
SELECT
    SUM(letter) / (COUNT(*) * 1.0) letter_proportion
FROM
(
    SELECT
        CASE WHEN ascii(left(upper(name), 1)) BETWEEN 65 AND 91 THEN 1 ELSE 0 END AS letter,
        CASE WHEN ascii(left(name, 1)) BETWEEN 48 AND 57 THEN 1 ELSE 0 END AS nums
    FROM accounts
) t;

-- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
SELECT
    SUM(vowel) / (COUNT(*) * 1.0) vowel_proportion,
    SUM(consonant) / (COUNT(*) * 1.0) consonant_proportion
FROM
(
    SELECT
        CASE WHEN left(lower(name), 1) IN ('a', 'e', 'i', 'o', 'u') THEN 1 ELSE 0 END AS vowel,
        CASE WHEN left(lower(name), 1) NOT IN ('a', 'e', 'i', 'o', 'u') THEN 1 ELSE 0 END AS consonant
    FROM accounts
) t;
-----------------------------------------

/** Topics: POSITION, STRPOS

Both these methods are used to find the position of a character in a string.
IMPORTANT:
    - Both of them are 1-indexed.
    - Both are case-sensitive. (To override this, make the column into lower or uppercase using LOWER or UPPER functions)

Syntax:
    - POSITION(char IN col); eg.: POSITION(',' IN city_state)
    - STRPOS(col, char); eg.: STRPOS(city_state, ',')
*/

-- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT
    LEFT(primary_poc, (POSITION(' ' IN primary_poc) - 1)) first_name,
    RIGHT(primary_poc,(
        length(primary_poc) - strpos(primary_poc, ' '))
    ) last_name
FROM accounts
LIMIT 5;

-- Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT
    LEFT(name, (POSITION(' ' IN name) - 1)) first_name,
    RIGHT(name,(
        length(name) - strpos(name, ' '))
    ) last_name
FROM sales_reps
LIMIT 5;
-----------------------------------------
