
library(testthat)

test_that(
  "Checing for count lyrics",
  {
    expect_equal(song_lyrics("queen", "liar")$word_count,316)
    expect_equal(song_lyrics("queen", "my fairy king")$word_count,230)
    expect_equal(song_lyrics("kylie Minogue", "spinning around")$word_count,313)
    expect_equal(song_lyrics("kylie Minogue", "turn it into love")$word_count,149)
    expect_equal(song_lyrics("Enrique Iglesias", "Bailamos")$word_count,142)
  }
)

