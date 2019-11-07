import g4p_controls.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import controlP5.*;
import http.requests.*;

PFont font;
PImage showTabs;
PImage logo;
PImage gridSetting1, gridSetting2, gridSetting3;
PImage backArrow;

PImage favSymbol, favSymbol_outline, favSymbol_grey;

style frontEnd = new style();
P5cntrls controlp5 = new P5cntrls();
jsonConv backEnd = new jsonConv();
tabData tabs = new tabData();

boolean onMouseReleased = false;
char cursorType = MOVE;

//colorpalette

color primColor = color(79,203,64);    //dark greeen
color secColor = color(52,191,35);    //lighter
color triColor = color(43,152,29);    //lighter
color highlightColor = color(60, 222, 25);  //very light

void setup(){
  size(1200, 750);
  //smooth(2);
  cursor(WAIT);
  frameRate(120);
  ellipseMode(CENTER);
  surface.setResizable(true);
  Ani.init(this); //Ani.to(this, 1.5, "_x", x);
  font = createFont("arial",20);
  cp5 = new ControlP5(this);
  controlp5.init();
  noStroke();
  
  loadImages();

  table1 = new table();
  table1.createArrowShape();
  
  fill(0);
  rect(0,0,width,height);
  println(backEnd.to_realTime("2018-11-24T01:38:30.378Z"));    //test
  //backEnd.load_all_boxes("-180,-90,180,90","2019-01-02T01:38:30.378Z","Temperatur",true);
  //backEnd.get_box_info("5bf8373386f11b001aae627e", false);  //not yet fully developed    //5afff95c223bd80019edf99c    //mine: 5bf8373386f11b001aae627e
  
  //backEnd.getLatestMeasurements("5bf8373386f11b001aae627e", backEnd.sensorId[0], "2018-12-09T01:38:30.378Z", "2019-01-09T01:38:30.378Z");
  cursor(MOVE);
  println(backEnd.realTodaysDate());
}

void loadImages(){
  showTabs = loadImage("Tabs.png");
  logo = loadImage("senseboxlogo.png");
  gridSetting1 = loadImage("diagram_gridsetting1.png");
  gridSetting2 = loadImage("diagram_gridsetting2.png");
  gridSetting3 = loadImage("diagram_gridsetting3.png");
  backArrow = loadImage("backArrow.png");
  favSymbol = loadImage("fav_inside.png");
  favSymbol_outline = loadImage("fav_outline.png");
  favSymbol.resize(30,30);
  favSymbol_outline.resize(30,30);
  favSymbol_grey = loadImage("fav_inside.png");
  favSymbol_grey.resize(30,30);
  favSymbol_grey.filter(GRAY);
  
  try{      //CHECK IF IMAGES ARE IN FOLDER
    image(showTabs, 0,0);
    image(logo, 0,0);
    image(gridSetting1, 0,0);
    image(gridSetting2, 0,0);
    image(gridSetting3,0,0);
    image(backArrow,0,0);
    image(favSymbol,0,0);
    image(favSymbol_outline,0,0);
  }catch(NullPointerException e){
    e.printStackTrace();
    launch(sketchPath()+"/data/ERR_ImageLoading.exe");
    noLoop();
    exit();
  }
}


void draw(){
  println(backEnd.boxName);
  background(255);
  Tab3.update_SettingButtons();
  tabs.showSideLayout();
  frontEnd.showScrollBar();
  frontEnd.showDropDown();
  controlp5.searchWindowControls();
  //frontEnd.drawConsoleOnScreen();
  frontEnd.showFPS();
  
  frontEnd.showCopyInfo();
  
  help.showHints();
  frontEnd.showFeedBack();
}


public class style{
  boolean dropDown = false;
  float dropDownYPos = 50;
  int blackCoverAlpha = 0;
  
  private boolean savePos = true;
  private int saveYpos = 0;
  private int posY = 0;
  private int moveY = 0;    //our value
  private int savePY = 0;
  
  int dragged1(){    //save mousex and y pos
    if(mousePressed){
      if(savePos){
          saveYpos = mouseY;
          savePos = false;
        }
       
        posY = mouseY-saveYpos;
        moveY = savePY+posY;
    }else{
      if(savePos == false){
        savePY+=posY;
        savePos = true;
      }
    }
    return moveY;      //- mouseWheelScroll[tabs.currentSideVisible]
  }
  
  int Limits[][] = {{180,-1000},{850,-1000},{500,0}};
  int[] mouseWheelScroll = {Limits[0][0],Limits[1][0],Limits[2][0]};
  int dragged(){
    if(mouseWheelScroll[tabs.currentSideVisible] > Limits[tabs.currentSideVisible][0]){
      mouseWheelScroll[tabs.currentSideVisible] = Limits[tabs.currentSideVisible][0];
    } else if(mouseWheelScroll[tabs.currentSideVisible] < Limits[tabs.currentSideVisible][1]){
      mouseWheelScroll[tabs.currentSideVisible] = Limits[tabs.currentSideVisible][1];
    }
    return mouseWheelScroll[tabs.currentSideVisible];
  }
  
  void showScrollBar(){
    fill(180,100);
    rect(width-22, 60, 16, height-80);
    noStroke();
    fill(84,200);
    ellipse(width-14,int(map(mouseWheelScroll[tabs.currentSideVisible], Limits[tabs.currentSideVisible][0],Limits[tabs.currentSideVisible][1],60+8,height-20-8)),14,14);
  }
  
  void dottedLine(int x1, int y1, int x2, int y2, int abstand, int durchmesser){
  int AnzahlPunkte = int(dist(x1,y1,x2,y2))/abstand;
  int vector[] = {x2-x1, y2-y1};
  noStroke();
  for(int i = 0; i < AnzahlPunkte; i++){
    ellipse(x1+vector[0]*map(i,0,AnzahlPunkte,0,1), y1+vector[1]*map(i,0,AnzahlPunkte,0,1), durchmesser,durchmesser);
  }
}
  
  boolean isDropDownPressed(){
    if(onMouseReleased){
      if(mouseY>0 && mouseY<dropDownYPos){
        
        dropDown = true;
        onMouseReleased = false;
        return true;
      }
      onMouseReleased = false;
    }
    return false;
  }
  
  boolean isOnDropdown(){
    if(mouseY>0 && mouseY<dropDownYPos){
      if(!controlp5.onMouseOver()){
        return true;
      }
    }
    return false;
  }
  
  void shadowedText(String text, int x, int y, int offset, color c){
    fill(0);
    text(text, x+offset, y+offset);
    fill(c);
    text(text, x, y);
  }
  
  void TrennLinie(int h){
    stroke(0);
    strokeWeight(1);
    line(50,h,width-50,h);
    noStroke();
  }
  
  void showDropDown()
  {
    fill(0,160);
    rect(0,dropDownYPos-10,width,15);    //bar shadow
    fill(0,0,0,blackCoverAlpha);
    rect(0,0,width,height);    //blendshadow
    fill(30);
    rect(0,0,width,dropDownYPos);    //bar
    if(isOnDropdown() && !d2.isMouseOver()){
      if(!searchWindow.isMouseOver()){
        changeCursor(char(ARROW));
      }
      if(onMouseReleased){
        Ani.to(this, 1.5, "dropDownYPos", height*0.5);
        dropDown = true;
        onMouseReleased = false;
        Ani.to(this, 1.5, "blackCoverAlpha", 100);
      }
    } else
    {
      changeCursor(char(HAND));
      if(onMouseReleased){
        Ani.to(this, 0.5, "dropDownYPos", 50);
        dropDown = false;
        onMouseReleased = false;
        Ani.to(this, 1.5, "blackCoverAlpha", 0);
      }
    }
    if(dropDown){
      tint(255,map(dropDownYPos,50,height*0.5,0,255));
      image(logo,width*0.1,-340+dropDownYPos,868,253);
    }
    println(isDropDownPressed(), isOnDropdown(), dropDown);
  }
  
  
  void showFPS(){
    textAlign(RIGHT,BOTTOM);
    textSize(14);
    fill(0);
    text(int(frameRate), width-20,height-10);
    if(frameRate < 15){
      fill(240, 20,20);
    }else if(frameRate >= 15 && frameRate < 30){
      fill(200, 170,20);
    }else{
      fill(20, 250,20);
    }
    text(int(frameRate), width-21,height-11);
  }
  
  void curvedWindow(float x, float y, float w, float h, int rad, color c){
    fill(c);
    beginShape();
    vertex(x+rad-1,y);
    vertex(x+w-rad+1,y);
    vertex(x+w,y+rad-1);
    vertex(x+w,y+h-rad+1);
    vertex(x+w-rad+1,y+h);
    vertex(x+rad-1,y+h);
    vertex(x,y+h-rad+1);
    vertex(x,y+rad-1);
    endShape();
    arc(x+rad,y+rad,rad*2,rad*2,radians(180),radians(270));    // LO
    arc(x+w-rad,y+rad,rad*2,rad*2,radians(270),radians(360));  // RO
    arc(x+w-rad,y+h-rad,rad*2,rad*2,radians(0),radians(90));    // RU
    arc(x+rad,y+h-rad,rad*2,rad*2,radians(90),radians(180));   // LU
  }
  
  void curvedWindowLeft(float x, float y, float w, float h, int rad, color c){    //show Left Curves
    fill(c);
    beginShape();
    vertex(x+rad-1,y);
    vertex(x+w,y);
    vertex(x+w,y+h);
    vertex(x+rad-1,y+h);
    vertex(x,y+h-rad+1);
    vertex(x,y+rad-1);
    endShape();
    arc(x+rad,y+rad,rad*2,rad*2,radians(180),radians(270));
    //arc(x+w-rad,y+rad,rad*2,rad*2,radians(270),radians(360));
    //arc(x+w-rad,y+h-rad,rad*2,rad*2,radians(0),radians(90));
    arc(x+rad,y+h-rad,rad*2,rad*2,radians(90),radians(180));
  }
  
  void curvedWindowRight(float x, float y, float w, float h, int rad, color c){    //show only RightCurves
    fill(c);
    beginShape();
    vertex(x,y);
    vertex(x+w-rad+1,y);
    vertex(x+w,y+rad-1);
    vertex(x+w,y+h-rad+1);
    vertex(x+w-rad+1,y+h);
    vertex(x+rad-1,y+h);
    vertex(x,y+h);
    endShape();
    //arc(x+rad,y+rad,rad*2,rad*2,radians(180),radians(270));
    arc(x+w-rad,y+rad,rad*2,rad*2,radians(270),radians(360));
    arc(x+w-rad,y+h-rad,rad*2,rad*2,radians(0),radians(90));
    //arc(x+rad,y+h-rad,rad*2,rad*2,radians(90),radians(180));
  }
  
  //private color imgButtonColor;
  void imageButton(int x, int y, int size, PImage img, color c, boolean isEnabled){
    stroke(0);
    strokeWeight(1);
    if(isEnabled){
      curvedWindow(x,y,size,size,5,triColor);
    }else{
      curvedWindow(x,y,size,size,5,c);
    }
    if(mouseX > x && mouseX < x+size && mouseY > y && mouseY < y+size){
      curvedWindow(x,y,size,size,5,color(255));
    }
    noStroke();
    //curvedWindow(x,y,size,size,5,c);
    image(img, x+size*0.1, y+size*0.1, size * 0.8, size * 0.8);
  }
  
  boolean onimageButton(int x, int y, int size){
    if(mouseX > x && mouseX < x+size && mouseY > y && mouseY < y+size){
      return true;
    } 
    return false;
  }
  
  int showCopyInfoCounter = 200;
  String infoText;
  int alphaColor = 150;
  float textHeight = width*0.2;
  float yOffset = 0;
  void showCopyInfo(){
    if(showCopyInfoCounter < 200){
      //fill(40,alphaColor);
      yOffset = feedBackCounter<200?300:150;    // check if window feedback is active. if yes set thius window higher
      strokeWeight(1);
      stroke(255);
      curvedWindow(width/2-(infoText.length() * textHeight)*0.6,height-yOffset,(infoText.length() * textHeight)*1.2,40, 5, color(70));
      textAlign(CENTER,CENTER);
      fill(highlightColor);
      textSize(textHeight);
      text(infoText, width/2,height-yOffset+20);
      showCopyInfoCounter++;
    }
    noStroke();
  }
  void setCopyInfo(String text){
    //infoText = "copied: " + text;
    infoText = text;
    showCopyInfoCounter = 0;
  }
  
  
  final int counts = 300; //change to change time of feedbacks
  int feedBackCounter = counts;
  boolean onShowDetails = false;
  boolean feedback = false;
  color feedBackCol;
  void showFeedBack(){
    if(feedBackCounter < 300){
      feedBackCol = feedback?color(primColor):color(#E31919);
      fill(feedBackCol);
      rect(width/2-150, height-150, 300, 50);
      
      fill(50,50);
      rect(width/2-150, height-150, map(feedBackCounter,0,counts,0,300), 50);
      
      textAlign(CENTER,CENTER);
      textSize(20);
      if(feedback){
        shadowedText("success", width/2, height-125, 1, color(255));
        //feedBackCol = primColor;
         //grün
      }else{
        shadowedText("No success", width/2, height-125, 1, color(255));
        //rect(width/2-150, height-160, 300, 100);
        //feedBackCol = color(#E31919);
        if(mouseX > width/2-150 && mouseX < width/2+150 && mouseY > height-150 && mouseY <  height-100){
          onShowDetails = true;
          textSize(20);
          
          float lWi = (backEnd.error_code.length() > backEnd.error_message.length()) ? textWidth(backEnd.error_code) : textWidth(backEnd.error_message);
          int wi = lWi <= 300 ? 300 : int(lWi);
          println(lWi, wi, textWidth(backEnd.error_code), textWidth(backEnd.error_message));
          
          fill(50,50);
          rect(width/2-wi/2 -10, height-95, wi+20, 80);
          
          shadowedText(backEnd.error_code + "\n" + backEnd.error_message, width/2, height-55, 1, color(255));
        } else{
          onShowDetails = false;
        }
      }
      
      if(!onShowDetails){
        feedBackCounter++;
      }
    } else{
      onShowDetails = false;
    }
  }
  
  void setFeedBack(boolean feedBack){
    feedback = feedBack;
    feedBackCounter = 0;
  }
  
  void SettingButton(float x, float y, float w, float h, boolean sett){
    
    color temp =color(0);
    fill(temp);
    rect(x,y,w,h);
    
    fill(100);
    if(sett){
      temp = color(40);
      rect(x+w/2, y, w/2, h);
    }else{
      temp = color(#2394F5);
      rect(x, y, w/2, h);
    }
  }
}

public class settingButton{
  
  float x,y,w,h,offset;
  boolean toggle;
  String description;
  color BG_color = color(40);
  color inactive_color = color(150);
  color active_color = primColor;
  
 /* settingButton(int _x, int _y, String txt){
    x = _x;
    y = _y;
    description = txt;
  }*/
  
  boolean update(float _x, float _y, String txt){
    x = _x;
    y = _y;
    description = txt;
    return toggle;
  }
  
  void show(){
    noStroke();
    fill(BG_color);
    rect(x,y,70,30);
    if(toggle){
      fill(active_color);
    }else{
      fill(inactive_color);
    }
    rect(x+2+offset,y+2,26,26);
    //println(action);
    if(toggle == true){
      offset = 40;
      //Ani.to(this, 1, "offset", 70);
      //fill(255);
      //text("hack turned [on]", 100,20);
    } else{
      //Ani.to(this, 1, "offset", 0);
      offset = 0;
      //fill(255);
      //text("hack turned [off]", 100,20);
    }
    if((mouseX>=x && mouseX<=x+100) && (mouseY>=y && mouseY<=y+30)){
      if(mousePressed){
        
        toggle = !toggle;
        delay(100);
      }
    }
    
    fill(BG_color);
    textSize(12);
    textAlign(LEFT,TOP);
    text(description, x, y+31);
  }
}

void changeCursor(char type)
{
  while(type != cursorType){
    cursorType = type;
    cursor(cursorType);
    println("GELLLLLALALALDAD");
  }
}

void cursorLooks(){
  //onDropDown && !onSearchwindow && !onFavoritesMenu
  //ARROW
  //onSearchwindow
  //TEXT
  //onFavo
  //HAND
  //!onDropDown
    //Tab1
    //MOVE
    //TAB2
      //onLoadBoxdataButton || onSettings || onDateSelect
      //HAND
      //else MOVE
    //Tab3
      //onsettings
      //HAND
      
  // NAME BEI TAB 3 Reinschreiben
  
}

void mouseWheel(MouseEvent event) {
    frontEnd.mouseWheelScroll[tabs.currentSideVisible] -= event.getCount()*20;
}

void exit(){
  controlp5.saveFavs();
  super.exit();
}
