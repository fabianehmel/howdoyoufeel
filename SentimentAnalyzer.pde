// Klasse Sentiment
class SentimentAnalyzer {
  
  // ATTRIBUTS
  float score, comparative;
  String[] tokens;
  processing.data.JSONObject dictionary;  // Var for dictionary
  float middle = 5; // neutral Value of dictionary scores
  
  
  // CONSTRUKTOR
  SentimentAnalyzer() {
    // load dictionary
    dictionary = loadJSONObject("warriner.json");
  }
  
  
  // METHODS
  
  // Analyze a given phrase
  void analyze(String phrase) {
    tokens = tokenize(phrase);  // transfer String in array
    score = calculateScore();  // Calculate Score
    comparative = score/tokens.length;  // calculate comparative
  }
  
  // Calculate Sentiment for input-Phrase
  float calculateScore() {
    
    float result = 0;  // result will be stored here
    float tempScore = 0;  // temp var for calculations
    
    for (int i = 0; i<tokens.length; i++) {
      try { tempScore = dictionary.getFloat(tokens[i]) - middle; }
      catch (Exception e) { tempScore = 0; }
      finally { result = result+tempScore; }
    }
    
    return result;
  
  }
  
  // transform input-String to array of words
  String[] tokenize(String input) {
    input = input.replaceAll("[^a-zA-Z]"," ");  // Replace everything except a-z with spaces
    input = input.replaceAll("\\s+", " ");  // Remove duplicate spaces
    input = input.toLowerCase();  // transfer everthing to lowercase
    String[] output = split(input, " ");  // make array from String. Divider: spaces
    return output;  // Return array
  }
  
  // Getter
  float getScore() { return score; }  // return score
  float getComparative() { return comparative; }  // return comparative

}
