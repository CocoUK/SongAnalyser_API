### Word cloud

library(wordcloud2)
library(tm)

## create vector containing lyrics
all_lyrics <- paste(unlist(lyric_count$lyrics), collapse =" ")

# create corpus
docs <- Corpus(VectorSource(all_lyrics))

#clean data
docs <- docs %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))

##document term matrix
dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)

## Generate the world cloud
wordcloud2(data=df, size=1.6, color='random-dark')
