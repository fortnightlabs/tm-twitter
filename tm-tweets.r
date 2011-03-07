# install the twitteR package if necessary
if(all(rownames(installed.packages()) != 'twitteR')) install.package('twitteR')

# install tm if necessary
if(all(rownames(installed.packages()) != 'tm')) install.package('tm')

# load the libraries
library(twitteR)
library(tm)

# get 100 of gerad's friends
friends <- userFriends('gerad', n=100)

# get the tweets for those friends
tweets = list()
for (friend in friends) tweets <- c(tweets, userTimeline(friend, n=3200))

# create a corpus from the text of those tweets
tweetsCorpus <- Corpus(VectorSource(unlist(Map(statusText, tweets))))

# it's also possible to pick particular parts of speech with tagPOS

# create a term document matrix for the tweets (doing some basic cleanup along the way)
# note that here is where we'd use different weighting functions, for example TfIdf
# we can also use n-grams instead of single words here, and do stemming
tweetsTDM <- TermDocumentMatrix(tweetsCorpus,
  control = list(stopwords = TRUE, tolower = TRUE, removePunctuation = TRUE))

# get the 100 most common words from the TDM
tweetsFrequentWords <- sort(apply(tweetsTDM, 1, sum), decreasing=T)[1:100]

# get the matching tweets for the most frequent word
inspect(tweetsCorpus[apply(tweetsTDM[names(tweetsFrequentWords[1])], 1, function(x) x > 0)])

# other things to play with from here
# findAssocs
# clustering: dissimilarity, hclust, kmeans, cl_agreement, specc
# classiciation: knn, ksvm