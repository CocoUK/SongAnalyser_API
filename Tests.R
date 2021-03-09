 
library(testthat)
library(readxl)

test_that(
  "Checing for count lyrics",
  {
    expect_equal(song_lyrics("queen", "liar")$word_count,316)
    expect_equal(song_lyrics("queen", "my fairy king")$word_count,230)
    expect_equal(song_lyrics("kylie Minogue", "spinning around")$word_count,313)
    expect_equal(song_lyrics("kylie Minogue", "turn it into love")$word_count,138)
    expect_equal(song_lyrics("Enrique Iglesias", "Bailamos")$word_count,142)
    expect_equal(song_lyrics("Queen", "procession")$word_count,NA)
})

# Tests artists stats function

### Load test data from file
test_data <- "C:/Users/me1gae/Documents/SongAnalyser_API/test.xlsx"
data <- read_excel(path = test_data, sheet = "artist_data")
count <- read_excel(path = test_data, sheet = "lyric_count")
df <- read_excel(path = test_data, sheet = "df")
                          

test_that(
  "Checing for summary of statistics",
  {
    expect_equal(round(artist_stats(data, count)$mean,0),round(df$mean,0))
 
  })
 

 
