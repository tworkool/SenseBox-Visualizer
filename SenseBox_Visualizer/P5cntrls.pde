ControlP5 cp5;
Textfield searchWindow;
Textfield APIconsole_in;
Textarea hintTxtfield;
Textarea APIconsole_out;
DropdownList d2;

class P5cntrls{
  String FavSave_filename = "favorites";
  
  String enteredID = "";
  //String[][] searchedAddress = new String[2][6];
  String[] compare = new String[2];
  String[][] foundPos = new String[2][6];
  
  String finalID;
  
  void init(){
    searchWindow = cp5.addTextfield("input")
     .setPosition(10,10)
     .setSize(250,30)
     .setFont(font)
     //.setFocus(true)
     .setColor(255)    //textColor
     .setColorActive(color(255,255,255))   //outline active
     .setColorForeground(color(130))  //outline inactive
     .setColorBackground(triColor) 
     .setLabel("")
     ;
     
    hintTxtfield = cp5.addTextarea("txt")
    //.setPosition(100,100)
    .setSize(400,50)
    .setFont(createFont("arial",12))
    .setLineHeight(14)
    .setColor(color(200))
    .setColorBackground(color(0,200))
    .setColorForeground(color(0,200))
    .hideBar()
    .hideScrollbar()
    .hide()
    ;

              
    d2 = cp5.addDropdownList("favorites")
    //.setPosition(600, 100)
    .setSize(250,200)
    //.setColorValue(color(56))     //text
    .setColorForeground(triColor)   // whgen mouse over
    .setBackgroundColor(color(190))
    .setItemHeight(45)
    .setBarHeight(30)
    .setFont(createFont("arial",12))
    .setColorBackground(color(60))
    .setColorActive(color(255, 128))
    .setLabel("F A V O R I T E S")
    .close()
    ; 
    d2.getValueLabel().toUpperCase(false);
    d2.getLabel().toLowerCase();
    
    APIconsole_out = cp5.addTextarea("ab")
    //.setPosition(100,100)
    //.setSize(400,50)
    //.setFont(createFont("arial",20))
    .setLineHeight(14)
    .setColor(color(255))
    .setColorBackground(color(0,255))
    .setColorForeground(color(0,255))
    .showScrollbar()
    .hide()
    .setText("Text")
    ; 
    
   APIconsole_in = cp5.addTextfield("")
    //.setPosition(10,10)
    //.setSize(250,30)
    .setFont(font)
    //.setFocus(true)
    .setColor(color(0,255,0))    //textColor
    .setColorActive(color(0))   //outline active
    .setColorForeground(color(0))  //outline inactive
    .setColorBackground(triColor) 
    .setLabel("")
    .hide()
    ;
  }
  
  void updateConsole(){
    APIconsole_out.setSize(width-160,590);
    APIconsole_out.setPosition(55,605+frontEnd.dragged());
    
    APIconsole_in.setPosition(245,550+frontEnd.dragged());
    if(width > 510){
      APIconsole_in.setSize(width-350,45);
    }else{
      APIconsole_in.setSize(160,45);
    }
    if(APIconsole_in.isMouseOver()){
      APIconsole_in.setColorBackground(color(20));
    }else{
      APIconsole_in.setColorBackground(color(0));
    }
    //APIconsole_out.getValueLabel().setSize(20);
    //APIconsole_out.getValueLabel().toUpperCase(false);
    //APIconsole_out.setText(backEnd.sample);
  }
  
  String lbl = "";
  void showFavMenu(){
    d2.setPosition(450, frontEnd.dropDownYPos-40);
    //d2.addItem("", index);
    //d2.removeItem("");    //remove by name
    //println(d2.getLabel());
    //d2.setLabel("F A V O R I T E S");
    //d2.getValueLabel().toUpperCase(false);
    if(!d2.isMouseOver()){
      d2.close();
      
    }
    
    if(lbl != d2.getLabel() && !lbl.equals("")){
      int selectedBox = 0;
      for(int j = 0; j<favoriteBoxes.size(); j++){
        if(d2.getLabel().contains(favoriteBoxes.get(j))){
          selectedBox = j;    //save index to be read out. Only one result can come out because in false case that contains 2 ids, than itll be overwritten
        }
      }
      if(d2.getLabel().contains(favoriteBoxes.get(selectedBox))){    //make sure the id really is the same (if no change before index = 0 which musnt be true)
        backEnd.get_box_info(favoriteBoxes.get(selectedBox),true);
      }
      
      //backEnd.get_box_info(d2.getLabel(),true);
      //changeCursor(char(WAIT));
    }
    lbl = d2.getLabel();
  }
  
  boolean onMouseOver(){
    if(searchWindow.isMouseOver()){
      return true;
    }
    return false;
  }
  
  boolean resultHasChanged(){
    compare[0] = enteredID; 
    if(!compare[0].equals(compare[1])){
      compare[1] = enteredID;
      return true;
    } 
    compare[1] = enteredID;
    return false;
  }
  
  boolean isCleared;
  private void clearOnce(){
    while(!isCleared){
      searchWindow.clear();
      searchWindow.setColor(255);
      isCleared = true;
    }
  }
  
  boolean onSubmitbutton(){
    if(mouseX>submitX && mouseX<submitX+submitW && mouseY>frontEnd.dropDownYPos-40 && mouseY<frontEnd.dropDownYPos-40+searchWindow.getHeight()){
        //initBoxData("submitbutton", 0);
        return true;
     }
     return false;
  }
  
  int searchResults;
  
  int submitX = 260;
  int submitY = 10;
  //int wh = 30;
  int submitW = 100;
  
  StringList favoriteBoxes = new StringList();
  
  boolean loadedBoxes = false;
  
  boolean pressed = false;
  
  void searchWindowControls(){
    //fill(80);    //submitbutton
    //rect(submitX,submitY+frontEnd.dropDownYPos-50,wh+2,wh+2);
    //fill(180);
    //rect(submitX,submitY+frontEnd.dropDownYPos-50,wh,wh);
    showFavMenu();
    
    if(onSubmitbutton()){
      frontEnd.curvedWindow(submitX,frontEnd.dropDownYPos-40,submitW,searchWindow.getHeight(),2,color(150));
    }else{
      frontEnd.curvedWindow(submitX,frontEnd.dropDownYPos-40,submitW,searchWindow.getHeight(),2,color(100));
    }
    
    fill(255);
    textSize(12);
    textAlign(CENTER,CENTER);
    text("get boxinfo", submitX+submitW/2, frontEnd.dropDownYPos-40+searchWindow.getHeight()/2);
    
    textAlign(LEFT,BOTTOM);
    
    searchWindow.setPosition(10,frontEnd.dropDownYPos-40);    //reposition searchwindow
    textSize(17);
    if(searchWindow.isMouseOver()){
      changeCursor(char(TEXT));
      if(!searchWindow.isActive()){
        fill(70,90);
        rect(10,12+frontEnd.dropDownYPos,300,50);    //Preview
        textSize(12);
        fill(0);
        text(searchResults + " results", 31, frontEnd.dropDownYPos+31);
        if(searchResults!=0){
          fill(25,200,40);
        } else{
          fill(200,19,30);
        }
        text(searchResults + " results", 30, frontEnd.dropDownYPos+30);
        
        /*for(int c=0;c<foundPos[0].length;c++){
          if(foundPos[0][c] != null){
            fill(0,255-c*(255/10));
            textSize(20);
            text(foundPos[0][c],30,frontEnd.dropDownYPos+70+c*40);  //NAME
            textSize(16);
            text(foundPos[1][c],30,frontEnd.dropDownYPos+85+c*40);   //ID
          }
        }*/
      }
    }
    
    if(searchWindow.isActive()){
      if(!loadedBoxes){
        fill(0);
        textSize(30);
        textAlign(CENTER,CENTER);
        text("LOADING BOXES", width/2,height/2);
        rect(0,0,width,height);
        backEnd.load_all_boxes("-180,-90,180,90","2019-01-02T01:38:30.378Z","Temperatur",true, Tab3.loadBoxesFromLocal);
        controlp5.loadFavs();    //has to load AFTER all boxes are loaded because dependend on all boxes loaded!
        loadedBoxes = true;
      }
      textAlign(LEFT,BOTTOM);
      clearOnce();
      searchResults = 0;
      enteredID = cp5.get(Textfield.class,"input").getText();
      fill(70,255);
      //rect(10,12+frontEnd.dropDownYPos,500,300);
      //frontEnd.curvedWindow(12,12+frontEnd.dropDownYPos+2,502,302,10,color(0,100));    //shadow
      frontEnd.curvedWindow(10,12+frontEnd.dropDownYPos,500,300,10,color(70,255));    //ausgeklappt
      
      // SUCHE NACH BOXEN DIE EINGEGEBEN WERDEN
      for(int i = 0; i< backEnd.boxesID.size(); i++){
        if(backEnd.boxesID.get(i).toLowerCase().contains(enteredID.toLowerCase()) || backEnd.boxesName.get(i).toLowerCase().contains(enteredID.toLowerCase())){
          if(searchResults<foundPos[0].length){
            foundPos[0][searchResults] = backEnd.boxesName.get(i);
            foundPos[1][searchResults] = backEnd.boxesID.get(i);
          }
          searchResults++;
        }
      }
      
      // DISPLAY ALLE BOXEN DIE GEFUNDEN WERDEN
      textSize(12);
      fill(0);
      text(searchResults + " / " + backEnd.boxesID.size(), 31, frontEnd.dropDownYPos+31);
      if(searchResults!=0){
        fill(25,200,40);    //green text color if boxes found
      } else{
        fill(200,19,30);    //green text color if no boxes found
      }
      text(searchResults + " / " + backEnd.boxesID.size(), 30, frontEnd.dropDownYPos+30);
      imageMode(CENTER);
      
      for(int c=0;c<foundPos[0].length;c++){
        if(c == searchResults) return;    // dont show duplicates
        showFavs(c);
        fill(255,255-c*(255/20));
        textSize(20);
        text(foundPos[0][c],30,frontEnd.dropDownYPos+70+c*40);  //NAME
        textSize(16);
        text(foundPos[1][c],30,frontEnd.dropDownYPos+85+c*40);   //ID
        
        if(mouseX>20 && mouseX<460 && mouseY>frontEnd.dropDownYPos+50+c*40 && mouseY<frontEnd.dropDownYPos+50+(c+1)*40){
          fill(255,30);
          rect(20,frontEnd.dropDownYPos+50+c*40,485,38);
          if(mousePressed){
            /*searchWindow.setText(foundPos[1][c]);
            frontEnd.dropDown = false;
            changeCursor(char(WAIT));
            backEnd.get_box_info(foundPos[1][c], false);
            finalID = foundPos[1][c];
            diagrams.clearData();
            backEnd.getLatestMeasurements(backEnd.boxId, backEnd.sensorId[0], backEnd.created_timestamp, backEnd.realTodaysDate());
            diagrams.loadData(0);
            diagrams.mode = 0;
            delay(100);*/
            initBoxData("textSearch", c);
          }
        }
      }
     

    }else{
      if(enteredID.isEmpty()){
        searchWindow.setColor(color(255));
        searchWindow.setText("  * search by id or name *");
        isCleared = false;
      }
    }
    //if(mouseX>submitX && mouseX<submitX+wh && mouseY>submitY+frontEnd.dropDownYPos-50 && mouseY<submitY+wh+2+frontEnd.dropDownYPos-50){
    //    if(mousePressed){    //submit
    //      /*frontEnd.dropDown = false;
    //      changeCursor(char(WAIT));
    //      backEnd.get_box_info(enteredID, false);
    //      finalID = enteredID;
    //      delay(100);*/
    //      initBoxData("submitbutton", 0);
    //    }
    // }
     //backEnd.visualFeedback(finalID);
  }
  
  void loadFavs(){
    try{
      String[] lines = loadStrings(FavSave_filename + ".ini");
      for(int a = 0; a<lines.length; a++){
        String tempLine = lines[a].replaceAll(" ","");
        for(int j = 0; j<backEnd.boxesID.size(); j++){
          if(backEnd.boxesID.get(j).contains(tempLine)){
            favoriteBoxes.append(tempLine);
            d2.addItem(tempLine + "\n" + backEnd.boxesName.get(j),0); 
          }
        }
      }
      
    } catch(java.lang.RuntimeException e){
      e.printStackTrace();
    }
  }
  
  PrintWriter favsFile;
  void saveFavs(){
    favsFile = createWriter(FavSave_filename + ".ini");
    for(int i = 0; i<favoriteBoxes.size(); i++){
      favsFile.println(favoriteBoxes.get(i));
      
    }
    favsFile.flush();
    favsFile.close();
  }
  
  int indexToRemove = 0;
  
  void showFavs(int favIndex){
    imageMode(CENTER);
      //for(int favIndex=0;favIndex<foundPos[1].length;favIndex++){    // if index is not passed in void use this
        //if(c == searchResults) return;   //dont show duplicates
        
        image(favSymbol_outline, 480, frontEnd.dropDownYPos+69+favIndex*40);
        if(dist(mouseX,mouseY,480,frontEnd.dropDownYPos+69+favIndex*40) < 20){
          image(favSymbol_grey, 480, frontEnd.dropDownYPos+69+favIndex*40);
          if (mousePressed){
            if(!pressed){
              if(!favoriteBoxes.hasValue(foundPos[1][favIndex])){
                favoriteBoxes.append(foundPos[1][favIndex]);
                d2.addItem(foundPos[1][favIndex] + "\n" + foundPos[0][favIndex],0);
                delay(200);
                pressed = true;
              }else{
                for(int favBindex = 0; favBindex < favoriteBoxes.size(); favBindex++){
                  println(favoriteBoxes.get(favBindex), foundPos[1][favIndex]);
                  if(favoriteBoxes.get(favBindex) == foundPos[1][favIndex]){
                    println(favoriteBoxes.get(favBindex), foundPos[1][favIndex]);
                    indexToRemove = favBindex;
                  }
                }
                delay(200);
                pressed = true;
                favoriteBoxes.remove(indexToRemove);
                d2.removeItem(foundPos[1][favIndex] + "\n" + foundPos[0][favIndex]);
              }
            }
          }else{
            if(pressed){
              pressed = false;
            }
          }
        }
        
        
        if(favoriteBoxes != null && favoriteBoxes.size() > 0){
          for(int favBindex = 0; favBindex < favoriteBoxes.size(); favBindex++){
            if(foundPos[1][favIndex].equals(favoriteBoxes.get(favBindex))){
              image(favSymbol, 480, frontEnd.dropDownYPos+69+favIndex*40);
            }
          }
        }
   
      //}
      
      for(int favBindex = 0; favBindex < favoriteBoxes.size(); favBindex++){
        //println(favoriteBoxes.get(favBindex));
      }
      println(favoriteBoxes.size());
      imageMode(CORNER);
  }
  
  void initBoxData(String mode, int passData){
    switch(mode.toUpperCase()){
      case "SUBMITBUTTON":
          frontEnd.dropDown = false;
          changeCursor(char(WAIT));
          backEnd.get_box_info(enteredID, false);
          finalID = enteredID;
      break;
      
      case "TEXTSEARCH":
          searchWindow.setText(foundPos[1][passData]);
          frontEnd.dropDown = false;
          changeCursor(char(WAIT));
          backEnd.get_box_info(foundPos[1][passData], false);
          finalID = foundPos[1][passData];
          //backEnd.getLatestMeasurements(backEnd.boxId, backEnd.sensorId[0], backEnd.created_timestamp, backEnd.realTodaysDate());        //realTodaysDate NEEDS A FIX!!! nullen werden vernachläasssigt
          backEnd.clearValueData();
          //backEnd.getLatestMeasurements("5bf8373386f11b001aae627e", backEnd.sensorId[0], "2018-12-15T01:38:30.378Z", "2018-12-30T01:38:30.378Z");      //MUSS HIER RAUS, Einzeln "get data button machen"
      break;
    }
    if(backEnd.boxName != null){
      Tab1.activeNow =       //only update once, check if last measurement has same timestamp as time right now
            backEnd.getSpecificParamater(backEnd.lastMeasuredTime[0], "min") >= minute()-1 
            && backEnd.getSpecificParamater(backEnd.lastMeasuredTime[0], "min") <= minute()+1 
            && backEnd.getSpecificParamater(backEnd.lastMeasuredTime[0], "day") == day() 
            && backEnd.getSpecificParamater(backEnd.lastMeasuredTime[0], "hour") == hour()-1 
            && backEnd.getSpecificParamater(backEnd.lastMeasuredTime[0], "month") == month()
            && backEnd.getSpecificParamater(backEnd.lastMeasuredTime[0], "year") == year();
      delay(100);
    }
  }
}
