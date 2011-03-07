# install the twitteR package if necessary
if(all(rownames(installed.packages()) != 'twitteR')) install.packages('twitteR')

# install tm if necessary
if(all(rownames(installed.packages()) != 'tm')) install.packages('tm')

# install openNLP if necessary
if(all(rownames(installed.packages()) != 'openNLP')) install.packages(c('openNLP', 'openNLPmodels.en'))

# install Snowball if necessary
if(all(rownames(installed.packages()) != 'Snowball')) install.packages('Snowball')

# install RWeka if necessary
if(all(rownames(installed.packages()) != 'RWeka')) install.packages('RWeka')

# load the libraries
library(twitteR)
library(tm)
library(openNLP)
library(RWeka)

# get 100 of gerad's friends
friends <- userFriends('gerad', n=100)

# get the tweets for those friends
tweets <- list()
for (friend in friends) tweets <- c(tweets, userTimeline(friend, n=500))

# get just the text from the tweets (ignore other metadata)
tweetsText <- unlist(Map(statusText, tweets))

# tag the parts of speech in the tweets (not useful)
# tweetsPOS <- tagPOS(tweetsText)

# create a corpus from the text of those tweets
tweetsCorpus <- Corpus(VectorSource(tweetsText))

# create a term document matrix for the tweets (doing some basic cleanup along the way)
# note that here is where we'd use different weighting functions, for example TfIdf
# we can also use n-grams instead of single words here, and do stemming
tweetsTDM <- TermDocumentMatrix(tweetsCorpus,
  control = list(
    # tokenize = tokenize,        # use the opennlp POS tokenizer
    # tokenize = NGramTokenizer,  # use the RWeka NGram tokenizer
    # stemming = TRUE,            # perform word stemming - not working
    stopwords = TRUE,             # remove stopwords
    tolower = TRUE,               # convert terms to lowercase
    removePunctuation = TRUE))    # remove punctuation

# calculate term frequencies
tweetsWordFrequencies <- apply(tweetsTDM, 1, sum)

# TODO figure out how to limit this to just the nouns / proper nouns

# grab the 100 most common terms
tweetsFrequentWords <- sort(tweetsWordFrequencies, decreasing=T)[1:100]

# get the matching tweets for the most frequent word
inspect(tweetsCorpus[apply(tweetsTDM[names(tweetsFrequentWords[1])], 1, function(x) x > 0)])

# find words associated with the second most frequent word - this is slow!
findAssocs(tweetsTDM, names(tweetsFrequentWords[2]), 0.2)

# other things to play with from here
# clustering: dissimilarity, hclust, kmeans, cl_agreement, specc
# classiciation: knn, ksvm