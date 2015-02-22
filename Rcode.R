##################################################################
## PPOL 670-Introduction to Data Science, Professor Gaurav Sood ##
## Assignment #1 "Is News A Downer?"                            ##
## Yuqi Liao                                                    ##
## February 19th, 2015                                          ##
##################################################################

#####################
### PREPARATION   ###
#####################

## Setting Working Directory
setwd("/Users/apple/Desktop/MSPP/2nd-Semester Course/PPOL 670-Introduction to Data Science/Assignment_1")

## Installing Packages that will be needed for the analysis
doInstall <- TRUE
toInstall <- c("ROAuth", "twitteR", "streamR","RCurl","bitops")

if(doInstall){install.packages(toInstall, repos = "http://cran.r-project.org")}

## Creating Oauth Token 
## (Going to apps.twitter.com and succesfully registering an application, geting consuemr key and consumer secret)
library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "zlmGorqcHXMObGaOhkuddU5PS"
consumerSecret <- "nxzVJuUNqkUJeW4jHVXdnChLUfwEbysp0RoFb7YUztTabLgn1j"

my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret, requestURL=requestURL,
                             accessURL=accessURL, authURL=authURL)

## Authorize the app by going to the web brower and entering the PIN to the console
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

## Testing if it works, if yes, continuing with the progress
library(twitteR)
setup_twitter_oauth(consumerKey, consumerSecret)
searchTwitter('yuqi', n=5)

## Saving oauth token for future use
save(my_oauth, file="oauth_token.Rdata")

############################################################
### DOWNLOADING RECENT TWEETS FROM 10 MEDIA SOURCE USERS ###
############################################################

###############################################
### The 10 Media Source that I will use are ###
### nytimes nprnews washingtonpost CNN      ###
### foxnews huffingtonpost BBCWorld         ###
### Reuters ABC WSJ                         ###
###############################################

account_names <- c("nytimes","nprnews","washingtonpost","CNN","foxnews","huffingtonpost",
                   "BBCWorld","Reuters","ABC","WSJ")

## Using the function wrtitten by Pablo Barbera to capture the most recent tweets 
## and store the raw JSON data
source("functions.r")

for(i in 1:10){name <- paste("tweets", i, ".json", sep = "")
               getTimeline(filename=name, screen_name=account_names[i], 
                           n=500, oauth=my_oauth, trim_user="false")
                }

## Loading tweets that are just created and stored
library(streamR)

for (i in 1:10){name <- paste("tweets", i, ".json", sep = "")
                assign(paste("tweets", i, sep = ""), parseTweets(name))
                }

##########################
### SENTIMENT ANALYSIS ###
##########################

## Loading lexicon from Neal Caren of positive and negative words
lexicon <- read.csv("lexicon.csv", stringsAsFactors=F)
pos.words <- lexicon$word[lexicon$polarity=="positive"]
neg.words <- lexicon$word[lexicon$polarity=="negative"]

## Defining a function to clean the text
clean_tweets <- function(text){
  ## Loading required packages
  lapply(c("tm", "Rstem", "stringr"), require, c=T, q=T)
  # Avoid encoding issues by dropping non-unicode characters
  utf8text <- iconv(text, to='UTF-8-MAC', sub = "byte")
  # Remove punctuation and convert to lower case
  words <- removePunctuation(utf8text)
  words <- tolower(words)
  # Spliting in words
  words <- str_split(words, " ")
  return(words)
  }


## Cleaning the tweets
text1 <- clean_tweets(tweets1$text)
text2 <- clean_tweets(tweets2$text)
text3 <- clean_tweets(tweets3$text)
text4 <- clean_tweets(tweets4$text)
text5 <- clean_tweets(tweets5$text)
text6 <- clean_tweets(tweets6$text)
text7 <- clean_tweets(tweets7$text)
text8 <- clean_tweets(tweets8$text)
text9 <- clean_tweets(tweets9$text)
text10 <- clean_tweets(tweets10$text)


## Defining a function to classify individual tweets
classify <- function(words, pos.words, neg.words){
  # Counting number of positive and negative word matches
  pos.matches <- sum(words %in% pos.words)
  neg.matches <- sum(words %in% neg.words)
  return(pos.matches - neg.matches)
  }

## Defining another function using the function "classify" to aggregate over many tweets
classifier <- function(text, pos.words, neg.words){
  ## Classifier
  scores <- unlist(lapply(text, classify, pos.words, neg.words))
  n <- length(scores)
  positive <- as.integer(length(which(scores>0))/n*100)
  negative <- as.integer(length(which(scores<0))/n*100)
  neutral <- 100 - positive - negative
  cat(n, "tweets:", positive, "% positive,",
      negative, "% negative,", neutral, "% neutral")
  }

## Applying classifier function and getting the result for each twitter account
classifier(text1, pos.words, neg.words)
classifier(text2, pos.words, neg.words)
classifier(text3, pos.words, neg.words)
classifier(text4, pos.words, neg.words)
classifier(text5, pos.words, neg.words)
classifier(text6, pos.words, neg.words)
classifier(text7, pos.words, neg.words)
classifier(text8, pos.words, neg.words)
classifier(text9, pos.words, neg.words)
classifier(text10, pos.words, neg.words)
