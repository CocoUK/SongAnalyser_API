<h1> Song Lyric Analyser </h1>

Analysis of artist's lyrics, provides the number of words in an artist's lyrics, summarises average number of words in the lyrics of an album, and makes a wordcloud of the artist lyrics.
It uses two APIs to extract the names of songs, album tracks and lyrics. The album names and songs are extracted from [musicbrainz](https://musicbrainz.org) and the song lyrics from [lyricsovh](https://lyricsovh.docs.apiary.io/).

<h1> Dependencies </h1>

The following R packages are needed to run SongAnalyser_API

* musicbrainz
* dplyr
* stringr
* R.utils
* rstatix
* wordcloud2
* tm

<h1> Files </h1>

All functions can be found in the functions.R file.  The main script is in the ArtistLyricAnalyser file. Edit the artist name e.g. "Kylie Minogue" and source the code. Voila! Some song information will appear followed by the artist's wordcloud.


Some test for the song_lyrics function that counts the number of words in the lyrics are provided in the test.R file. Additionally, a test for the summary of statistics function is given. The test data for this function is in an excel file "Test.xlsx".

<h1> Shiny App </h1>
A lightweight version of the code was implemented in a [Shiny App](https://cocouk.shinyapps.io/Artist_Lyrics_Analyser).

<h1> Things to do </h1>
There are a lot of things to do to make this project nice:

* Error handling for not finding artist songs
* Upgrading the Shiny app
* Extracting lyrics from a different database (genius for example)
* Comparing artists
* Add cache system to check previous serches


and of course, more testing!


