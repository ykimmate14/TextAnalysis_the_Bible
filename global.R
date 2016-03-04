library(igraph); library(stringi); library(XML); library(dplyr); library(rvest)
library(tm); library(ggplot2)
library(wordcloud)

# processing the text data
bibledf <- scan("bible.txt", character(0), sep = "\n")

TClist <- list()
for(i in 1:length(bibledf)){
    TClist <- c(TClist, unlist(strsplit(bibledf[i], "\t"))[1])
}
TClist <- unlist(TClist)

verselist <- list()
for(i in 1:length(bibledf)){
    verselist <- c(verselist, sub(paste(TClist[i], "\t", sep = ""), "", bibledf[i]))
}
verselist <- unlist(verselist)

## reading the books of the bible from wiki; just for fun.
titleURL <- read_html("https://en.wikipedia.org/wiki/List_of_books_of_the_King_James_Version")
bookTitle <- titleURL %>%
    html_nodes("td:nth-child(1) > a") %>%
    html_text()
bookTitle[40:44] <- c("Matthew", "Mark", "Luke", "John", "Acts")

titleindex <- data.frame()
for(i in 1:length(bookTitle)){
    titleindex <- rbind(titleindex, data.frame(title = bookTitle[i], min = min(grep(bookTitle[i], TClist)), 
                                               max = max(grep(bookTitle[i], TClist))))
}
titleindex$title <- as.character(titleindex$title)

# word cloud
wcplot <- function(book){
    verse <- verselist[titleindex[titleindex$title == book, 2] : titleindex[titleindex$title == book, 3]]
    myCorpus <- Corpus(VectorSource(verse))
    myCorpus <- tm_map(myCorpus, tolower)
    myCorpus <- tm_map(myCorpus, removePunctuation)
    myCorpus <- tm_map(myCorpus, removeNumbers)
    myCorpus <- tm_map(myCorpus, removeWords, 
                       c(stopwords("english"),"unto"," thee", "thy", "shall", "thou", "thine"))
    myCorpus <- tm_map(myCorpus, PlainTextDocument)
    myDTM = TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))
    m <- as.matrix(myDTM)
    v = sort(rowSums(m), decreasing = TRUE)
    set.seed(1)
    wordcloud(names(v[1:50]), v[1:50], colors = brewer.pal(8, "Dark2"))
}

# high density plot that shows frequency of the word of interest
OTfreqPlot <- function(txt){
    text <- paste0("\\<", txt, "\\>")
    old.t.index <- 1:titleindex$max[titleindex$title == bookTitle[39]]
    str_grep <- grepl(gsub("\\)", "", (gsub("\\(", "", text))), verselist[old.t.index], ignore.case = TRUE)
    str_count <- rep(NA, length(verselist[old.t.index]))
    str_count[str_grep] <- 1
    plot(str_count, main=sprintf("The word of interest: %s", txt), 
         xlab= '', ylab=sprintf("Total string count: %d", sum(str_grep)), type="h", ylim=c(0,1), yaxt='n', xaxt='n') +
        axis(1, at = titleindex$min[1:39], labels = titleindex$title[1:39], cex.axis=1.0, las=2)
}
NTfreqPlot <- function(txt){
    text <- paste0("\\<", txt, "\\>")
    new.t.index <- titleindex$min[titleindex$title == bookTitle[40]]:length(bibledf)
    str_grep <- grepl(gsub("\\)", "", (gsub("\\(", "", text))), verselist[new.t.index], ignore.case = TRUE)
    str_count <- rep(NA, length(verselist[new.t.index]))
    str_count[str_grep] <- 1
    plot(str_count, main=sprintf("The word of interest: %s", txt), 
         xlab= '', ylab=sprintf("Total string count: %d", sum(str_grep)), type="h", ylim=c(0,1), yaxt='n', xaxt='n')
    axis(1, at = titleindex$min[40:66]-23145, labels = titleindex$title[40:66], cex.axis=1.0, las=2)
}

#Table shows top 5 books that have most string count 
freqTable <- function(txt){
    dt <- titleindex
    countlist <- integer()
    text <- paste0("\\<", txt, "\\>")
    for(i in 1:nrow(dt)){
        index <- dt$min[i]:dt$max[i]
        countlist <- c(countlist, sum(grepl(gsub("\\)", "", (gsub("\\(", "", text))), verselist[index], ignore.case = TRUE)))
    }
    dt <- cbind(dt, countlist)
    dt <- dt[,c(1,4)]
    dt <- dt[order(-countlist),]
    names(dt) <- c("Book", "word.count")
    dt.first5 <- rbind(dt[1:5,], c("Other", sum(dt[6:nrow(dt),2])))
    dt.first5$word.count <- as.integer(dt.first5$word.count)
    rownames(dt.first5) <- NULL
    dt.first5
}

