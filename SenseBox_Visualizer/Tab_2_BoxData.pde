class data{
  
  PShape schlauch;
  boolean schlauchIsInit = false;
  boolean diagramMode = false; //false = points, true = schlauch
  
  
  private final int dataBeginDrawOffests_X = 5; // where the first points should be drawn and where from the right they shouldnt be
  private final int dataBeginDrawOffests_Y = 5; // where the first points should be drawn and where from the right they shouldnt be
  
  void showSearchmenu(){
    showSearchbutton(int(width*0.5)-int(width*0.15),-100+frontEnd.dragged(),int(width*0.3));
  }
  
  boolean onSearchbutton;
  int searchButtoncolor;
  void showSearchbutton(int _x, int _y, int _w){
    int _h = 40;
    if(mouseX>_x && mouseX<_x+_w && mouseY>_y && mouseY<_y+_h){
      Ani.to(this, 0.05, "searchButtoncolor", 210);
      onSearchbutton = true;
    } else{
      Ani.to(this, 0.3, "searchButtoncolor", 30);
      onSearchbutton = false;
    }
    frontEnd.curvedWindow(_x,_y,_w,_h,5,color(searchButtoncolor,30,30));
    fill(255-searchButtoncolor);
    textSize(_h*0.4);
    textAlign(CENTER,CENTER);
    text("S E A R C H",_x+0.5*_w,_y+0.5*_h);
    textAlign(LEFT);
  }

  
  boolean firstOptionFieldOpen = true;
  int[] firstFieldValues = {100, 50, 33, 20, 10};
  int[] densitiesFaktor = {1, 2, 3, 5, 10};
  private int firstSelectedField = 0;
  int density = 1; // output value
  
  boolean secondOptionFieldOpen = true;
  String[] secondFieldValues = {"X-Axis", "Y-Axis"};
  int secondSelectedField = 0; //output rect
  float coloration = 0; //output color
  
  boolean thirdOptionFieldOpen = true;
  int thirdSelectedField = 0;
  
  boolean isGridActive = true;
  boolean isEveryTenLine = false;
  int lineThicker = 10;    //die wievielte linie breiter in grid sein soll
  
  void showGraphs_test(int x, int y, int w, int h, int alpha, String X, String Y)
  {
    //x = x+dataBeginDrawOffests_X; w = w-dataBeginDrawOffests_X;
    //y = y - dataBeginDrawOffests_Y; h = h-dataBeginDrawOffests_Y;
    stroke(0);
    strokeWeight(2);
    line(x,y,x,y+h);
    line(x,y+h,x+w,y+h);
    
    stroke(50,50);
    strokeWeight(1);
    
    textSize(10);
    fill(0);
    text(Y,x,y-20);
    text(X,x+w+10,y+h);
    
    noStroke();
    
    triangle(x-5,y,x+5,y,x,y-10);
    triangle(x+w+10,y+h,x+w,y+h-5,x+w,y+h+5);
    
    
    
    // FIELD 1#
    
    fill(40);
    rect(x,y+h+100,100,40);
    fill(255);
    textSize(13);
    textAlign(CENTER,CENTER);
    text("Density",x+50,y+h+120);
    if(mouseX>x && mouseX<x+100 && mouseY>y+h+100 && mouseY<y+h+140){
      if(mousePressed){
        firstOptionFieldOpen = true;
      }
    }
    if(firstOptionFieldOpen)
    {
        for(int i = 0; i<firstFieldValues.length; i++){
          fill(80);
          if(mouseX>x && mouseX<x+100 && mouseY>y+h+160+(i)*42 && mouseY<y+h+160+(i+1)*42){
            if(mousePressed){
             // firstOptionFieldOpen = false;
             firstSelectedField = i;
             density = densitiesFaktor[i];
            }
            fill(120);
          }
          rect(x,y+h+160 + 42 * i, 100, 40);
          fill(200,20,50);
          rect(x,y+h+160 + 42 * firstSelectedField, 100, 40);
          fill(255);
          text(firstFieldValues[firstSelectedField] + " %",x+50,y+h+180+(firstSelectedField)*42);
          text(firstFieldValues[i] + " %",x+50,y+h+180+(i)*42);
        }
    }
    
    // FIELD 2#
    
    fill(40);
    rect(x+200,y+h+100,100,40);
    fill(255);
    textSize(13);
    textAlign(CENTER,CENTER);
    text("Coloration",x+50+200,y+h+120);
    if(mouseX>x+200 && mouseX<x+300 && mouseY>y+h+100 && mouseY<y+h+140){
      if(mousePressed){
        secondOptionFieldOpen = true;
      }
    }
    if(secondOptionFieldOpen)
    {
        for(int i = 0; i<secondFieldValues.length; i++){
          fill(80);
          if(mouseX>x+200 && mouseX<x+300 && mouseY>y+h+160+(i)*42 && mouseY<y+h+160+(i+1)*42){
            if(mousePressed){
             // secondOptionFieldOpen = false;
             secondSelectedField = i;
            }
            fill(120);
          }
          rect(x+200,y+h+160 + 42 * i, 100, 40);
          fill(200,20,50);
          rect(x+200,y+h+160 + 42 * secondSelectedField, 100, 40);
          fill(255);
          text(secondFieldValues[secondSelectedField],x+50+200,y+h+180+(secondSelectedField)*42);
          text(secondFieldValues[i],x+50+200,y+h+180+(i)*42);
        }
    }
    
    // FIELD 3#
    
    fill(40);
    rect(x+400,y+h+100,200,40);
    fill(255);
    textSize(13);
    textAlign(CENTER,CENTER);
    text("Sensor",x+100+400,y+h+120);
    if(mouseX>x+400 && mouseX<x+600 && mouseY>y+h+100 && mouseY<y+h+140){
      if(mousePressed){
        thirdOptionFieldOpen = true;
      }
    }
    if(thirdOptionFieldOpen)
    {
        for(int i = 0; i<backEnd.sensorName.length; i++){
          fill(80);
          if(mouseX>x+400 && mouseX<x+600 && mouseY>y+h+160+(i)*42 && mouseY<y+h+160+(i+1)*42){
            if(mousePressed){
              //thirdOptionFieldOpen = false;
              thirdSelectedField = i;
            }
            createTempWindow(i);
            fill(120);
          }
          rect(x+400,y+h+160 + 42 * i, 200, 40);
          
          textSize(13);
          fill(200,20,50);
          rect(x+400,y+h+160 + 42 * thirdSelectedField, 200, 40);
          fill(255);
          text(backEnd.sensorName[thirdSelectedField],x+100+400,y+h+180+(thirdSelectedField)*42);
          text(backEnd.sensorName[i],x+100+400,y+h+180+(i)*42);
        }
    }
    
    // imageButtons settings
    frontEnd.imageButton(x+w-120, y-50, 40, gridSetting1, color(200),isGridActive);
    if(frontEnd.onimageButton(x+w-120, y-50, 40)){
      if(mousePressed){
        isGridActive = !isGridActive;
        delay(100);
      }
    }
    frontEnd.imageButton(x+w-70, y-50, 40, gridSetting2, color(200),isEveryTenLine);
    if(frontEnd.onimageButton(x+w-70, y-50, 40)){
      if(mousePressed){
        isEveryTenLine = !isEveryTenLine;
        delay(100);
      }
    }
    frontEnd.imageButton(x+w-70,y-110,40,gridSetting3,color(200),diagramMode);
    if(frontEnd.onimageButton(x+w-70, y-110, 40)){
      if(mousePressed){
        diagramMode = !diagramMode;
        delay(100);
      }
    }
    if(inZoomedMode){
      frontEnd.imageButton(x+w-70,y+5,40,backArrow,color(200),!inZoomedMode);
      if(frontEnd.onimageButton(x+w-70, y+5, 40)){
        if(mousePressed){
          inZoomedMode = false;
          zoomWindowReset();
          delay(100);
        }
      }
    }
    
    noStroke();
    
    // coloration skala
    
    for(int colScale = 0; colScale < 255; colScale++){
      fill(colScale,255-colScale,250);
      rect(x+w-400 + colScale, y-50, 1, 40);
      
    }
    fill(0);
    textSize(12);
    if(secondSelectedField == 0){
      textAlign(LEFT,BOTTOM);
      text("Time (h)", x+w-400, y-70);
      text("0", x+w-400, y-52);
      textAlign(RIGHT,BOTTOM);
      text("24", x+w-145, y-52);
      
    }else{
      textAlign(LEFT,BOTTOM);
      text(backEnd.minValue, x+w-400, y-52);
      text("Unit (" + backEnd.unit[thirdSelectedField] + ")", x+w-400, y-70);
      textAlign(RIGHT,BOTTOM);
      text(backEnd.maxValue, x+w-145, y-52);
    }
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(x+w-400, y-50, 255, 40);
    noStroke();
    
    
    //--------------------------------------------------
    if(!backEnd.allData_result_success)     //if data has not been gotten no need for further drawing of DATA in graph
      return;
    
    
    // sensorname etc.
    
    fill(0);
    textSize(15);
    textAlign(LEFT,CENTER);
    text(
    "Sensorname: " + backEnd.sensorName[thirdSelectedField] + "\n" + 
    "SensorID: " + backEnd.sensorId[thirdSelectedField] + "\n" + 
    "Sensortyp: " + backEnd.sensor_type[thirdSelectedField] + "\n" + 
    "Einheit: " + backEnd.unit[thirdSelectedField] + "\n" + 
    "Value Amount: " + backEnd.allVal.size() + "\n"
    , x, y-80
    );
    
    //X-Achse Beschriftung
    
    textSize(14);
    textAlign(LEFT,CENTER);
    text(Cal.selectedDates[0][0] + "." + Cal.selectedDates[0][1] + "." + Cal.selectedDates[0][2], x, y+h+10);
    textAlign(RIGHT,CENTER);
    text(Cal.selectedDates[1][0] + "." + Cal.selectedDates[1][1] + "." + Cal.selectedDates[1][2], x+w, y+h+10);
    
    //show zoom window where you can zoom into points
    createZoomwindow(y,h,x, x+w);
    
    //Y-Achse Beschriftung
    // Grid
    
    if(isGridActive)    //wenn gitter überhaupt an ist
    {
      fill(0,200);
      stroke(0,200);
      textAlign(RIGHT, BOTTOM);
      textSize(10);
      
      
      for(int i = int(backEnd.minValue); i < int(backEnd.maxValue); i++){
        if(abs(backEnd.maxValue - backEnd.minValue) < 99){
          lineThicker = 10;
        }else if(abs(backEnd.maxValue - backEnd.minValue) < 1000 && abs(backEnd.maxValue - backEnd.minValue) >= 100){
          lineThicker = 100;
        }else{
          lineThicker = 1000;
        }
        float gridY = map(i, backEnd.minValue, backEnd.maxValue, y+h, y);
        if(gridY > y && gridY < y+h){
          if(i%lineThicker == 0){
            strokeWeight(0.9);    //jede 10te linie dicker
          } else{
            strokeWeight(0.55);
          }
          
          if(isEveryTenLine){    //WENN option jede zehnte zeigen an ist, jede zehnte anzeigen
            if(i%lineThicker == 0){
              line(x,gridY, x+w, gridY);
              text(i,x-4, gridY);
            }
          }else{
            line(x,gridY, x+w, gridY);
            text(i,x-4, gridY);
          }
          
          
        }
      }
      noStroke();
      
      
    }
    
    //experimental
    if(!diagramMode){    //ALL POINTS
      //SHOW all points
      println(firstIndex, lastIndex);
      for(int i = firstIndex; i<lastIndex; i++){
        if(secondSelectedField == 0){
          coloration = map(backEnd.getSpecificParamater(backEnd.allDate.get(i),"hour"),0,23,0,255);    //X-Achse : Tag
        } else if(secondSelectedField == 1){
          coloration = map(backEnd.allVal.get(i),backEnd.minValue,backEnd.maxValue,0,255);      //Y-Achse einfärbung, Sensordaten
        }
        //float dayColor = map(backEnd.getSpecificParamater(backEnd.allDate.get(i),"day"),1,31,0,255);
        fill(coloration,255-coloration,250);
        // FILTER!!
        if(i % density == 0){
          float mappedX = map(i,firstIndex,lastIndex, x, x+w);
          ellipse(mappedX, map(backEnd.allVal.get(i), backEnd.minValue, backEnd.maxValue, y+h, y),2,2);      //maybe Colored LINES?
          //line(map(mouseX,x,x+w,0,backEnd.allVal.size()),y+2,map(mouseX,x,x+w,0,backEnd.allVal.size()),y+h-2);
        }
      }
    }
    
    //--------Modus des Diagramms wählen
    
    if(diagramMode){
      //if(!schlauchIsInit){      //MAYBE USE THIS AS AN OUTLINE IF SELECTED! cuzu cant color it only one soliod color
        schlauch = createShape();
        schlauch.beginShape();
        schlauch.noFill();
        schlauch.strokeWeight(1);
        schlauch.setStroke(true);
        schlauch.stroke(15,69,200);
        schlauch.vertex(x,y+h);
        for(int verts = firstIndex; verts < lastIndex; verts++){
          schlauch.vertex(map(verts,firstIndex,lastIndex, x, x+w), map(backEnd.allVal.get(verts), backEnd.minValue, backEnd.maxValue, y+h, y));
        }
        schlauch.vertex(x+w,y);
        schlauch.endShape();
        schlauchIsInit = true;
      //}
      
      if(schlauchIsInit){
        shape(schlauch,x+w-schlauch.width,y+h-schlauch.height);
        println(schlauch.width, schlauch.height);
      }
    }
    
    float durSY = map(backEnd.durchSchnitt,backEnd.minValue, backEnd.maxValue, y+h, y);
    textAlign(LEFT, BOTTOM);
    strokeWeight(0.8);
    stroke(255,20,20);
    line(x-x*0.4, durSY, x+w, durSY);
    fill(255,20,20);
    textSize(10);
    text(backEnd.durchSchnitt,x-x*0.4, durSY-5);
    
    textAlign(LEFT,CENTER);
    if((pmouseX> x && pmouseX < x+w) && (mouseY>y && mouseY<y+h*1.2) && backEnd.allVal.size() >= 1){    //if Array is not empty! otherwise its gonna throw exception Arrayindexoutofbounds
      float CurX = map(pmouseX,x,x+w,firstIndex,lastIndex);
      stroke(225,32,229);
      strokeWeight(1.2);
      line(pmouseX,y,pmouseX,y+h*1.2);
      fill(255);
      ellipse(map(map(pmouseX,x,x+w,firstIndex,lastIndex),firstIndex, lastIndex, x, x+w), map(backEnd.allVal.get(int(CurX) ), backEnd.minValue, backEnd.maxValue, y+h, y),7,7);
      textSize(12);
      fill(0);
      text("Datum: \t"  + backEnd.to_realTime(backEnd.allDate.get(int(CurX))),pmouseX+10,pmouseY-15);  //y+h*1.2-15
      text("Wert: \t" + backEnd.allVal.get(int(CurX)),pmouseX+10,pmouseY);                             // y+h*1.2
    }
    
    noStroke();
  }
  
  void createTempWindow(int selectedItem){
    fill(80);
    rect(mouseX+20, mouseY+20, 400,400);
    fill(255);
    textSize(15);
    text("IMAGE OF CURRENT SENSOR AND INFOS",mouseX+220, mouseY+220);
    text(backEnd.sensorId[selectedItem],mouseX+220, mouseY+240);
    text(backEnd.sensorName[selectedItem],mouseX+220, mouseY+260);
    text(backEnd.sensor_type[selectedItem],mouseX+220, mouseY+280);
  }
  
  private int startPoint = 0;    //saved X coord of 1st poit
  private int endingPoint = 0;    //save X coord of last drawn point of rect
  private boolean isStartPointChosen = false;
  private int firstIndex, lastIndex;
  private boolean inZoomedMode = false;
  FloatList tempValues = new FloatList();
  
  void zoomWindowReset(){
    firstIndex = 0;
    lastIndex = backEnd.allVal.size();
    tempValues.clear();
  }
  
  void createZoomwindow(int _Y, int _H, int startingP, int endingP){    //beginning of points, end of P
    if(mousePressed && mouseButton == RIGHT && mouseX > startingP && mouseX < endingP)
    {
      if(!inZoomedMode){    
        if(!isStartPointChosen){ //execute once, save X coord
          startPoint = mouseX;
          isStartPointChosen = true;
        }
        int endPoint = mouseX-startPoint;
        fill(0,20);
        rect(startPoint, _Y, endPoint, _H);
        endingPoint = startPoint + abs(mouseX - startPoint);
      }
    } else
    {
      if(isStartPointChosen){ 
        isStartPointChosen = false;
        inZoomedMode = true;
        //fill values
        firstIndex = int(map(startPoint,startingP,endingP, 0, backEnd.allVal.size()));
        lastIndex = int(map(endingPoint,startingP,endingP, 0, backEnd.allVal.size()));
        for(int counts = firstIndex; counts < lastIndex; counts++){
          tempValues.append(backEnd.allVal.get(counts));
        }
      }
    }
    if(keyPressed && key == 'j'){
      inZoomedMode = false;
      zoomWindowReset();
    }
  }
  
  float durchSchnitt(float[] daten){
    float alleWerte = 0;
    int count = 0;
    for(int i = 0; i<daten.length; i++){
      if(daten[i] != 0){
        alleWerte += daten[i];
        count++;
      }
    }
    return alleWerte/count;
  }
  float durchSchnitt(FloatList daten){
    float alleWerte = 0;
    int count = 0;
    for(int i = 0; i<daten.size(); i++){
      if(daten.get(i) != 0){
        alleWerte += daten.get(i);
        count++;
      }
    }
    return alleWerte/count;
  }
  
}
