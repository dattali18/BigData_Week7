# Big-Data 
# Submitters:
# Daniel Attali: 328780879
#

# Load the libraries

# connecting to the database (Sqlite3)
library(RSQLite) # connecting to the database
library(sqldf) # transforming sql into R dataframes
library(recommenderlab) # recommender system
library(stringr) # string manipulation
library(ggplot2) # plotting
library(qpcR) # quantile regression

# The sqlite database file is called BX_db.sqlite
# The database contains 3 tables: BX_Books, BX_Users, BX_Book_Ratings

# Connect to the database
con <- dbConnect(SQLite(), dbname="BX_db.sqlite")

# test connection
print(dbListTables(con))

