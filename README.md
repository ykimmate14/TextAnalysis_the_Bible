### About the [App](https://ykimmate14.shinyapps.io/bible/)

The interactive web applicaton was created with **Shiny** library in R.
The app shows breif exploratory analysis on the Bible. The Bible is King James Version and can be downloaded 
[here](http://www.truth.info/download/bible.htm).

The app has two tabs as below:

* **String Count**   
   The tab shows the user's word of interest and graphically shows its frequency of being referred in the Bible.   
   It contains a table that shows 5 books with the most word count in the Bible.   
   It also shows a pie chart with the 5 books with the most word count and as well as "other" books.  
   Finally it shows two plots (Old Testament and New Testament) which marks where the word of interest can be found in the Bible.
   
* **Word Cloud**  
   The tab shows the [word cloud](https://en.wikipedia.org/wiki/Tag_cloud) of selected book in the Bible.
   Common English words (e.g., A, The, Who, That) are disregarded.

### Requirements

Various R libraries were used to built the application.
The required libraries are as below
```
install.packages(c('igraph', 'stringi', 'XML', 'dplyr', 'rvest', 'tm', 'ggplot', 'wordcloud'))
```
### Possible ways to improve the app

For the **String Count** tab, some labels in the x-axis of the plot are overlapped. It's because the overlapped books have
are relatively short, meaning that the number of verses (or index) between the beginning of each book is small.

For the **Word Cloud** tab, the processing speed could have been faster.
