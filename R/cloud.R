# assumptions:
#   images_folder -- contains the name of folder of images we're going to classify
#   r_directory -- the base folder for the R scripts used in this script

is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1])

options(repos = "http://cran.wustl.edu")


if(is.installed("tm") == FALSE)
{
  install.packages("tm")
}

if(is.installed("wordcloud") == FALSE)
{
  install.packages("wordcloud")
}

if(is.installed("RColorBrewer") == FALSE)
{
  install.packages("RColorBrewer")
}

require(tm)
require(wordcloud)
require(RColorBrewer)

args = commandArgs(TRUE)

cloud_path <- args[1]
words_path <- args[2]

data(crude)

#words <- crude

words <- Corpus(URISource(words_path))

words <- tm_map(words, removePunctuation)
words <- tm_map(words, function(x)removeWords(x,stopwords()))

tdm <- TermDocumentMatrix(words)
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)


#pal <- brewer.pal(9,"BuGn")
#pal <- pal[-(1:4)]

pal2 <- brewer.pal(8,"Dark2")

#vfont=c("gothic english","plain")


png(cloud_path, width=900,height=700)

#wordcloud(d$word,d$freq,c(8,.5),2,,FALSE,.1)

#wordcloud(d$word,d$freq,c(8,.3),2,100,TRUE,.15, pal,vfont=c("sans serif","plain"))

#wordcloud(d$word,d$freq,c(8,.3),2,100,TRUE,,.15,pal,vfont=c("serif","plain"))

wordcloud(d$word, d$freq, scale=c(15,.5), min.freq=3, max.words=200, random.order = FALSE, rot.per=.15, colors=pal2, use.r.layout = FALSE)

dev.off()
