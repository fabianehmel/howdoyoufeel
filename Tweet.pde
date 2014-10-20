// CLASS TWEET

class Tweet {
  
  
  // ATTRIBUTE
  float lat, lon, x, y;
  String text;
  float opacity;
  int opacityStart = 150;
  float rFinal;
  float r = 0;
  int lifetimeStart = 7200;
  int lifetime;
  color c;
  float score, comparative;
  float opacityIncrementer;
  int maxScore = 12;
  
  
  // KONSTRUKTOR
  Tweet(double latTemp, double lonTemp, String textTemp, float scoreTemp, float comparativeTemp) {
    // get params
    lat = (float) latTemp;
    lon = (float) lonTemp;
    text = textTemp;
    score = scoreTemp;
    comparative = comparativeTemp;
    // Calculate some things with input values
    calcX();
    calcY();
    calcR();
    c = calcColor();
    // copy some attribute values
    opacity = opacityStart;
    lifetime = lifetimeStart;
    opacityIncrementer = (float) opacityStart/lifetimeStart;
  }
  
  
  // METHODS

  // Getter
  float getLat() { return lat; }
  float getLon() { return lon; }
  String getText() { return text; }
  float getX() { return x; }
  float getY() { return y; }
  int getOpacity() { return int(opacity); }
  
  // Setter
  void setLat(float temp) { lat = (float) temp; calcX(); }
  void setLon(float temp) { lon = (float) temp; calcY(); }
  void setText(String temp) { text = temp; }
  
  // display the tweet
  boolean display() {
    // If tweet is alive
    if (lifetime > 0) {
      if (r < rFinal) { r = r+4; }  // introducing-effect when tweet is new
      reduceOpacity();        // reduce opacity
      fill(c, int(opacity));  // calc current color
      ellipse(x, y, r, r);   // draw tweet    
      lifetime--;  // reduce lifetime
      return true;  // return true to keep tweet alive
    } else {
      return false;  // return false to remove tweet
    }
  }

  // Calculates Color of the Tweet from the score and returns it
  color calcColor() {
    float faktor = 255/maxScore;  // claculate faktor for color calculation
    int r, b;  // vars for r and b of rgb
    
    if (score > 0) {
      // negative sentiment
      // tweet gonna be violet to red
      r = 255-int(score*faktor);
      b = 255;
    } else {
      // positive sentiment
      // tweet gonna be violet to blue
      r = 255;
      b = 255+int(score*faktor);
    }

    //println(score, r, b);
    return color(r, 0, b);   // return color
  }

  // Calculate x-Position from Lat/Lon
  void calcX() {
    float temp = map(lon, (float)swLon, (float)neLon, 1230-backgroundmap.width, 1230);
    x = temp;
  }
  
  // Calculate y-Position from Lat/Lon
  void calcY() {
    float temp = map(lat, (float)neLat, (float)swLat, 100, 700);
    y = temp;
  }

  // Calculate radius with comparative
  void calcR() {
    float temp;
    if (comparative > 0) {
      temp = sqrt(comparative/PI);
    } else {
      temp = sqrt((-comparative)/PI);
    }
    //float temp = sqrt(text.length()/PI)*4;
    rFinal = temp*80+5;
  }
  
  // Reduce Opacity step by step
  void reduceOpacity() {
    opacity = opacity-opacityIncrementer;
  }
  
   
}
