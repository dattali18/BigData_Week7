-- the CREATE SCRIPTS FOR THE Sqlite3 database
-- Table structure for BX-Users
CREATE TABLE IF NOT EXISTS "BX-Users" (
  "User-ID" INTEGER NOT NULL,
  "Location" TEXT,
  "Age" INTEGER,
  PRIMARY KEY ("User-ID")
);

-- Table structure for BX-Books
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

-- Table structure for BX-Book-Ratings
CREATE TABLE IF NOT EXISTS "BX-Book-Ratings" (
  "User-ID" INTEGER NOT NULL,
  "ISBN" TEXT NOT NULL,
  "Book-Rating" INTEGER NOT NULL,
  PRIMARY KEY ("User-ID", "ISBN")
);