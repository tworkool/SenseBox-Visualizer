BoxInfo Tab1 = new BoxInfo();
settings Tab3 = new settings();
data Tab2 = new data();

class tabData{
  final public int tabCount = 3;   //how many tabs
  int currentSideVisible = 0;    //welcher Tab gerade offen ist
  
  // Ist die Maus über dem Tab menu?
  boolean overTab1 = false;
  boolean overTab2 = false;
  boolean overTab3 = false;
  
  String[] tabNames = {"Box Info", "Graphs", "Settings"};
  int tabNamesTextSize = 15;
  /*
  void showTabSelection(){
    //tint(255);
    //image(showTabs, 23, height-20);
    for(int i = 0; i < tabNames.length; i++){
      fill(50);
      if(mouseX>i*length && mouseX<length*(i+1) && mouseY > height-40 && mouseY<height){
        fill(200);
      }
      rect(0,height-40, length, 40);
    }
    textSize(tabNamesTextSize);
    fill(255);
    textAlign(BOTTOM);
    text("Box Info", 27, height-4);
    text("Graphs", 152, height-4);
    text(".......", 262, height-4);
  }
  */
  void showTabSelection(){
    //tint(255);
    //image(showTabs, 23, height-20);
    textAlign(CENTER,TOP);
    textSize(tabNamesTextSize);
    for(int i = 0; i < tabNames.length; i++){
      int length = 0;
      for(int j = 0; j < i; j++){
        length += tabNames[j].length()*tabNamesTextSize;
      }
      if(mouseX>length && mouseX<length+tabNames[i].length()*tabNamesTextSize && mouseY > height-30 && mouseY<height){
        switch(i){
          case 0:
            overTab1 = true;
          break;
          case 1:
            overTab2 = true;
          break;
          case 2:
            overTab3 = true;
          break;
        }
        fill(primColor);
        rect(length,height-60, tabNames[i].length()*tabNamesTextSize, 60);
      } else{
        switch(i){
          case 0:
            overTab1 = false;
          break;
          case 1:
            overTab2 = false;
          break;
          case 2:
            overTab3 = false;
          break;
        }
        fill(70);
        rect(length,height-30, tabNames[i].length()*tabNamesTextSize, 30);
      }
      fill(255);
      text(tabNames[i], length + tabNames[i].length()*tabNamesTextSize * 0.5, height-25);
    }
    /*println("adadadad" + overTab1,overTab2,overTab3);
    textSize(tabNamesTextSize);
    fill(255);
    textAlign(BOTTOM);
    text("Box Info", 27, height-4);
    text("Graphs", 152, height-4);
    text(".......", 262, height-4);*/
  }

  
  void showSideLayout(){
    switch(currentSideVisible){
      case 1:
         //Tab2.showGraphs(int(width*0.1),frontEnd.dragged()+150,int(width*0.8),int(height*0.5),0,"Datum","Werte",10,10);
         //Tab2.showGraphs_test(int(width*0.1),frontEnd.dragged()+150,int(width*0.8),int(height*0.5),0,"Datum","Werte");
         Cal.showWidget();
         Tab2.showSearchmenu();
         table1.updateScreen(100, 430, int(width-200), 600);
         table1.showAxis();
         if(backEnd.boxName != null){
           ts.updateScreen();
           ts.showSelectionMenu();
           ts.showDiagramInfo();
           ts.showSettings();
           ts.colorationLegende();
           if(backEnd.allData_result_success && backEnd.allVal.size()>0){
               table1.selectGraph(color(0,15),10);
               table1.showGrid();
               if(!ts.inZoomedMode){
                 table1.showDurchschnittLinie();
               }
               table1.showPoints();
               table1.showSelectingLine();
               table1.beschriftungX();
               table1.createZoomwindow();
               //table1.showLightintensityVisual();
           }
         }else{
             
             fill(0,50);
             rect(0,0,width,height);
             textSize(28);
             textAlign(CENTER,CENTER);
             text("P L E A S E   S E L E C T   B O X",width/2,height/2);
           }
       break;
      
      case 0:
        if(backEnd.boxName != null){
          if(backEnd.boxesDiff > 0){
            frontEnd.curvedWindow(10,-30+frontEnd.dragged(),width-100,25,4,secColor);
            textSize(18);
            fill(255);
            //text(backEnd.BoxZuwachs*100.0 + " % mehr Boxen wurden seit deinem letzten Besuch am " + backEnd.lastDate + " installiert!", width * 0.1, -100+frontEnd.dragged());
            textAlign(LEFT,CENTER);
            text(backEnd.boxesDiff + " (" + nf(backEnd.BoxZuwachs*100.0, 0, 2) + "%)"+" neue Boxen wurden seit deinem letzten Besuch am " + backEnd.lastDate + " installiert!", 30, -20+frontEnd.dragged());
          }
        
          Tab1.showBoxInfo();
         }
        break;
      
      case 2:
        Tab3.showFeedBackButton();
        Tab3.showLibraryReference(200+frontEnd.dragged(), 50, 10);
        Tab3.show_SettingButtons();
        //Tab3.showAPIconsole(600+frontEnd.dragged());
        break;
    }
    showTabSelection();
  }
}

void mouseReleased(){
  onMouseReleased = true;
  
  
  if(tabs.overTab1){
    tabs.currentSideVisible = 0;
  }
  if(tabs.overTab2){
    tabs.currentSideVisible = 1;
  }
  if(tabs.overTab3){
    tabs.currentSideVisible = 2;
  }
  
  if(controlp5.onSubmitbutton()){
      controlp5.initBoxData("submitbutton", 0);
  }
  
  if(!tabs.overTab1 && !tabs.overTab2 && !tabs.overTab3 && !frontEnd.isOnDropdown()){
    
    if(tabs.currentSideVisible == 1){
      if(Tab2.onSearchbutton){
        backEnd.clearValueData();
        if(backEnd.boxId != null && backEnd.boxId != "" && backEnd.result_success){
          println(backEnd.boxId);
          println(backEnd.boxId, backEnd.sensorId[Tab2.thirdSelectedField], backEnd.to_rfcTime(Cal.selectedDates[0][0],Cal.selectedDates[0][1],Cal.selectedDates[0][2],"00:00:00"), backEnd.to_rfcTime(Cal.selectedDates[1][0],Cal.selectedDates[1][1],Cal.selectedDates[1][2],"00:00:00"));
          //backEnd.getLatestMeasurements(backEnd.boxId, backEnd.sensorId[Tab2.thirdSelectedField], backEnd.to_rfcTime(Cal.selectedDates[0][0],Cal.selectedDates[0][1],Cal.selectedDates[0][2],"00:00:00"), backEnd.to_rfcTime(Cal.selectedDates[1][0],Cal.selectedDates[1][1],Cal.selectedDates[1][2],"00:00:00"));
          backEnd.getLatestMeasurements(backEnd.boxId, backEnd.sensorId[ts.thirdSelectedField], backEnd.to_rfcTime(Cal.selectedDates[0][0],Cal.selectedDates[0][1],Cal.selectedDates[0][2],"00:00:00"), backEnd.to_rfcTime(Cal.selectedDates[1][0],Cal.selectedDates[1][1],Cal.selectedDates[1][2],"00:00:00"));
        } else{
          frontEnd.setCopyInfo("please select a Box first!");
        }
    }
      
      if(ts.onOpenData) {
        launch(sketchPath() + "/" + backEnd.DATA_Log_name);
      }
      if(ts.onOpenLog){
        launch(sketchPath() + "/" + backEnd.HTTP_Log_name);
      }
    }
    
    if(tabs.currentSideVisible == 2){
      if(Tab3.onFeedBackbutton()){
        link("http://processingjs.org");
      }
      for(int i = 0; i< Tab3.selectedRect.length; i++){
        if(Tab3.selectedRect[i]){
          link(Tab3.texts[i][Tab3.texts[i].length-1]);
        }
      }
    }
  }
}
