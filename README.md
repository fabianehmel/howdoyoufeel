How do you feel?
============

„How do you feel?“ is a application based on [Processing](http://processing.org).

It reads tweets for a specified grographic region from the Twitter Streaming API with help of [twitter4j](http://org). The app calculates an semantic score based on the text for ever tweet (see SentimentAnalyzer.pde). For that purpose, it uses the [sentimenal dictionary by Warriner et.al.](http://crr.ugent.be/archives/1003).

The app visualizes the tweets and their sentiment on a map view and prints the latest tweets on the screen.

![Screenshot](https://github.com/fabianehmel/howdoyoufeel/blob/master/screenshot.png)