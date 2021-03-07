###  Air logic test with functions

source("functions.R")
##User inputs artist
artist <- "Kylie Minogue"




#####################



# Search for artist mdid
id <- artist_mbid(artist)
if(is.na(id))  stop("No Artist found")
# extract a number of albums
albums <- artist_albums(id, 5)
# extracts tracks per albums
artist_data <- album_tracks(albums)
print(paste("Songs by", artist))
print( artist_data[,c("title","album")])  #check

# titles of songs
titles <- Song_titles(artist_data)
# Results lyrics and wordcount
lyric_count <- song_lyrics(artist, titles)

print(paste("Number of words in" , artist, "songs"))
print(lyric_count[,c("title","word_count")])  #check


df <- artist_stats(artist_data, lyric_count)
print(paste("Average number of words by" , artist, "albums"))
print(as.data.frame(df)) #check
avg_words <- get_summary_stats(lyric_count, "word_count", type= "mean_sd")
print(paste("Average number of words by" , artist))
print(as.data.frame(avg_words))  #check

print(artist_wordcloud(lyric_count))
