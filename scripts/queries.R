library(DBI)
library(RSQLite)

# Connect to SQLite database
con <- dbConnect(RSQLite::SQLite(), "BX_db.sqlite")


# Check the number of records in each table

users.length <- dbGetQuery(con, "SELECT COUNT(*) FROM 'BX-Users'")
books.length <- dbGetQuery(con, "SELECT COUNT(*) FROM 'BX-Books'")
ratings.length <- dbGetQuery(con, "SELECT COUNT(*) FROM 'BX-Book-Ratings'")

# a. Number of users
print(paste("number of users: ", users.length))
# b. Number of books
print(paste("number of books: ", books.length))
# c. Number of ratings
print(paste("number of ratings: ", ratings.length))

# d. Histogram of user-ratings (how many users have rated N times?)
dbExecute(con, "DROP VIEW IF EXISTS userHistogram;")
dbExecute(con, "CREATE VIEW userHistogram AS
SELECT COUNT(*) AS num_ratings
FROM 'BX-Users'
NATURAL JOIN 'BX-Book-Ratings'
GROUP BY 'User-ID'
ORDER BY COUNT(*);")

histogram.user.ratings <- dbGetQuery(con, "SELECT num_ratings, COUNT(*) AS bin_size FROM userHistogram GROUP BY num_ratings ORDER BY num_ratings;")

dbExecute(con, "DROP VIEW userHistogram;")

print("Histogram of user-ratings:")
print(histogram.user.ratings)

# e. Histogram of book-ratings (how many books have been rated N times?)

dbExecute(con, "DROP VIEW IF EXISTS booksHistogram;")

dbExecute(con, "CREATE VIEW booksHistogram AS
SELECT ISBN, COUNT(*) AS num_ratings
FROM 'BX-Books'
NATURAL JOIN 'BX-Book-Ratings'
GROUP BY ISBN
ORDER BY COUNT(*);")

histogram.books.ratings <- dbGetQuery(con, "SELECT num_ratings, COUNT(*) AS bin_size FROM booksHistogram GROUP BY num_ratings ORDER BY num_ratings;")

dbExecute(con, "DROP VIEW booksHistogram;")

print("Histogram of book-ratings:")
print(histogram.books.ratings)


# f. Top-10 rated books?
top.books <- dbGetQuery(con, "SELECT 'Book-Title', COUNT('Book-Rating') AS rating_count
FROM 'BX-Books'
NATURAL JOIN 'BX-Book-Ratings'
GROUP BY 'ISBN'
ORDER BY rating_count DESC
LIMIT 10;")

print("Top-10 rated books:")
print(top.books)

# g. Top-10 rated users?
top.users <- dbGetQuery(con, "SELECT 'User-ID', COUNT(*) AS num_ratings FROM 'BX-Users' NATURAL JOIN 'BX-Book-Ratings' GROUP BY 'User-ID' ORDER BY num_ratings DESC LIMIT 10;")

print("Top-10 rated users:")
print(top.users)

# Disconnect when done
dbDisconnect(con)
