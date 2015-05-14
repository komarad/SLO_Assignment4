import http.requests.*;
import java.util.Date;
import java.util.Calendar;

//import java.net.URLDecoder;



final String url = "http://tt-history.appspot.com/rpc?woeid=1";
final int dayLengthInSec = 86400;
JSONObject json, topTrend;
JSONArray topTrends;

boolean ready = false;

// Create a session using your Temboo account application details
// TembooSession session = new TembooSession("joshuajnoble", "myFirstApp", "f06e8f5d39b044ecbf6788ba895d19b6");

void setup() {
  // Run the Show Choreo function
  println(getTrend(1,5,2015));
  //size(512, 512);
}

String getTrend(int day, int month, int year) {
  
  Calendar cal = Calendar.getInstance();
  cal.setTimeInMillis(0);
  cal.set(year, month - 1, day);
  Date date = cal.getTime(); // get back a Date object

  long millisBegin = date.getTime()/1000;
  long millisEnd = millisBegin + dayLengthInSec;
  GetRequest get = new GetRequest(url + "&timestamp=" + millisBegin + "&end_timestamp=" + millisEnd + "&limit=1");
  get.send(); // program will wait untill the request is completed
  json = JSONObject.parse(get.getContent());
  topTrends = json.getJSONArray("trends");
  JSONObject topTrend = topTrends.getJSONObject(0); // get the first Trend
  String name = topTrend.getString("name"); // get its name (hash tag)
  return name;
}

void draw()
{

}
