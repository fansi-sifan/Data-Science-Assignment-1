# Assignment_1
Assignment for Introduction to Data Science class

This is the assignment #1 for the class "Introduction to Data Science". I tried to find out whether "news is a downer" or not.

I used the Twitter API to download 6000 tweets from 10 media sources (600 tweets each). The selection of the media sources are based on the popularity (they are the most followed accounts) and relevance (I excluded popular accounts such as "TheEconomist" and "FT" for their high emphasize on economics/finance, similarly, I have replaced "BBCBreaking" with "BBCworld" for the reason that "BBCworld" has a more general and traditional coverage rather than emphasize only on breaking news).The 10 Media Source that I used are

New York Times, NPR News, Washington Post, CNN, Fox News, Huffington Post, BBC World News, Reuters, ABC News and Wall Street Journal

I then analysized the tweets using r, with the main structure similar to what has been taught on Dr.Barbera's workshop. Using a lexicon from Neal Caren of positive and negative words, results from each media accounts were shown. I further conducted an hypothesis test about the difference of the mean of the positive and negative group, and found that under convential significance level we would reject the null hypothesis that news is a downer.(p=0.0206)

A cautinary note that the tweets that I gathered from API is up-to-date so the timing of getting the data might influence the analysis output. I have tried to run the code and to get data during different time of a day, and in different day of the week, and found the statistical significance remain unchanged.

At last, I have drawed line chart using excel and later made an infography to summarize and better present the result.
