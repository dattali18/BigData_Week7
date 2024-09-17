library(DBI)
library(RSQLite)

# Connect to SQLite database
con <- dbConnect(RSQLite::SQLite(), "BX_db.sqlite")


# Check the number of records in each table
print(dbGetQuery(con, "SELECT COUNT(*) FROM 'BX-Users'"))
print(dbGetQuery(con, "SELECT COUNT(*) FROM 'BX-Books'"))
print(dbGetQuery(con, "SELECT COUNT(*) FROM 'BX-Book-Ratings'"))

# Disconnect when done
dbDisconnect(con)
