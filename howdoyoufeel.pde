// IMPORTS
import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;
import twitter4j.TwitterStreamFactory;
import processing.pdf.*;


// GLOBAL VARS
PImage backgroundmap;              // Variable für die Karte
ArrayList<Tweet> tweets;           // Variable zur Speicherung der Tweets
boolean record;                    // Variable für das Anschalten des Aufnahmemodus
double swLon, swLat, neLon, neLat;  // Variablen für die Stadtgrenzen
ArrayList<String> lastTweets;  // Variable zur Speicherung der letzten 20 Tweets - Textausgabe
PFont aleoReg, aleoBold;  // Variable zur Speicherung der Font
String cityname;  // Var for the city-name


// SETUP
void setup() {
    
  // Basiseinstellungen für den gewünschten Ort
  
  // Deutschland
  // swLon = 5.866240; swLat = 47.270210; neLon = 15.042050; neLat = 55.058140;
  // Berlin
  // swLon = 13.0882097323; swLat = 52.3418234221; neLon = 13.7606105539; neLat = 52.6697240587;
  // London
  neLat = 51.692322; neLon = 0.334030; swLat = 51.286839; swLon = -0.51035; backgroundmap = loadImage("london.png"); cityname = "London";
  // SF
  //swLat = 37.6933508; neLat = 37.9298443; swLon = -123.1077878; neLon = -122.2817799; backgroundmap = loadImage("sf.png"); cityname = "San Francisco";
  
  // Erstelle einen SentimentAlayzer, um diesen später für jeden Tweet zu nutzen.
  final SentimentAnalyzer sa = new SentimentAnalyzer();
      
  //size(backgroundmap.width, backgroundmap.height);
  size(displayWidth, displayHeight);
  
  // ArrayList zur Speicherung der Tweets
  tweets = new ArrayList<Tweet>();
  lastTweets = new ArrayList<String>();

  // Verbindungskunfiguration für die Twitter API (Account kann unter dev.twitter.com) erstellt werden
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("");    // Hier ConsumerKey eintragen
  cb.setOAuthConsumerSecret(""); // Hier ConsumerSecret eintragen
  cb.setOAuthAccessToken("");  // Hier AccessToken eintragen
  cb.setOAuthAccessTokenSecret("");  // Hier AccessTokenSecret eintragen
  
  // Anfrage an API formulieren
  FilterQuery query = new FilterQuery();
  // Suche nach Sprachen beschraenken
  String[] lang = {"en"};
  query.language(lang);
  // Suche auf Stadtbereich beschraenken
  double[][] bb = {{swLon, swLat}, {neLon, neLat}};
  query.locations(bb);
  // Nach Stichwoertern suchen
  //String[] keywords = {"Search Phrase"};
  //query.track(keywords);
  
  // Erstelle einen neuen StatusListener (aus twitter4j)
  StatusListener listener = new StatusListener() {
    
    // Wenn Status (Tweet) gefunden
    public void onStatus(Status status) {
      // Wenn Status Inhalt enthält
      if (status.getGeoLocation() != null) {
        GeoLocation geo = status.getGeoLocation();  // GeoLocation auslesen
        float lat = (float)geo.getLatitude();  // Lat auslesen
        float lon = (float)geo.getLongitude();  // Lon auslesen
        // Wenn Tweet im Stadtbereich
        if ((lat >= swLat) && (lat <= neLat) && (lon >= swLon) && (lon <= neLon)) {
          String text = status.getText();  // Text auslesen           
          sa.analyze(text);  // Text analysieren
          float score = sa.getScore();  // score anfordern
          float comparative = sa.getComparative();  // comparative anfordern
          tweets.add(new Tweet(lat, lon, text, score, comparative));  // Tweet erstellen
          // Eine Status-Meldung ausgeben
          /*println("Added new Tweet: "+text);
          println("Score: "+score);
          println("Comparative: "+comparative);
          println();*/
          
          lastTweets.add(text);
          if (lastTweets.size() > 20) { lastTweets.remove(0); }
        }
      }
    }
    
    // Restliche Methoden von StatusListener, müssen hier implementiert werden
    public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {}
    public void onStallWarning(StallWarning warning) {}     
    public void onScrubGeo(long userId, long upToStatusId) {} 
    public void onTrackLimitationNotice(int numberOfLimitedStatuses) {}
    public void onException(Exception ex) { ex.printStackTrace(); }
        
  };
  

  // Open new Twitter-Stream with config from above
  TwitterStream twitterStream = new TwitterStreamFactory(cb.build()).getInstance();
  // add defined listener to stream
  twitterStream.addListener(listener);
  // query stream
  twitterStream.filter(query);
  
  // Test-Tweet
  // tweets.add(new Tweet(51.4, 0, "This is a test phrase", 3));
  
  // Ein bisschen Styling
  noStroke();  // Kiene Border fuer Tweets
  aleoReg = createFont("Aleo", 14);  // load Font
  aleoBold = createFont("Aleo-Bold", 18);  // load Font

}


// DRAW
void draw() {
  
  // Wenn Aufnahmemodus an: Aufzeichnung von PDF starten
  if (record) { beginRecord(PDF, "frame-####.pdf"); }  

  // Hintergrund schwarz faerben
  background(0);
  
  // Karte darstellen
  image(backgroundmap, 1230-backgroundmap.width, 100);
  
  // Tweets darstellen  
  for (int i = tweets.size()-1; i >= 0; i--) {
    Tweet t = tweets.get(i);      // Tweet auslesen
    boolean keep = t.display();   // Tweet darstellen und testen, ob er noch weiter existieren soll
    if (keep == false) { tweets.remove(i); }  // Wenn Lebenszeit des Tweets vorbei: Tweet entfernen
  }

  // Stadtname ausgeben
  fill(255);
  textFont(aleoBold);  // apply Font
  textSize(18);  // set fontSize
  text(cityname, 50, 50, 350, 100);  // Text wraps within text box 
  
  // Letzte 20 Tweets ausgeben
  String textout = "";
  for (int i = lastTweets.size()-1; i >= 0; i--) {
    textout = textout+"\n\n"+lastTweets.get(i);      // Tweet auslesen
  }
  textFont(aleoReg);  // apply Font
  textSize(14);  // set fontSize
  text(textout, 50, 100, 350, 700);  // Text wraps within text box  
  
  // Wenn Aufnahmemodus an: Aufzeichnung von PDF beenden, Aufnahmemodus auf false setzen
  if (record) {
    endRecord();
    record = false;
  }

}


// Taste p für Aufnahmemodus abfragen
void keyPressed() {
  if (key == 'p') {
    record = true;
  }
}


// Vollbildmodus an
boolean sketchFullScreen() {
  return true;
}
