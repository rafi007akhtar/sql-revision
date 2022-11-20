-- NOTE: in many the statements below, I am limiting only cause the # rows are too many.

/**
Data cleaning is used to:
- clean and restructure messy data
- convert columns to different data types
- manipulating NULLs
*/

/** Topic: CAST

The CAST function converts a value from datatype to another.

Syntax 1:
CAST(val AS target_datatype); eg.: CAST('1.5' AS DOUBLE);

Syntax 2:
val::target_datatype; eg.: '2010-05-11'::DATE;

Also TO_DATE function is used to convert a date-like string into date.
Like: TO_DATE('2010-1-9') would result in the date 2010-01-09.
*/

-- For the following statements, use the crime dataset.

--  Write a query to look at the top 10 rows to understand the columns and the raw data in the dataset called.
SELECT * FROM sf_crime_data LIMIT 10;

--  Write a query to change the date into the correct SQL date format. You will need to use at least SUBSTR and CONCAT to perform this operation.
-- Once you have created a column in the correct format, use either CAST or :: to convert this to a date. 
SELECT
    date_part('year', date) || '-'
    || date_part('month', date) || '-'
    || date_part('day', date) AS new_date,
    CAST(date_part('year', date) || '-'
    || date_part('month', date) || '-'
    || date_part('day', date) AS date) AS parsed_date
FROM sf_crime_data LIMIT 10;


