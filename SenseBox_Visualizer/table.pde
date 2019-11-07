table table1;
tableSettings ts = new tableSettings();

class table{
  private int tx,ty,tw,th;
  public int X = 0;
  public int Y = 0;
  public int W = 0;
  public int H = 0;
  
  PShape schlauch;
  PShape Arrow;
  boolean schlauchIsInit = false;
  
  /*table(float _x, int _y, float _w, int _h)
  {
    y = int(_x);
    y = _y;
    w = int(_w);
    h = _h;
  }*/
  
  public void updateScreen(int x, int y, int w, int h){Y = y+frontEnd.dragged(); X = x; W = w; H = h;}
  
  public String YaxisName = "";
  public String XaxisName = "";
  
  public final int offsetX = 2;
  public final int offsetY = 2;
  
  public void showLightintensityVisual(){
    if(backEnd.sensor_type[ts.compareSensorsIndex[1]].equals("VEML6070") || backEnd.sensor_type[ts.compareSensorsIndex[1]].equals("TSL45315")){
      colorMode(HSB);
      strokeWeight(1);
      for(int i = ts.firstIndex; i<ts.lastIndex; i++){
        stroke(58, 100, map(backEnd.allVal.get(i), backEnd.minValue, backEnd.maxValue, 0, 100));
        line(map(i,ts.firstIndex,ts.lastIndex, X+offsetX, X+W), map(backEnd.allVal.get(i), backEnd.minValue, backEnd.maxValue, Y+H-offsetY, Y), map(i,ts.firstIndex,ts.lastIndex, X+offsetX, X+W), 0);
      }
      colorMode(RGB);
    }
  }
  
  void showAxis(){
    stroke(0);
    strokeWeight(1.4);
    line(X,Y,X,Y+H);
    line(X,Y+H,X+W,Y+H);
    
    stroke(50,50);
    strokeWeight(1);
    
    textSize(10);
    fill(0);
    textAlign(RIGHT,TOP);
    text("Values",X-5,Y);
    textAlign(RIGHT,TOP);
    text("Date",X+W,Y+H+5);
    
    noStroke();
    
    //shape(Arrow, X, Y);
    triangle(X-5,Y,X+5,Y,X,Y-10);
    triangle(X+W+10,Y+H,X+W,Y+H-5,X+W,Y+H+5);
  }
  
  void createArrowShape(){
    Arrow = createShape();
    Arrow.beginShape();
    Arrow.fill(0);
    Arrow.vertex(103,200);
    Arrow.vertex(110,180);
    Arrow.vertex(117,200);
    Arrow.vertex(110,194);
    Arrow.endShape();
  }
  
  void beschriftungX(){
    textAlign(CENTER,CENTER);
    textSize(10);
    fill(0);
    int numCount = 0;
    for(int i = ts.firstIndex; i<ts.lastIndex; i++){
      if(backEnd.getSpecificParamater(backEnd.allDate.get(i),"min") == 1 || i == ts.firstIndex || i == ts.lastIndex-1){
        //String txt = backEnd.getSpecificParamater(backEnd.allDate.get(i),"day") + "." + backEnd.getSpecificParamater(backEnd.allDate.get(i),"month");
        //String txt = backEnd.getSpecificParamater(backEnd.allDate.get(i),"hour") + ":" + backEnd.getSpecificParamater(backEnd.allDate.get(i),"min");
        String txt = backEnd.getSpecificParamater(backEnd.allDate.get(i),"hour") + " Uhr";
        numCount++;
        text(txt, map(i,ts.firstIndex,ts.lastIndex, X+offsetX, X+W),Y+H+10+12*(numCount%2));
        println(backEnd.getSpecificParamater(backEnd.allDate.get(i),"min"));
      }
    }
    println(numCount);
  }
  
  public void showPoints(){
    //if(!ts.diagramMode){    //ALL POINTS
      //SHOW all points
      println(ts.firstIndex, ts.lastIndex);
      for(int i = ts.firstIndex; i<ts.lastIndex; i++){
        if(ts.secondSelectedField == 0){
          ts.coloration = map(backEnd.getSpecificParamater(backEnd.allDate.get(i),"hour"),0,23,0,255);    //X-Achse : Tag
        } else if(ts.secondSelectedField == 1){
          ts.coloration = map(backEnd.allVal.get(i),backEnd.minValue,backEnd.maxValue,0,255);      //Y-Achse einfärbung, Sensordaten
        }
        //float dayColor = map(backEnd.getSpecificParamater(backEnd.allDate.get(i),"day"),1,31,0,255);
        fill(ts.coloration,255-ts.coloration,250);
        // FILTER!!
        if(i % ts.density == 0){
          float mappedX = map(i,ts.firstIndex,ts.lastIndex, X+offsetX, X+W);
          if(!ts.diagramMode){
            ellipse(mappedX, map(backEnd.allVal.get(i), backEnd.minValue, backEnd.maxValue, Y+H-offsetY, Y),2,2);      //maybe Colored LINES?
          //line(map(mouseX,X+offsetX,X+W,ts.firstIndex,ts.lastIndex),Y,map(mouseX,X,X+W,0,backEnd.allVal.size()),Y+H);
          }else{
            if(i != backEnd.allVal.size()-1){
              stroke(ts.coloration,255-ts.coloration,250);
              line(mappedX, map(backEnd.allVal.get(i), backEnd.minValue, backEnd.maxValue, Y+H-offsetY, Y), map(i+1,ts.firstIndex,ts.lastIndex, X+offsetX, X+W), map(backEnd.allVal.get(i+1), backEnd.minValue, backEnd.maxValue, Y+H-offsetY, Y));
            }
          }
        }
      }
    //}
  }
  
  public void selectGraph(color c, float stroke){
    //if(ts.diagramMode){
      //if(!schlauchIsInit){      //MAYBE USE THIS AS AN OUTLINE IF SELECTED! cuzu cant color it only one soliod color
        schlauch = createShape();
        schlauch.beginShape();
        schlauch.noFill();
        //if(stroke > 0.2){
        //  stroke = map(abs(ts.firstIndex-ts.lastIndex), 100, 1000, 10, 4);
        //}else{
        //  stroke = 0.2;
        //}    // Stroke has negative width when a lkot of data!!
        schlauch.strokeWeight(stroke);
        schlauch.setStroke(true);
        schlauch.stroke(c);
        schlauch.vertex(X,Y+H);
        for(int verts = ts.firstIndex; verts < ts.lastIndex; verts++){
          schlauch.vertex(map(verts,ts.firstIndex,ts.lastIndex, X+offsetX, X+W), map(backEnd.allVal.get(verts), backEnd.minValue, backEnd.maxValue, Y+H-offsetY, Y));
        }
        schlauch.vertex(X+W,Y);
        schlauch.endShape();
        schlauchIsInit = true;
      //}
      
      if(schlauchIsInit){
        shape(schlauch,X+W-schlauch.width,Y+H-schlauch.height);      // draws a lot of memory!
        println(schlauch.width, schlauch.height);
      }
    //}
  }
  
  private float durchschnittY;
  public void showDurchschnittLinie(){
    durchschnittY = map(backEnd.durchSchnitt,backEnd.minValue, backEnd.maxValue, Y+H-offsetY, Y);
    textAlign(LEFT, BOTTOM);
    //strokeWeight(0.8);
    //stroke(255,20,20);
    //line(X-50, durchschnittY, X+W, durchschnittY);
    fill(255,20,20);
    frontEnd.dottedLine(X-50, int(durchschnittY), X+W, int(durchschnittY), 5, 2);
    fill(255,20,20);
    textSize(10);
    text(backEnd.durchSchnitt,X-50, durchschnittY-5);
    noStroke();
  }
  
  void showSelectingLine(){
    textAlign(LEFT,CENTER);
    if((pmouseX> X+offsetX && pmouseX < X+W) && (mouseY>Y && mouseY<Y+H+50-offsetY) && backEnd.allVal.size() >= 1){    //if Array is not empty! otherwise its gonna throw exception Arrayindexoutofbounds
      float CurX = map(pmouseX,X+offsetX,X+W,ts.firstIndex,ts.lastIndex);
      //stroke(225,32,229);
      fill(255);
      stroke(50);
      strokeWeight(1.2);
      line(pmouseX,Y,pmouseX,Y+H+50);
      fill(255);
      ellipse(map(map(pmouseX,X+offsetX,X+W,ts.firstIndex,ts.lastIndex),ts.firstIndex, ts.lastIndex, X+offsetX, X+W), map(backEnd.allVal.get(int(CurX) ), backEnd.minValue, backEnd.maxValue, Y+H-offsetY, Y),6,6);
      textSize(12);
      //fill(0);
      frontEnd.shadowedText("Datum: \t"  + backEnd.to_realTime(backEnd.allDate.get(int(CurX))),pmouseX+10,pmouseY-15,1,color(200));
      frontEnd.shadowedText("Wert: \t" + backEnd.allVal.get(int(CurX)),pmouseX+10,pmouseY,1,color(200));
      //text("Datum: \t"  + backEnd.to_realTime(backEnd.allDate.get(int(CurX))),pmouseX+10,pmouseY-15);  //y+h*1.2-15
      //text("Wert: \t" + backEnd.allVal.get(int(CurX)),pmouseX+10,pmouseY);                             // y+h*1.2
    }
    noStroke();
  }
  
  private int startPoint = 0;    //saved X coord of 1st poit
  private int endingPoint = 0;    //save X coord of last drawn point of rect
  private boolean isStartPointChosen = false;
  FloatList tempValues = new FloatList();
  
  void createZoomwindow(){    //beginning of points, end of P
    if(mousePressed && mouseButton == RIGHT && mouseX > X+offsetX && mouseX < X+W)
    {
      if(!ts.inZoomedMode){    
        if(!isStartPointChosen){ //execute once, save X coord
          startPoint = mouseX;
          isStartPointChosen = true;
        }
        int endPoint = mouseX-startPoint;
        fill(0,20);
        rect(startPoint, Y, endPoint, H);
        endingPoint = startPoint + abs(mouseX - startPoint);
      }
    } else
    {
      if(isStartPointChosen){ 
        isStartPointChosen = false;
        ts.inZoomedMode = true;
        //fill values
        ts.firstIndex = int(map(startPoint,X+offsetX,X+W, 0, backEnd.allVal.size()));
        ts.lastIndex = int(map(endingPoint,X+offsetX,X+W, 0, backEnd.allVal.size()));
        for(int counts = ts.firstIndex; counts < ts.lastIndex; counts++){
          tempValues.append(backEnd.allVal.get(counts));
        }
      }
    }
    if(keyPressed && key == 'j'){
      ts.inZoomedMode = false;
      zoomWindowReset();
    }
  }
  
  void zoomWindowReset(){
    ts.firstIndex = 0;
    ts.lastIndex = backEnd.allVal.size();
    tempValues.clear();
  }
  
  void showGrid(){
    if(ts.isGridActive)    //wenn gitter überhaupt an ist
    {
      fill(0,200);
      stroke(0,200);
      textAlign(RIGHT, BOTTOM);
      textSize(10);
      
      
      for(int i = int(backEnd.minValue); i < int(backEnd.maxValue); i++){
        if(abs(backEnd.maxValue - backEnd.minValue) < 99){
          ts.lineThicker = 10;
        }else if(abs(backEnd.maxValue - backEnd.minValue) < 1000 && abs(backEnd.maxValue - backEnd.minValue) >= 100){
          ts.lineThicker = 100;
        }else{
          ts.lineThicker = 1000;
        }
        float gridY = map(i, backEnd.minValue, backEnd.maxValue, Y+H, Y);
        if(gridY > Y && gridY < Y+H){
          if(i%ts.lineThicker == 0){
            strokeWeight(1);    //jede 10te linie dicker
          } else{
            strokeWeight(0.5);
          }
          
          if(ts.isEveryTenLine){    //WENN option jede zehnte zeigen an ist, jede zehnte anzeigen
            if(i%ts.lineThicker == 0){
              line(X,gridY, X+W, gridY);
              text(i,X-4, gridY);
            }
          }else{
            line(X,gridY, X+W, gridY);
            text(i,X-4, gridY);
          }
          
          
        }
      }
      noStroke();
      
      
    }
  }
  
  float durchSchnitt(float[] daten){
    float alleWerte = 0;
    int count = 0;
    for(int i = ts.firstIndex; i<ts.lastIndex; i++){
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
    for(int i = ts.firstIndex; i<ts.lastIndex; i++){
      if(daten.get(i) != 0){
        alleWerte += daten.get(i);
        count++;
      }
    }
    return alleWerte/count;
  }
}

public class tableSettings{
  
  final int maxChooseSensors = 2;
  int selectedSensors = 1;              // how many sensors are selected
  
  //----------------------- FELDER UNTER DIA
  private final int zwischenRaumAbstand = 10;
  private final int fieldTotal = 3;
  private final int fieldZwischenRaumTotal = fieldTotal-1;
  
  int tempX;
  int tempW;
  
  float fieldW;
  
  private boolean firstOptionFieldOpen = true;
  private boolean secondOptionFieldOpen = true;
  private boolean thirdOptionFieldOpen = true;
  
  //1
  int[] firstFieldValues = {100, 50, 33, 20, 10};
  int[] densitiesFaktor = {1, 2, 3, 5, 10};
  private int firstSelectedField = 0;
  int density = 1; // output value
  //2
  String[] secondFieldValues = {"X-Axis", "Y-Axis"};
  int secondSelectedField = 0; //output rect
  float coloration = 0; //output color
  //3
  int thirdSelectedField = 0;  //output
  int[] compareSensorsIndex = {0,0};    // indecies of selected sensors
  
  //-------------------------------------------
  
  //grid
  boolean isGridActive = true;
  boolean isEveryTenLine = false;
  int lineThicker = 10;    //die wievielte linie breiter in grid sein soll
  
  int fieldOffset = 240;
  int settingOffset = 140;
  int sensorOverViewOffset = -170;
  
  void updateScreen(){tempX = table1.X; tempW= table1.W; fieldW = (tempW - zwischenRaumAbstand*fieldZwischenRaumTotal)/fieldTotal; sensorwindowAbstand = tempW/selectedSensors;}
  
  int firstIndex = 0;
  int lastIndex = backEnd.allVal.size();
  
  boolean diagramMode = false;
  boolean inZoomedMode = false;
  
  public void showSettings(){
    noStroke();
    fill(80);
    rect(table1.X, table1.Y + table1.H + settingOffset-10, table1.W/2-100, 60);
    for(int j = 0; j<5;j++){
      fill(80,255-100/6*j);
      rect(table1.X+table1.W/2-100 + 100/5 * j, table1.Y + table1.H + settingOffset-10, 100/5, 60);
    }
    fill(80);
    textAlign(LEFT,BOTTOM);
    textSize(24);
    text(".SETTINGS",table1.X, table1.Y + table1.H + settingOffset-10);
    
    frontEnd.imageButton(tempX+50, table1.Y+table1.H+settingOffset, 40, gridSetting1, color(200),isGridActive);
    if(frontEnd.onimageButton(tempX+50, table1.Y+table1.H+settingOffset, 40)){
      if(mousePressed){
        isGridActive = !isGridActive;
        delay(100);
      }
    }
    frontEnd.imageButton(tempX+100, table1.Y+table1.H+settingOffset, 40, gridSetting2, color(200),isEveryTenLine);
    if(frontEnd.onimageButton(tempX+100, table1.Y+table1.H+settingOffset, 40)){
      if(mousePressed){
        isEveryTenLine = !isEveryTenLine;
        delay(100);
      }
    }
    frontEnd.imageButton(tempX+150,table1.Y+table1.H+settingOffset,40,gridSetting3,color(200),diagramMode);
    if(frontEnd.onimageButton(tempX+150, table1.Y+table1.H+settingOffset, 40)){
      if(mousePressed){
        diagramMode = !diagramMode;
        delay(100);
      }
    }
    if(inZoomedMode){
      frontEnd.imageButton(tempX+tempW-70,table1.Y+5,40,backArrow,color(200),!inZoomedMode);
      if(frontEnd.onimageButton(tempX+tempW-70, table1.Y+5, 40)){
        if(mousePressed){
          inZoomedMode = false;
          table1.zoomWindowReset();
          delay(100);
        }
      }
    }
  }
  
  public void colorationLegende(){
    for(int colScale = 0; colScale < 255; colScale++){
      fill(colScale,255-colScale,250);
      rect(tempX+tempW-255 + colScale, table1.Y+  table1.H + settingOffset, 1, 40);
      
    }
    fill(0);
    textSize(12);
    if(secondSelectedField == 0){
      textAlign(LEFT,BOTTOM);
      text("Time (h)", tempX+tempW-255, table1.Y+  table1.H + settingOffset-10);
      text("0", tempX+tempW-255, table1.Y+  table1.H + settingOffset);
      textAlign(RIGHT,BOTTOM);
      text("24", tempX+tempW-0, table1.Y+  table1.H + settingOffset);
      
    }else{
      textAlign(LEFT,BOTTOM);
      text(backEnd.minValue, tempX+tempW-255, table1.Y+  table1.H + settingOffset-10);
      text("Unit (" + backEnd.unit[thirdSelectedField] + ")", tempX+tempW-255, table1.Y+  table1.H + settingOffset);
      textAlign(RIGHT,BOTTOM);
      text(backEnd.maxValue, tempX+tempW-0, table1.Y+  table1.H + settingOffset);
    }
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(tempX+tempW-255, table1.Y+  table1.H + settingOffset, 255, 40);
    noStroke();
  }
  
  boolean selectedSensor = true; //true = 1; false = 2;
  String tempBoxName;
  
  public void showSelectionMenu(){
    // FIELD 1#
    //fieldW = tempW/fieldTotal + zwischenRaumAbstand*fieldZwischenRaumTotal;
    fill(40);
    rect(tempX,table1.Y+table1.H+fieldOffset,fieldW,40);
    fill(255);
    textSize(13);
    textAlign(CENTER,CENTER);
    text("Density",tempX+fieldW/2,table1.Y+table1.H+fieldOffset+20);
    if(mouseX>tempX && mouseX<tempX+fieldW && mouseY>table1.Y+table1.H+fieldOffset && mouseY<table1.Y+table1.H+fieldOffset+40){
      if(mousePressed){
        firstOptionFieldOpen = true;
      }
    }
    if(firstOptionFieldOpen)
    {
        for(int i = 0; i<firstFieldValues.length; i++){
          fill(80);
          if(mouseX>tempX && mouseX<tempX+fieldW && mouseY>table1.Y+table1.H+fieldOffset+60+(i)*42 && mouseY<table1.Y+table1.H+fieldOffset+60+(i+1)*42){
            if(mousePressed){
             // firstOptionFieldOpen = false;
             firstSelectedField = i;
             density = densitiesFaktor[i];
            }
            fill(120);
          }
          rect(tempX,table1.Y+table1.H+fieldOffset+60 + 42 * i, fieldW, 40);
          fill(secColor);
          rect(tempX,table1.Y+table1.H+fieldOffset+60 + 42 * firstSelectedField, fieldW, 40);
          fill(255);
          text(firstFieldValues[firstSelectedField] + " %",tempX+fieldW/2,table1.Y+table1.H+fieldOffset+80+(firstSelectedField)*42);
          text(firstFieldValues[i] + " %",tempX+fieldW/2,table1.Y+table1.H+fieldOffset+80+(i)*42);
        }
    }
    
    // FIELD 2#
    
    fill(40);
    rect(tempX+fieldW+zwischenRaumAbstand,table1.Y+table1.H+fieldOffset,fieldW,40);
    fill(255);
    textSize(13);
    textAlign(CENTER,CENTER);
    text("Coloration",tempX+fieldW*1.5+zwischenRaumAbstand,table1.Y+table1.H+fieldOffset+20);
    if(mouseX>tempX+fieldW+zwischenRaumAbstand && mouseX<tempX+fieldW*2+zwischenRaumAbstand && mouseY>table1.Y+table1.H+fieldOffset && mouseY<table1.Y+table1.H+fieldOffset+40){
      if(mousePressed){
        secondOptionFieldOpen = true;
      }
    }
    if(secondOptionFieldOpen)
    {
        for(int i = 0; i<secondFieldValues.length; i++){
          fill(80);
          if(mouseX>tempX+fieldW+zwischenRaumAbstand && mouseX<tempX+fieldW*2+zwischenRaumAbstand && mouseY>table1.Y+table1.H+fieldOffset+60+(i)*42 && mouseY<table1.Y+table1.H+fieldOffset+60+(i+1)*42){
            if(mousePressed){
             // secondOptionFieldOpen = false;
             secondSelectedField = i;
            }
            fill(120);
          }
          rect(tempX+fieldW+zwischenRaumAbstand,table1.Y+table1.H+fieldOffset+60 + 42 * i, fieldW, 40);
          fill(secColor);
          rect(tempX+fieldW+zwischenRaumAbstand,table1.Y+table1.H+fieldOffset+60 + 42 * secondSelectedField, fieldW, 40);
          fill(255);
          text(secondFieldValues[secondSelectedField],tempX+fieldW*1.5+zwischenRaumAbstand,table1.Y+table1.H+fieldOffset+80+(secondSelectedField)*42);
          text(secondFieldValues[i],tempX+fieldW*1.5+zwischenRaumAbstand,table1.Y+table1.H+fieldOffset+80+(i)*42);
        }
    }
    
    // FIELD 3#
    
    fill(40);
    //rect(tempX+fieldW*2+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset-45,fieldW,40);
    rect(tempX+fieldW*2+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset,fieldW,40);
    fill(255);
    textSize(13);
    textAlign(CENTER,CENTER);
    text("Sensor",tempX+fieldW*2.5+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset+20);
    
    /*if(!backEnd.boxName.equals(tempBoxName)){
      thirdSelectedField = 0;
    }
    tempBoxName = backEnd.boxName;
    
    /*frontEnd.curvedWindow(tempX+fieldW*2+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset, fieldW,40, 5, color(60));
    
    if(selectedSensor){
      frontEnd.curvedWindowLeft(tempX+fieldW*2+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset, fieldW/2,40, 5, color(primColor));
    }else{
      frontEnd.curvedWindowRight(tempX+fieldW*2.5+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset, fieldW/2,40, 5, color(primColor));
    }
    
    if(mouseY>table1.Y+table1.H+fieldOffset && mouseY<table1.Y+table1.H+fieldOffset+40){
      if(mouseX>tempX+fieldW*2+zwischenRaumAbstand*2 && mouseX<tempX+fieldW*2.5+zwischenRaumAbstand*2){
        frontEnd.curvedWindowLeft(tempX+fieldW*2+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset, fieldW/2,40, 5, color(100));
        if(mousePressed){
          selectedSensor = true;
        }
      }
      else if(mouseX>tempX+fieldW*2.5+zwischenRaumAbstand*2 && mouseX<tempX+fieldW*3+zwischenRaumAbstand*2){
        frontEnd.curvedWindowRight(tempX+fieldW*2.5+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset, fieldW/2,40, 5, color(100));
        if(mousePressed){
          selectedSensor = false;
        }
      }
    }
    //frontEnd.curvedWindowLeft(tempX+fieldW*2+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset, fieldW/2,40, 5, color(100));
    //frontEnd.curvedWindowRight(tempX+fieldW*2.5+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset, fieldW/2,40, 5, color(60));
    
    fill(255);
    text("Sensor 1", tempX+fieldW*2.25+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset+20);
    text("Sensor 2", tempX+fieldW*2.75+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset+20);
    */
    
    if(mouseX>tempX+fieldW*2+zwischenRaumAbstand*2 && mouseX<tempX+fieldW*3+zwischenRaumAbstand*2 && mouseY>table1.Y+table1.H+fieldOffset && mouseY<table1.Y+table1.H+fieldOffset+40){
      if(mousePressed){
        thirdOptionFieldOpen = true;
      }
    }
    if(thirdOptionFieldOpen)
    {
        for(int i = 0; i<backEnd.sensorName.length; i++){
          fill(80);
          if(mouseX>tempX+fieldW*2+zwischenRaumAbstand*2 && mouseX<tempX+fieldW*3+zwischenRaumAbstand*2 && mouseY>table1.Y+table1.H+fieldOffset+60+(i)*42 && mouseY<table1.Y+table1.H+fieldOffset+60+(i+1)*42){
            if(mousePressed){
              //thirdOptionFieldOpen = false;
              
                thirdSelectedField = i;
            }
            ///////createtempWindow(i);
            fill(120);
          }
          println(selectedSensors);
          rect(tempX+fieldW*2+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset+60 + 42 * i, fieldW, 40);
          
          textSize(13);
          fill(secColor);
          rect(tempX+fieldW*2+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset+60 + 42 * thirdSelectedField, fieldW, 40);
          fill(255);
          if(i<backEnd.sensorName.length){
            text(backEnd.sensorName[thirdSelectedField],tempX+fieldW*2.5+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset+80+(thirdSelectedField)*42);
            text(backEnd.sensorName[i],tempX+fieldW*2.5+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset+80+(i)*42);
          }else{
            text("Kein Sensor",tempX+fieldW*2.5+zwischenRaumAbstand*2,table1.Y+table1.H+fieldOffset+80+(i)*42);
          }
        }
    }
  }
  
  int diagramRectHeight = 100;
  int txtAbstand = (diagramRectHeight/6);
  int sensorwindowAbstand;
  
  boolean onOpenLog = false;
  boolean onOpenData = false;
  public void showDiagramInfo(){
    //a = tempW/selectedSensors;
    if(selectedSensors != 0){
      for(int i = 0; i < selectedSensors; i++){
        fill(200);
        if(mouseX>tempX + (i*sensorwindowAbstand) && mouseX<tempX + ((i+1)*sensorwindowAbstand) && mouseY > table1.Y+sensorOverViewOffset && mouseY < table1.Y+sensorOverViewOffset+diagramRectHeight){
          fill(220);
        }
        rect(tempX + sensorwindowAbstand*i, table1.Y + sensorOverViewOffset, sensorwindowAbstand, diagramRectHeight);
        fill(0);
        textSize(15);
        /*text(
        "Sensorname: " + backEnd.sensorName[thirdSelectedField] + "\n" + 
        "SensorID: " + backEnd.sensorId[thirdSelectedField] + "\n" + 
        "Sensortyp: " + backEnd.sensor_type[thirdSelectedField] + "\n" + 
        "Einheit: " + backEnd.unit[thirdSelectedField] + "\n" + 
        "Value Amount: " + backEnd.allVal.size() + "\n"
        , tempX + sensorwindowAbstand*(0.5+i), table1.Y + sensorOverViewOffset
        );*/
            textAlign(LEFT,TOP);
            text("Sensorname: ", tempX + sensorwindowAbstand*i + 10, table1.Y + sensorOverViewOffset + txtAbstand*1);
            text("SensorID: ", tempX + sensorwindowAbstand*i + 10, table1.Y + sensorOverViewOffset + txtAbstand*2);
            text("Sensortyp: ", tempX + sensorwindowAbstand*i + 10, table1.Y + sensorOverViewOffset + txtAbstand*3);
            text("Einheit: ", tempX + sensorwindowAbstand*i + 10, table1.Y + sensorOverViewOffset + txtAbstand*4);
            
            textAlign(RIGHT,TOP);
            text(backEnd.sensorName[thirdSelectedField] , tempX + sensorwindowAbstand*(i+1) - 10, table1.Y + sensorOverViewOffset + txtAbstand*1);
            text(backEnd.sensorId[thirdSelectedField] , tempX + sensorwindowAbstand*(i+1) - 10, table1.Y + sensorOverViewOffset + txtAbstand*2);
            text(backEnd.sensor_type[thirdSelectedField] , tempX + sensorwindowAbstand*(i+1) - 10, table1.Y + sensorOverViewOffset + txtAbstand*3);
            text(backEnd.unit[thirdSelectedField] , tempX + sensorwindowAbstand*(i+1) - 10, table1.Y + sensorOverViewOffset + txtAbstand*4);
      }
      fill(120);
      rect(tempX, table1.Y + sensorOverViewOffset-50, table1.W, 50);
      textAlign(CENTER,CENTER);
      fill(255);
      text("Value Amount: " + (abs(lastIndex - firstIndex)) , tempX + table1.W/2, table1.Y + sensorOverViewOffset - 50/2);
      
      textSize(12);
      if(dist(mouseX,mouseY,tempX + table1.W/2+100,table1.Y + sensorOverViewOffset - 50/2) < 20){
        fill(highlightColor);
        onOpenLog = true;
      }else{
        fill(180);
        onOpenLog = false;
      }
      text("LOG" , tempX + table1.W/2+100, table1.Y + sensorOverViewOffset - 50/2);
      
      if(dist(mouseX,mouseY,tempX + table1.W/2+140,table1.Y + sensorOverViewOffset - 50/2) < 20){
        fill(highlightColor);
        onOpenData = true;
      }else{
        fill(180);
        onOpenData = false;
      }
      text("DATA", tempX + table1.W/2+140, table1.Y + sensorOverViewOffset - 50/2);
      
      textAlign(CENTER,CENTER);
      textSize(20);
      //fill(120);
      //rect(tempX, table1.Y + sensorOverViewOffset-100, table1.W, 50);
      fill(120);
      text("Name: " + backEnd.boxName + " | ID: " + backEnd.boxId, tempX + table1.W/2, table1.Y + sensorOverViewOffset - 50 - 50/2);
    }
  }
}
