-- a. How many users?
SELECT COUNT(*) FROM BX_Users;

-- b. How many books?
SELECT COUNT(*) FROM BX_Books;

-- c. How many ratings?
SELECT COUNT(*) FROM BX_Book_Ratings;

-- d. Histogram of user-ratings (how many users have rated N times?)
-- delete the view if exists so there is no error
DROP VIEW IF EXISTS temp;

CREATE VIEW temp AS 
SELECT COUNT(*) AS num_ratings
FROM BX_Users 
NATURAL JOIN BX_Book_Ratings
GROUP BY "User-ID"
ORDER BY COUNT(*);

SELECT num_ratings, COUNT(*) AS bin_size
FROM temp
GROUP BY num_ratings
ORDER BY num_ratings;

-- e. Histogram of book-ratings (how many books have been rated N times?)
DROP VIEW IF EXISTS booksHistogram;

CREATE VIEW booksHistogram AS 
SELECT COUNT(*) AS num_ratings
FROM BX_Book_Ratings
GROUP BY "ISBN"
ORDER BY COUNT(*);

SELECT num_ratings, COUNT(*) AS bin_size
FROM booksHistogram
GROUP BY num_ratings
ORDER BY num_ratings;

-- f. Top-10 rated books?
SELECT "Book-Title", COUNT("Book-Rating") AS rating_count
FROM BX_Books 
NATURAL JOIN BX_Book_Ratings
GROUP BY "ISBN"
ORDER BY rating_count DESC
LIMIT 10;

-- g. Top-10 active users?
SELECT "User-ID", COUNT("User-ID") AS N
FROM BX_Book_Ratings
GROUP BY "User-ID"
ORDER BY N DESC
LIMIT 10;
