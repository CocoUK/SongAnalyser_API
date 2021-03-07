
library(musicbrainz)
library(dplyr)
library(stringr)
library(R.utils)
library(rstatix)
library(wordcloud2)
library(tm)

###Functions
## Returns artist mbid number
artist_mbid <- function(x){
  artist <- gsub(" ", "%20", x)
  artist_df <- search_artists(artist)
  artist_id <- artist_df %>%
    select(mbid) %>%
    slice(1) %>%
    pull()
  
  return(artist_id)
}

#Returns artists albums based on artist_mbid
artist_albums <- function ( mbid, no_albums){
  artist_release <- browse_releases_by("artist", mbid, limit = 10)
  albums <- artist_release %>%
    select(title, mbid)%>%
    distinct( title, .keep_all = TRUE)
  return(head(albums, no_albums))
}

## Returns tracks in each album based on album mbid
album_tracks <- function (albums) {
  purrr::map2_df(albums$mbid,  albums$title, function(x, y) { 
    cbind(browse_recordings_by('release', x), album = y)
  })
  
}

## Function extract song titles
Song_titles <- function (artist_data){
  title <- artist_data %>%
    select(title) %>%
    slice(1:1000) %>%
    pull()
  
  title <- title %>% tolower() %>% unique()
  
  return(title)
  
}


##Extract lyrics of songs and count words

song_lyrics <- function (artist, title){
  
  root_url <- "https://api.lyrics.ovh/v1/"
  artist <- gsub(" ", "%20", artist)
  ## replace space for %20 in song title
  title <- gsub(" ", "%20", title)
  all_urls <- paste0(root_url,artist,"/",title)
  ##  Get all song lyrics and count words
  cbind(title, purrr::map_df(all_urls, function(my_url) {
    my_content_from_json <- withTimeout(jsonlite::fromJSON(my_url)$lyrics, timeout = 5, onTimeout = "silent")
    if(is.null(my_content_from_json)) return(data.frame(lyrics = NA, word_count = NA))
    lyrics <- gsub("[\r\n]", " ", my_content_from_json)
    #Remove words in '[]' in the lyrics.
    lyrics <- gsub('\\[.*?]', '', lyrics)
    lyrics <- str_squish(lyrics)
    word_count <- str_count(lyrics, '\\s+') + 1
    #If lyrics has word 'Instrumental' turn word count to NA.
    if(grepl('Instrumental', lyrics, ignore.case = TRUE)) word_count <- NA
    data.frame(  lyrics, word_count)
  })) -> result
  #Rewrite song titles
  result %>%
    mutate(title = gsub('%20', ' ', title, fixed = TRUE)) %>%
    left_join(albums, by = 'title') -> result
}

###
artist_stats <- function(artist_data, result){
  ## Join dataframe with albums, songs, lyrics and wordcount
  artist_data$title <- tolower(artist_data$title)
  df <- as.data.frame(inner_join(artist_data, result,  by= "title"))[,c("title","album","lyrics","word_count")]
  df$word_count <- as.numeric(df$word_count)
  
  df_summary <- df %>%
    group_by(album) %>%
    get_summary_stats("word_count",type = "mean_sd")
  
  
  return(df_summary)
}

###  wordcloud function
artist_wordcloud <- function (lyric_count){
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
}





