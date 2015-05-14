/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/104493*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
import http.requests.*;
import java.util.Date;
import java.util.Calendar;
final String url = "http://tt-history.appspot.com/rpc?woeid=1";
final int dayLengthInSec = 86400;
final int frameRateVal = 60;
final int numOfFramesPerDay = 1440;
JSONObject json, topTrend;
JSONArray topTrends;
Calendar currentDisplayDate;
String currentHashTag = "";
int framesLeftFirstDay;
int ourFrameCount = 0;

int pastSecond;
int curDay = day();
int curMonth = month();
int curYear = year();


void setup() {
  size(500,500);
  smooth();
  currentDisplayDate = Calendar.getInstance();
  currentDisplayDate.set(curYear, curMonth, curDay);
  frameRate(frameRateVal);
  currentHashTag = getTrend(curDay,curMonth,curYear);
  pastSecond = second() + minute()*60 + hour()*60*60;
  framesLeftFirstDay = (second() + minute()*60 + hour()*60*60)/60;
}


void mousePressed() { 
  link("https://twitter.com/search?q=" + currentHashTag.replaceAll("#", "%23") + "&src=typd");
}


void draw() {
  ourFrameCount++;
  background(255);
  pushMatrix(); // start clock face context
  translate(250,250);
  stroke(0);
  strokeWeight(4);
  noFill();
  ellipse(0,0,400,400);

  pushMatrix(); // start tick marks context
  for(int i=0; i<60; i++) {
    if(i%5==0) largeTick();
    else smallTick();
    rotate(radians(6));
  }
  popMatrix(); // end tick marks context
  
  pastSecond=pastSecond-60;
  //pushMatrix(); // start secondHand context
  //rotate(radians(6*pastSecond-90));
  //secondHand();
  //popMatrix(); // end secondHand context

  pushMatrix(); // start minuteHand context
  rotate(radians(6*(pastSecond/60.0)-90));
  minuteHand();
  popMatrix(); // end minuteHand context

  pushMatrix(); // start hourHand context
  rotate(radians(30*(pastSecond/60.0/60.0)-90));
  hourHand();
  popMatrix(); // end hourHand context

  // center button
  fill(0);
  noStroke();
  ellipse(0,0,20,20);

  popMatrix(); // end clock face context
  
  //current date display
  int[] numbers = new int[3]; 
  numbers[0] = curDay;
  numbers[1] = curMonth; 
  numbers[2] = curYear; 

  textSize(16);
  String joinedNumbers = currentDisplayDate.get(Calendar.DAY_OF_MONTH) + "-" + currentDisplayDate.get(Calendar.MONTH) + "-" + currentDisplayDate.get(Calendar.YEAR);
  text(joinedNumbers,width/1.75, height/1.75);
    
  if ((framesLeftFirstDay > 0 && ourFrameCount%framesLeftFirstDay == 0) || ourFrameCount%numOfFramesPerDay == 0) {
    if(framesLeftFirstDay > 0) {
      framesLeftFirstDay = 0;
      ourFrameCount = 1;
    }
    currentDisplayDate.add(Calendar.DAY_OF_YEAR, -1);
    curDay = currentDisplayDate.get(Calendar.DAY_OF_MONTH);
    curMonth = currentDisplayDate.get(Calendar.MONTH);
    curYear = currentDisplayDate.get(Calendar.YEAR);
    currentHashTag = getTrend(curDay,curMonth,curYear);
  }
  textSize(16);
  text(currentHashTag,width/1.75, height/2);
}

void smallTick() {
  stroke(0,0,255);
  strokeWeight(2);
  line(170,0,190,0);
}

void largeTick() {
  stroke(0);
  strokeWeight(3);
  line(165,0,190,0);
}

void secondHand() {
  stroke(255,0,0);
  strokeWeight(1);
  line(0,0,175,0);
}

void minuteHand() {
  stroke(0);
  strokeWeight(3);
  line(0,0,160,0);
}

void hourHand() {
  stroke(0);
  strokeWeight(5);
  line(0,0,80,0);
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
