//import org.joda.time.format.*;
//import org.joda.time.convert.*;
//import org.joda.time.*;
//import org.joda.time.tz.*;
//import org.joda.time.chrono.*;
//import org.joda.time.base.*;
//import org.joda.time.field.*;

CalendarWidget Cal = new CalendarWidget(100,100,300);

public class CalendarWidget{
  private int currentMonth = (12-month());    // 12-12 = 0, da das der Offset ist, muss er null ergeben damit der jetztige monat bleibt
  int currentRealMonth;
  private int currentYear = year();
  int currentRealYear = currentYear;
  private int yearDifference = 0; 
  private boolean ausgeklappt = true;
  //int h = 0;    //höhe der rects
  
  boolean zeitRaumCounter = false; // entweder StartDatum oder Enddatum, 2 Phasen
  int[][] selectedDates = new int[2][3];    //[0][] =1. eintrag, [1][] =2. Eintrag    [][0] = tag, [][1] = monat [][2] = jahr
  
  int[] createdDatum = {24,2,2017};    //[0] = Tag, [1] = Monat, [2] = Jahr
  //Timestamp für Box Erstellt!, Nur test!
  
  final color primaryColor = color(255);
  final color secondaryColor = color(240,20,40);
  final color highlightColor1 = color(160);
  final color highlightColor2 = color(64,171,255);
  final color StartEndDate = color(52,108,216);
  final color textColorDark = color(30);
  final color textColorBright = color(240);
  
  int x,y,w,h;
  
  CalendarWidget(int _x, int _y, int _w){
    x = _x;
    y = _y;
    w = _w;
    h = _w/5;
    /*if(day()-1 == 0){
      if(month()-1 == 0){
        selectedDates[0][0] = daysOfMonth(year()-1,12);
        selectedDates[0][1] = 12; selectedDates[0][2] = year()-1;
      }else{
        selectedDates[0][0] = daysOfMonth(year(),month()-1);
        selectedDates[0][1] = month()-1; selectedDates[0][2] = year();
      }
    }else{
      selectedDates[0][0] = day()-1;        //NOT WORKING!
      selectedDates[0][1] = month(); selectedDates[0][2] = year();
    }
    selectedDates[1][0] = day(); selectedDates[1][1] = month(); selectedDates[1][2] = year();
    */
    
    
    if(day()+1 > daysOfMonth(year(),month())){
      if(month() > 12){
        selectedDates[1][0] = daysOfMonth(year()+1,1);
        selectedDates[1][1] = 1; selectedDates[1][2] = year()+1;
      }else{
        selectedDates[1][0] = daysOfMonth(year(),month()+1);
        selectedDates[1][1] = month()+1; selectedDates[1][2] = year();
      }
    }else{
      selectedDates[1][0] = day()+1;        //NOT WORKING!
      selectedDates[1][1] = month(); selectedDates[1][2] = year();
    }
    //wenn tag 1 ist dann ist der davor ja nicht 0!! sondern der tag vom monat dasvor. oder wenn monat 1 ist dann nicht monat = 0!!
    //selectedDates[1][0] = day()-1; selectedDates[1][1] = month(); selectedDates[1][2] = year();
    selectedDates[0][0] = day(); selectedDates[0][1] = month(); selectedDates[0][2] = year();
  }
  
  void ausgeKlappt(){
    if(keyPressed && key == 'a'){
      ausgeklappt = !ausgeklappt;
      delay(100);
    }
  }
  
  void showWidget(){
    x = width/2-150;
    y = -550+frontEnd.dragged();
    fill(80);
    frontEnd.curvedWindow(x-50,y-100,w+100,h+450,10,color(180));
    if(!isPreviewSelected){
      showPreview(x,y,w);
      return;
    }
    showPreview(x,y-h-5,w);
    
    //ausgeKlappt();
    calcDate();
    
    noStroke();
    frontEnd.curvedWindow(x,y,w,h,5, primaryColor);
    
    noStroke();
    frontEnd.curvedWindow(x+int(w*0.025),y+int(h*0.1),w-int(w*0.05),h-int(h*0.2),5, secondaryColor);
    fill(255);
    textSize(w/15);
    textAlign(CENTER, CENTER);
    text(currentMonthAsText(currentRealMonth) + "  " + currentRealYear, x+w/2,y+h/2);
    
    if(onLeftArrow()){      //LINKES DREIECK
      fill(highlightColor1);
      if(mousePressed){
        currentMonth++;
        delay(100);
      }
    }else{
      fill(primaryColor);
    }
    triangle(x+10,y+h/2, x+30, y+10, x+30, y+h-10);
    
    if(onRightArrow()){    //RECHTES DREIECK
      fill(highlightColor1);
      if(mousePressed){
        if(currentMonth > 0){
          currentMonth--;
          delay(100);
        }
      }
    }else{
      fill(primaryColor);
    }
    triangle(x+w-10,y+h/2, x+w-30, y+10, x+w-30, y+h-10);
    
    noStroke();
    if(ausgeklappt){
      //rect(x,y+h+5,w,w);
      frontEnd.curvedWindow(x,y+h+5,w,w+5,5, primaryColor);
      
      for(int i = 0; i < daysOfMonth(currentRealYear, currentRealMonth+1); i++){    //TAGE des Monats
        //connect
        if(currentRealYear >= selectedDates[0][2] && currentRealYear <= selectedDates[1][2] && currentRealMonth+1 >= selectedDates[0][1] && currentRealMonth+1 <= selectedDates[1][1] && i >= selectedDates[0][0]-1 && i <= selectedDates[1][0]-1){
          fill(highlightColor2);
        }else{
          fill(200);
        }
        //ellipse(x+20+(i%7)*43, y+h+30+ int(i/7)*60, 33,33);
        
        rect(x+5+(i%7)*((w-5)/7), y+h+10 + int(i/7)*60,w/7-5,55);
        
        if(dist(mouseX,mouseY,x+20+(i%7)*43,y+h+30+ int(i/7)*60) <16){
          fill(highlightColor1);
          rect(x+5+(i%7)*((w-5)/7), y+h+10 + int(i/7)*60,w/7-5,55);
          if(mousePressed){
            int Dateindex = zeitRaumCounter ? 1 : 0;    //convert bool to int
            selectedDates[Dateindex][0] = i+1;
            selectedDates[Dateindex][1] = currentRealMonth+1;
            selectedDates[Dateindex][2] = currentRealYear;
            
            /*if(isLower(selectedDates[1][0],selectedDates[1][1],selectedDates[1][2],selectedDates[0][0],selectedDates[0][1],selectedDates[0][2]))    //wenn das zweite datum kleiner ist dann swap
            {
              int[] tempDate = {selectedDates[0][0],selectedDates[0][1],selectedDates[0][2]};    //save first date  (higher one)
              selectedDates[0][0] = selectedDates[1][0];            //replace higher (1. one) with lower one so that its in 1.st place
              selectedDates[0][1] = selectedDates[1][1];
              selectedDates[0][2] = selectedDates[1][2];
              
              selectedDates[1][0] = tempDate[0];      //replace 2.d place with temp
              selectedDates[1][1] = tempDate[1];
              selectedDates[1][2] = tempDate[2];
            }*/
            
            zeitRaumCounter = !zeitRaumCounter;
            delay(100);
          }
        }
       
        fill(0);
        textSize(15);
        text((i+1),x+20+(i%7)*43,y+h+30+ int(i/7)*60-5);
        if(Cal.wochenTag(i+1,currentRealMonth+1,currentRealYear) == 5 || Cal.wochenTag(i+1,currentRealMonth+1,currentRealYear) == 6){
          fill(secondaryColor);
        }
        textSize(12);
        text(currentWeekDay(Cal.wochenTag(i+1,currentRealMonth+1,currentRealYear)), x+20+(i%7)*43,y+h+30+ int(i/7)*60+10);
        //text(getDayOfWeek(),x+20+(i%7)*43,y+h+30+ int(i/7)*60);
        
        //fill(secondaryColor);    //close window button
        //rect(x,y-20,w,15);
        if(mouseX > x && mouseX < x+w && mouseY > y-20 && mouseY < y-5){
          if(mousePressed){
            isPreviewSelected = false;
          }
        }
      }
      
      
      if(currentRealYear == selectedDates[0][2] && (currentRealMonth+1) == selectedDates[0][1]){
        fill(StartEndDate);
        //ellipse(x+20+((selectedDates[0][0]-1)%7)*43, y+h+30+ int((selectedDates[0][0]-1)/7)*60, 40,40);
        rect(x+5+((selectedDates[0][0]-1)%7)*((w-5)/7), y+h+10 + int((selectedDates[0][0]-1)/7)*60,w/7-5,55);
        
        fill(255);
        textSize(15);
        text(((selectedDates[0][0]-1)+1),x+20+((selectedDates[0][0]-1)%7)*43,y+h+30+ int((selectedDates[0][0]-1)/7)*60-5);
        
        textSize(12);
        text(currentWeekDay(Cal.wochenTag((selectedDates[0][0]-1)+1,currentRealMonth+1,currentRealYear)), x+20+((selectedDates[0][0]-1)%7)*43,y+h+30+ int((selectedDates[0][0]-1)/7)*60+10);
      }
      
      if(currentRealYear == selectedDates[1][2] && (currentRealMonth+1) == selectedDates[1][1]){
        fill(StartEndDate);
        //ellipse(x+20+((selectedDates[1][0]-1)%7)*43, y+h+30+ int((selectedDates[1][0]-1)/7)*60, 40,40);
        rect(x+5+((selectedDates[1][0]-1)%7)*((w-5)/7), y+h+10 + int((selectedDates[1][0]-1)/7)*60,w/7-5,55);
        
        fill(255);
        textSize(15);
        text(((selectedDates[1][0]-1)+1),x+20+((selectedDates[1][0]-1)%7)*43,y+h+30+ int((selectedDates[1][0]-1)/7)*60-5);
        
        textSize(12);
        text(currentWeekDay(Cal.wochenTag((selectedDates[1][0]-1)+1,currentRealMonth+1,currentRealYear)), x+20+((selectedDates[1][0]-1)%7)*43,y+h+30+ int((selectedDates[1][0]-1)/7)*60+10);
      }
      
      if(currentRealYear == createdDatum[2] && (currentRealMonth+1) == createdDatum[1]){    //Box Erstellt Timestamp
        fill(secondaryColor);
        ellipse(x+20+(createdDatum[0]%7)*43, y+h+30+ int(createdDatum[0]/7)*60, 40,40);
        
        fill(255);
        textSize(15);
        text(((createdDatum[0]-1)+1),x+20+(createdDatum[0]%7)*43,y+h+30+ int(createdDatum[0]/7)*60-5);
        
        textSize(12);
        text(currentWeekDay(Cal.wochenTag(createdDatum[0]+1,currentRealMonth+1,currentRealYear)), x+20+(createdDatum[0]%7)*43,y+h+30+ int(createdDatum[0]/7)*60+10);
        //text(currentWeekDay(daysOfWeek(currentRealYear,currentRealMonth+1,createdDatum[0]+1)), x+20+(createdDatum[0]%7)*43,y+h+30+ int(createdDatum[0]/7)*60+10);
      }
    }
  }
  
  int sideBarPos = 0;
  void showSidebar(){
    fill(secondaryColor);
    if(zeitRaumCounter){
      //Ani.to(this, 1.5, "sideBarPos", w/2);
      sideBarPos = w/2-10;
    } else{
      //Ani.to(this, 1.5, "sideBarPos", 0);
      sideBarPos = 0;
    }
    
    //rect(x+5+sideBarPos, y-h+10,w/2,h-20);
    noStroke();
    frontEnd.curvedWindow(x+5+sideBarPos,y-h,w/2,h-10,5,200);
    
    if(keyPressed && key == '2'){
      zeitRaumCounter = true;
    }
    if(keyPressed && key == '1'){
      zeitRaumCounter = false;
    }
  }
  
  boolean onLeftArrow(){
    if(mouseX>x+10 && mouseX<x+30 && mouseY>y+10 && mouseY<y+h-10){
      return true;
    }
    return false;
  }
  
  boolean onRightArrow(){
    if(mouseX>x+w-30 && mouseX<x+w-10 && mouseY>y+10 && mouseY<y+h-10){
      return true;
    }
    return false;
  }
  
  private void calcDate(){
    currentRealYear =  currentYear - yearDifference;
    currentRealMonth = 11 - currentMonth%12;    //12. monat ist Dez, 0. ist Jan
    yearDifference = int(currentMonth/12);
  }
  
  public int daysOfMonth(int year, int month) {
    DateTime dateTime = new DateTime(year, month, 14, 12, 0, 0, 000);
    return dateTime.dayOfMonth().getMaximumValue();
  }
  
  public int daysOfWeek(int year, int month, int day) {
    DateTime dateTime = new DateTime(year, month, day, 12, 0, 0, 000);
    return dateTime.getDayOfWeek();
  }
  
  public int wochenTag(int d, int m, int year)
  {
      String _year = Integer.toString(year);
      String _c = String.valueOf(_year.charAt(0)) + String.valueOf(_year.charAt(1));
      int c = Integer.valueOf(_c);
      String _y = String.valueOf(_year.charAt(2)) + String.valueOf(_year.charAt(3));
      int y = Integer.valueOf(_y);
      double temp = d + (2.6 * m - 0.2) + y + (y / 4) + (c / 4) -2 * c;
      return (int)temp%7;
  }
  public int wochenTag1(int d, int m, int y, int c)
  {
      double temp = d + (2.6 * m - 0.2) + y + (y / 4) + (c / 4) -2 * c;
      return (int)temp%7;
  }
  
  private String currentMonthAsText(int m){  //0 to 11!
    switch(m){
      case 0:
      return "Januar";
      case 1:
      return "Februar";
      case 2:
      return "Maerz";
      case 3:
      return "April";
      case 4:
      return "Mai";
      case 5:
      return "Junai";
      case 6:
      return "Julai";
      case 7:
      return "August";
      case 8:
      return "September";
      case 9:
      return "Oktober";
      case 10:
      return "November";
      case 11:
      return "Dezember";
    }
    return "ERROR";
  }
  
  private String currentWeekDay(int m){  //0 to 11!
    switch(m){
      case 0:
      return "MO";
      case 1:
      return "DIE";
      case 2:
      return "MI";
      case 3:
      return "DO";
      case 4:
      return "FR";
      case 5:
      return "SA";
      case 6:
      return "SO";
    }
    return "";
  }
  
  public boolean rollOverMouse(){
    if(mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h){
      return true;
    }
    return false;
  }
  
  boolean isPreviewSelected = true;    //Von anfang an ausgeklappt
  
  void showPreview(int x, int y, int w){
    if(mouseX > x && mouseX< x+w && mouseY > y && mouseY < y+h){
      stroke(secondaryColor);
      strokeWeight(2);
      if(mousePressed){
        isPreviewSelected = !isPreviewSelected;
      }
    }
    frontEnd.curvedWindow(x,y,w,h,5,primaryColor);
    if(isPreviewSelected){
      showSidebar();
    }
    fill(20);
    textSize(22);
    textAlign(CENTER,CENTER);
    text(selectedDates[0][0] + "." + selectedDates[0][1] + "." + selectedDates[0][2] + "  -  " + selectedDates[1][0] + "." + selectedDates[1][1] + "." + selectedDates[1][2], x+w/2, y+h/2);
    noStroke();
  }
  
  boolean isLower(int D1, int M1, int Y1, int D2, int M2, int Y2){
    if(Y1 < Y2){
      return true;
    }
    if(M1 < M2 && Y1 <= Y2){
      return true;
    }
    if(D1 < D2 && M1 <= M2 && Y1 <= Y2){
      return true;
    }
    return false;
  }
  
}
