# Big-Data Week 7

## Requirements

1. Process the `MySQL` dump files and convert into `Sqlite` format
   - (Optional) transform into `.csv` format
2. Create a DB into `Sqlite` and import the data
3. Make some queries to the DB (using `R` and/or `SQL`)
4. Create a Recommendation system based on the data

## DB Schema

### BX-Users

```sql
CREATE TABLE IF NOT EXISTS "BX-Users" (
  "User-ID" INTEGER NOT NULL,
  "Location" TEXT,
  "Age" INTEGER,
  PRIMARY KEY ("User-ID")
);
```

### BX-Books

```sql
CREATE TABLE IF NOT EXISTS "BX-Books" (
  "ISBN" TEXT NOT NULL,
  "Book-Title" TEXT,
  "Book-Author" TEXT,
  "Year-Of-Publication" INTEGER,
  "Publisher" TEXT,
  "Image-URL-S" TEXT,
  "Image-URL-M" TEXT,
  "Image-URL-L" TEXT,
  PRIMARY KEY ("ISBN")
);
```

### BX-Book-Ratings

```sql
CREATE TABLE IF NOT EXISTS "BX-Book-Ratings" (
  "User-ID" INTEGER NOT NULL,
  "ISBN" TEXT NOT NULL,
  "Book-Rating" INTEGER NOT NULL,
  PRIMARY KEY ("User-ID", "ISBN")
);
```

## Queries

```sql
-- a. How many users?
select count(*) from BX_db.BX_Users;
-- b. How many books?
select count(*) from BX_db.BX_Books;
-- c. How many ratings?
select count(*) from BX_db.BX_Book_Ratings;

-- d. Histogram of user-ratings (how many users have rated N times?)
create view temp as select count(*) as num_ratings
from BX_db.BX_Users natural join BX_db.BX_Book_Ratings
group by User_ID
order by count(*);

select num_ratings, count(*) as bin_size
from temp
group by num_ratings
order by num_ratings;


-- e. Histogram of book-ratings (how many books have been rated N times?)
create view booksHistogram as select count(*) as num_ratings
from BX_db.BX_Book_Ratings
group by ISBN
order by count(*);

select num_ratings, count(*) as bin_size
from booksHistogram
group by num_ratings
order by num_ratings;

-- f. Top-10 rated books?
select Book_Title, count(Book_Rating)
from BX_db.BX_Books natural join BX_db.BX_Book_Ratings
group by ISBN
order by count(Book_Rating) desc
limit 10;

-- g. Top-10 active users?
select rating.User_ID as name, count(User_ID) as N
from BX_db.BX_Book_Ratings rating
group by rating.User_ID
order by count(*) desc
limit 0, 10;
```

## Recommendation System

Since the amount of data is very big (hence the name of the course), we need to take into account the amount of available memory. For this reason, we will use a `memory-based` recommendation system. such that any operation that would take too much memory would be performed locally. for example for matrix multiplication we can you matrix tailing to reduce the amount of memory used.
