# ******************************** 1. Load the Data into R  ********************************


# Load necessary libraries
library(RSQLite)
library(sqldf)
library(recommenderlab)
library(ggplot2)

# Connect to the SQLite database
con <- dbConnect(SQLite(), dbname = "BX_db.sqlite")

# Load tables into R
users <- dbGetQuery(con, "SELECT * FROM 'BX-Users'")
books <- dbGetQuery(con, "SELECT * FROM 'BX-Books'")
ratings <- dbGetQuery(con, "SELECT * FROM 'BX-Book-Ratings'")

# ***************************** 2. Data Exploration and Preprocessing  **************************

# Filter ratings to only include valid entries
ratings <- sqldf("SELECT * FROM ratings WHERE Book-Rating > 0 AND Book-Rating <= 10")

# Filter users and books with at least 30 ratings
books_with_ratings <- sqldf("SELECT ISBN FROM ratings GROUP BY ISBN HAVING COUNT(*) > 30")
users_with_ratings <- sqldf("SELECT 'User-ID' FROM ratings GROUP BY 'User-ID' HAVING COUNT(*) > 30 AND COUNT(*) < 300")

# Keep only these ratings
ratings <- sqldf("SELECT * FROM ratings WHERE 'User-ID' IN users_with_ratings AND ISBN IN books_with_ratings")

# ******************************** 3. Statistics and Histograms  *******************************

# Number of users, books, and ratings
num_users <- nrow(users)
num_books <- nrow(books)
num_ratings <- nrow(ratings)

print(cat("Number of users:", num_users))
print(cat("Number of books:", num_books))
print(cat("Number of ratings:", num_ratings))

plot_output_file <- file.path("output" ,"ratings_histograms.pdf")

pdf(plot_output_file)

# Histogram of ratings by user
user_ratings_hist <- sqldf("SELECT COUNT('User-ID') AS ratings_per_user FROM ratings GROUP BY 'User-ID'")
ggplot(user_ratings_hist, aes(x = ratings_per_user)) +
    geom_histogram(binwidth = 5, fill = "blue") +
    ggtitle("Histogram of Ratings by Users")

# Histogram of ratings by book
book_ratings_hist <- sqldf("SELECT COUNT(ISBN) AS ratings_per_book FROM ratings GROUP BY ISBN")
ggplot(book_ratings_hist, aes(x = ratings_per_book)) +
    geom_histogram(binwidth = 5, fill = "green") +
    ggtitle("Histogram of Ratings by Books")

dev.off()

# ******************************** 4. Top-10 Books and Users *********************************

# Top-10 rated books
top_books <- sqldf("SELECT ISBN, COUNT(*) AS num_ratings FROM ratings GROUP BY ISBN ORDER BY num_ratings DESC LIMIT 10")
top_books <- merge(top_books, books, by = "ISBN")
print(top_books[, c("Book-Title", "num_ratings")])

# Top-10 active users
top_users <- sqldf("SELECT 'User-ID', COUNT(*) AS num_ratings FROM ratings GROUP BY 'User-ID' ORDER BY num_ratings DESC LIMIT 10")
print(top_users)

# *********************** 5.  Build a Recommender System *************************

# Convert the ratings data into a matrix for the recommender system
rating_matrix <- as(ratings, "realRatingMatrix")

# Create 5-fold cross-validation evaluation sets
eval_sets <- evaluationScheme(rating_matrix, method = "cross-validation", train = 0.8, k = 5)

# Train a UBCF (User-based collaborative filtering) model
ubcf_model <- Recommender(getData(eval_sets, "train"), method = "UBCF")

# Generate recommendations for the test set
predictions <- predict(ubcf_model, getData(eval_sets, "known"), type = "ratings")

# ************************************ 6. Evaluate the Recommender System ************************************

# Calculate prediction accuracy
accuracy <- calcPredictionAccuracy(predictions, getData(eval_sets, "unknown"))
print(accuracy)

# RMSE for the model
print(paste("RMSE:", accuracy["RMSE"]))

# ************************************ 7. Save Results to CSV ************************************

# Save predictions to a CSV file
top_n_predictions <- predict(ubcf_model, getData(eval_sets, "known"), n = 10)
predictions_list <- as(top_n_predictions, "list")

write.csv(predictions_list, "recommendations.csv")
