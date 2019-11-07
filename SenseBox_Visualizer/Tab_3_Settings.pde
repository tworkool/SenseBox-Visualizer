int[] feedback_bbox = {-400,120,40};    //y,w,h
color feedback = color(30);

class settings{
  
  settingButton sett1_localBoxes = new settingButton();
  settingButton sett2_autoOpti = new settingButton();
  
  void update_SettingButtons(){
    loadBoxesFromLocal = sett1_localBoxes.update(100,-100+frontEnd.dragged(),"load boxes locally");
    //sett2_autoOpti.update(100,-100+frontEnd.dragged(),"set2");
  }
  
  void show_SettingButtons(){
    noStroke();
    textAlign(LEFT,BOTTOM);
    textSize(20);
    fill(100);
    text(".SETTINGS", 50, -200+frontEnd.dragged());
    frontEnd.TrennLinie(-190+frontEnd.dragged());
    sett1_localBoxes.show();
    //sett2_autoOpti.show();
  }
  
  boolean loadBoxesFromLocal = true;    //bestimmt ob boxen local oder über api geladen werden sollen
  boolean isAutomaticOptiEnabled = false;
  
  void showFeedBackButton(){
    frontEnd.curvedWindow(width/2-feedback_bbox[1]/2,feedback_bbox[0]+frontEnd.dragged(),feedback_bbox[1],feedback_bbox[2],5,feedback);
    textAlign(CENTER,CENTER);
    fill(255);
    textSize(15);
    text("Feedback", width/2, feedback_bbox[0]+feedback_bbox[2]/2+frontEnd.dragged());
    if(onFeedBackbutton()){
      feedback = color(90); 
    }
    else{
      feedback = color(30);
    }
    println(onFeedBackbutton());
  }
  
  boolean onFeedBackbutton(){
    if(mouseX>width/2-feedback_bbox[1]/2 && mouseX < width/2+feedback_bbox[1]/2 && mouseY > feedback_bbox[0] + frontEnd.dragged() && mouseY < feedback_bbox[0] + feedback_bbox[2] + frontEnd.dragged()){
      return true;
    }
    return false;
  }
  
  //libraryRefText
  private int libRectsTotal = 4;
  private String[][] texts = 
  {
  {"looksgood Ani", "Animation Library", "by Benedikt Groß", "http://www.looksgood.de/libraries/Ani/"},
  {"HTTP-Request", "Easy HTTP Requests", "by Daniel Schiffman and Chris Allick", "https://github.com/runemadsen/HTTP-Requests-for-Processing"},
  {"G4P", "GUI for Processing", "by Peter Lager", "http://www.lagers.org.uk/g4p/"},
  {"Joda Time", "Time and Date Library", "by Stephen Colebourne", "https://www.joda.org/joda-time"},
  {"ControlP5", "GUI for Processing", "by Andreas Schlegel", "http://www.sojamo.de/libraries/controlP5/"},
  {"Vielen Dank an das SenseBox Team für das SenseBox Projekt", "", "", "https://sensebox.de/"},
  {"API Documentation", "", "", "https://docs.opensensemap.org/#api-Boxes-getBox"}
  };
  String selectedLink = "";
  
  boolean[] selectedRect = new boolean[texts.length];
  
  void clearArray(boolean[] a){
    for(int m = 0; m<a.length; m++){    //clear Array
      a[m] = false;
    }
  }
  
  public void showLibraryReference(int y, int h, int spaces){
    noStroke();
    textAlign(LEFT,BOTTOM);
    textSize(20);
    fill(100);
    text(".LIBRARY_REFERENCE AND LINKS", 50, y-50);
    frontEnd.TrennLinie(y-40);
    textAlign(LEFT,TOP);
    textSize(20);
    clearArray(selectedRect);
    for(int i = 0; i < texts.length; i++){
      if(i == texts.length-1 || i == texts.length-2){
        fill(primColor);
      }else{
        fill(100);
      }
     
      if(mouseX>50 && mouseX<width-50 && mouseY>y+(i*h) && mouseY<y+((i+1)*h)-spaces){
        fill(150);
        selectedRect[i] = true;    //set selected to truze
        if(mousePressed){
          //selectedLink = texts[i][texts[i].length-1];
        }
      }
      rect(50, y+(i*h), width-100, h-spaces);
      for(int j = 0; j<texts[0].length-1; j++){
        fill(255);
        text(texts[i][j], 60 + 300*j, 10+y+(i*h));
      }
    }
    printArray(selectedRect);
  }
  
  void automaticOptimization(){
    if(frameRate < 30){
      ts.isEveryTenLine = true;
    }
    if(frameRate < 30){
      ts.density = ts.firstFieldValues[2];
    }
  }
  
  void showAPIconsole(float y){
    controlp5.updateConsole();
    fill(0);
    rect(55, y-50, width-160, 45);
    fill(0,255,0);
    textSize(15);
    textAlign(LEFT,CENTER);
    text(backEnd.baseAddress, 60, y+25);
    //rect(50, y+70, width-150, 600);
    if(tabs.currentSideVisible == 2){
      APIconsole_out.show();
    }else{
      APIconsole_out.hide();
    }
  }
  
  void showSettings(){
    
  }
}
