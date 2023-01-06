# Notes on the course topics

The codes and notes in this repo are taken from / inspired by the [SQL for Data Analysis](https://www.udacity.com/course/sql-for-data-analysis--ud198) course on Udacity. The notes / summary on each topic are in the following files.

1. Basics ➔ [ [notes](./1-basics-summary.md) | [code](/1-basics-practise.pgsql) ]
2. Joins ➔ [ [notes](./2-joins-summary.md) | [code](./2-joins-practise.pgsql) ]
2. Aggregations ➔ [ [notes](./3-aggregations-notes.md) | [code](./) ]
2. Subqueries and Temporary Tables ➔ [ [notes](./4-subqueries-and-temporary-tables-summary.md) | [code](./4-subqueries-and-temporary-tables-summary.md) ]
2. Data Cleaning ➔ [ [notes](./5-data-cleaning-notes.md) | [code part 1](./5-data-cleaning-1.pgsql) | [code part 2](./5-data-cleaning-2.pgsql) ]
2. Window Functions ➔ [ [notes](./6-sql-window-functions-notes.md) | [code](./6-sql-window-functions.pgsql) ]
2. Advanced Joins and Performance Tuning ➔ [ [notes](./7-sql-advanced-joined-performace-tuning-notes.md) | [code](./7-sql-advanced-joined-performace-tuning.pgsql) ]



# Setting up Postgre on Local with VS code

It was painful, but finally done. These are the steps.

## Install Postgre on your local

- First, download the package from [here](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads).
- Install the above package.
- Once installation is done, open the Start menu (on Windows), search for "SQL Shell (psql)", and open it.
- Enter all the defaults. Keep in mind all these values, as they will be needed for VS Code.

By default, these values are:
- server: localhost
- database: postgres
- port: 5432
- username: postgres

And there is also a password prompt. Enter a password and remember it, as it will be needed in VS Code.

## Set this server up on VS Code

- Open VS Code, and install [this](https://marketplace.visualstudio.com/items?itemName=ckolkman.vscode-postgres) extension.
- Once installed, click on the elephant icon on the bottom of the left sidebar. This is the postgre explorer.
- When the postgre explorer opens, click on the + icon on its top right. This will be used for adding the above connection.
- Enter the values asked set above (localhost for hostname, postgres for username, etc.). The password entered above should be entered here as well.
- When prompted between standard and secure connection, choose standard because this is localhost.
- Then choose the database, or show all DBs.

## Executing SQL queries on this DB
- Right click on localhost (or whichever name was supplied to this connection) on the postgre explorer, and click on "New Query".
- On the new file that opens, enter the SQL command, and press F5 from the keyboard to run it.

That's it. It's all set up now. Shoutout to [this](https://www.youtube.com/watch?v=ezjoDYs72GA) YouTube video for explaining this to me.
