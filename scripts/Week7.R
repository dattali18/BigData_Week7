# Submitters:
# 1. Daniel Attali 328780879
# 2. Omer Avidar
# 3. Noam Benishu
# 4. Ouriel Mangisto

# This script will take the data dump from a MySQL DB and will parse it for Sqlite3 DB

# there are 3 files in the BX_MySQL_Inserts folders
# 1. BX-Users_Insert.sql
# 2. BX-Books_Insert.sql
# 3. BX-Book-Ratings_Insert.sql

# This script does the following:
#   Reads the MySQL dump file.
# Defines a function convert_insert that:
#   Replaces 'INSERT IGNORE' with 'INSERT OR IGNORE'
# Replaces single quotes with double quotes
# Escapes single quotes within strings
# Removes backticks around table and column names
# Applies the conversion to each line of the dump file.
# Writes the converted statements to a new file.
# Optionally wraps the INSERT statements in a transaction for better performance.

convert_insert <- function(origin_path, output_path) {
  mysql_dump <- readLines(origin_path)
  
  # check for errors
  if (length(mysql_dump) == 0) {
    stop("The file is empty")
  }
  
  convert_line <- function(line) {
    if(length(line) == 0) {
      return(line)
    }
    
    if(grepl("^INSERT", line)) {
      # replace 'INSERT IGNORE' with 'INSERT OR IGNORE'
      line <- gsub("INSERT IGNORE", "INSERT OR IGNORE", line)
      
      # replace single quotes with double quotes
      line <- gsub("'", "\"", line)
      
      # escape single quotes within strings
      line <- gsub("\"([^\"]*)\"([^\"]*)\"([^\"]*)\"", "\"\\1''\\2\"\\3\"", line)
      
      # remove backticks around table and column names
      line <- gsub("`", "", line)
    }
    return(line)
  }
  
  # apply the conversion to each line of the dump file
  converted_dump <- sapply(mysql_dump, convert_line)
  
  # write the converted statements to a new file
  writeLines(converted_dump, output_path)
  
  return(converted_dump)
}

# convert the files

insert_folder <- file.path("BX_MySQL_Inserts")

# users file
users_origin_path <- file.path(insert_folder, "BX-Users_Insert.sql")

users_output_path <- file.path(insert_folder, "BX-Users_Insert-converted.sql")

users_converted <- convert_insert(users_origin_path, users_output_path)

# books file
books_origin_path <- file.path(insert_folder, "BX-Books_Insert.sql")

books_output_path <- file.path(insert_folder, "BX-Books_Insert-converted.sql")

books_converted <- convert_insert(books_origin_path, books_output_path)

# ratings file
ratings_origin_path <- file.path(insert_folder, "BX-Books-Ratings_Insert.sql")

ratings_output_path <- file.path(insert_folder, "BX-Books-Ratings_Insert-converted.sql")

ratings_converted <- convert_insert(ratings_origin_path, ratings_output_path)