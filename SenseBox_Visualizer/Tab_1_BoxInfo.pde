class BoxInfo{
  
  private int textXPos = 30;
  void showBoxInfo(){
    if(backEnd.result_success){
      if(controlp5.favoriteBoxes.hasValue(backEnd.boxId)){
        fill(#FFD917, 100);
        rect(width/2, 20 + frontEnd.dragged(), width/2-10, 50);
        fill(0);
        textAlign(LEFT, CENTER);
        textSize(15);
        frontEnd.shadowedText("O N E  O F  Y O U R  F A V O R I T E S  :)",width/2+ 100, 50 + frontEnd.dragged(),1,color(#FFC627));
        //text("O N E  O F  Y O U R  F A V O R I T E S  :)", width/2+ 100, 50 + frontEnd.dragged());
        imageMode(CENTER);
        image(favSymbol,width/2+50, 45+frontEnd.dragged(), 40, 40);
        image(favSymbol_outline,width/2+50, 45+frontEnd.dragged(), 40, 40);
        imageMode(CORNER);
      }
      textAlign(BOTTOM);
      fill(30, 20);
      rect(10, 20 + frontEnd.dragged(), width/2-20, 50);
      rect(10, 80 + frontEnd.dragged(), width-20, 220);
      textSize(20);
      //for(int i = 0; i< 5; i++){
        if(mouseX>textXPos+250 && mouseX<textXPos+600 && mouseY>105+frontEnd.dragged() + 1*23 && mouseY < 130+frontEnd.dragged() + 1*23){    //copy BoxID
          frontEnd.curvedWindow(textXPos+250,105+frontEnd.dragged() + 1*23,350,22,3,primColor);
          fill(255);
          text(backEnd.boxId,textXPos+250,100+frontEnd.dragged() + 2*23);
          if(mousePressed){
            GClip.copy(backEnd.boxId);
            frontEnd.setCopyInfo(backEnd.boxId);
            delay(100);
          }
        }else{
          frontEnd.curvedWindow(textXPos+250,105+frontEnd.dragged() + 1*23,350,22,3,color(150));
          fill(30);
          text(backEnd.boxId,textXPos+250,100+frontEnd.dragged() + 2*23);
        }
        fill(30);
        text("Box Name:          " ,textXPos,100+frontEnd.dragged() + 1*23);  text(backEnd.boxName,textXPos+250,100+frontEnd.dragged() + 1*23);
        text("Box ID:            " ,textXPos,100+frontEnd.dragged() + 2*23);
        text("Box created Date:  " ,textXPos,100+frontEnd.dragged() + 3*23);  text(backEnd.to_realTime(backEnd.created_timestamp),textXPos+250,100+frontEnd.dragged() + 3*23);
        text("Box Type:          " ,textXPos,100+frontEnd.dragged() + 4*23);  text(backEnd.boxType,textXPos+250,100+frontEnd.dragged() + 4*23);
        text("Lattitude:         " ,textXPos,100+frontEnd.dragged() + 5.5*23);  text("       " + backEnd.coords[0],textXPos+250,100+frontEnd.dragged() + 5.5*23);
        text("Longtitude:        " ,textXPos,100+frontEnd.dragged() + 6.5*23);  text("       " + backEnd.coords[1],textXPos+250,100+frontEnd.dragged() + 6.5*23);
        for(int a = 0; a<backEnd.sensorName.length; a++){
          fill(120 * (a%2), 40);
          rect(10,120 + frontEnd.dragged() + (a+1)*200, width-20,30*6.5);
          fill(40);
          rect(20,140 + frontEnd.dragged() + (a+1)*200, width-60,38);
          
          if(mouseX>textXPos+250 && mouseX<textXPos+600 && mouseY>frontEnd.dragged() + (a+1)*200+192 && mouseY < frontEnd.dragged() + (a+1)*200+214){    //copy SensorId
            frontEnd.curvedWindow(textXPos+250,frontEnd.dragged() + (a+1)*200+192,350,22,3,primColor);
            fill(255);
             text(backEnd.sensorId[a],textXPos+250,frontEnd.dragged() + (a+1)*200+210);
            if(mousePressed){
              GClip.copy(backEnd.sensorId[a]);
              frontEnd.setCopyInfo(backEnd.sensorId[a]);
              delay(100);
            }
          }else{
            frontEnd.curvedWindow(textXPos+250,frontEnd.dragged() + (a+1)*200+192,350,22,3,color(150));
            fill(30);
            text(backEnd.sensorId[a],textXPos+250,frontEnd.dragged() + (a+1)*200+210);
          }
          
          fill(255);
          text("Sensor Name:  ",textXPos,frontEnd.dragged() + (a+1)*200+170); text(backEnd.sensorName[a],textXPos+250,frontEnd.dragged() + (a+1)*200+170);
          fill(0);
          text("Sensor ID:    ",textXPos,frontEnd.dragged() + (a+1)*200+210);  //text(backEnd.sensorId[a],textXPos+250,frontEnd.dragged() + (a+1)*200+210);
          text("Sensor Type:  ",textXPos,frontEnd.dragged() + (a+1)*200+230);  text(backEnd.sensor_type[a],textXPos+250,frontEnd.dragged() + (a+1)*200+230);
          text("Last Measurement:",textXPos,frontEnd.dragged() + (a+1)*200+ 250);  text(backEnd.measuredValue[a] + " " + backEnd.unit[a],textXPos+250,frontEnd.dragged() + (a+1)*200+ 250);
          text("Last time Measured:",textXPos,frontEnd.dragged() + (a+1)*200+ 270);  text(backEnd.to_realTime(backEnd.lastMeasuredTime[a]),textXPos+250,frontEnd.dragged() + (a+1)*200+ 270);
        }
        getBoxUpdates();
      //}
    }
  }
  
  boolean updateOnce = true;
  boolean activeNow = true;
  void getBoxUpdates(){        //check if there are new values for the sensors
    textSize(16);
    println(activeNow);
    textAlign(BOTTOM);
    if(!activeNow){ //if box didnt update for 1 months
      fill(180,20,30);
      text("Box is currently offline", 20,50 + frontEnd.dragged());
    } else{
      if(second() >= 59){
        if(!updateOnce){
          updateOnce = true;
          backEnd.get_box_info(backEnd.boxId,false);
          resetAnimation();
        }
      } else{
        updateOnce = false;
      }
      fill(0);
      text("looking for update in: " + (60 - second()) + " secs", width*0.1,50 + frontEnd.dragged());
    }
    animatedUpdate();
  }
  
  int updatedAlphaRect = 0;
  void animatedUpdate(){      //When Updated Box sensors: boxes will shortly flash up;
    if(updatedAlphaRect > 0){
      Ani.to(this, 5, "updatedAlphaRect", 0);
      fill(secColor, updatedAlphaRect);
      for(int a = 0; a<backEnd.sensorName.length; a++){
        rect(10,120 + frontEnd.dragged() + (a+1)*200, width-20,30*6.5);
        rect(20,140 + frontEnd.dragged() + (a+1)*200, width-60,38);
      }
    }
  }
  void resetAnimation(){updatedAlphaRect = 200;}    //reset the animation overlay Alpha

}
