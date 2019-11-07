class jsonConv{
  PrintWriter HTTP_Log;
  final String HTTP_Log_name = "HTTP_REQUEST_log.txt";
  PrintWriter DATA_Log;
  final String DATA_Log_name = "DATA.txt";
  final String BoxInfo_name = "BoxInfo.ini";
  final String allBoxNames_fileName = "allLoadedBoxes";
  
  ArrayList<String> boxesID = new ArrayList<String>();
  ArrayList<String> boxesName = new ArrayList<String>();
  
  String baseAddress = "https://api.opensensemap.org/boxes";
  GetRequest get;
  
  boolean result_success = false;
  
  String ErrorMessage;
  String ErrorCode;
  String ErrorComplete = "";
  
  String todaysDate(){
    String temp;
    int tempDay;
    if(day()!= 1){
      tempDay = day() - 1;    //get day before because on the same day as current day no box info given
    } else{
      tempDay = 28;
    }
    String doubleDigit = tempDay < 10 ? "0" : ""; // has to be 01 not 1 and day() is returning 1
    temp = String.valueOf(year()) + "-" +  String.valueOf(month()) + "-" + doubleDigit +String.valueOf(tempDay) + "T15:00:00" + ".000Z";
    return temp;
  }
  
  String to_rfcTime(int day, int month, int year, String time){
    String doubleDigit2 = day < 10 ? "0" : "";
    String doubleDigit1 = month < 10 ? "0" : "";
    String temp = String.valueOf(year) + "-" + doubleDigit1 +String.valueOf(month) + "-" + doubleDigit2 + String.valueOf(day) + "T" + time + ".000Z";
    return temp;
  }
    
  String to_realTime(String rfc){    //2018-11-24T01:38:30.378Z
    char[] time = new char[8]; 
    rfc.getChars(11,19,time,0);
    String temp =  
    
    String.valueOf(rfc.charAt(8)) + String.valueOf(rfc.charAt(9))         + "."  +          
    String.valueOf(rfc.charAt(5)) + String.valueOf(rfc.charAt(6))        + "." +      
    String.valueOf(rfc.charAt(0)) + String.valueOf(rfc.charAt(1)) + String.valueOf(rfc.charAt(2)) + String.valueOf(rfc.charAt(3))       +      " at(time): " + 
    String.copyValueOf(time)
    ;
    
    return temp;
  }
  
  String realTodaysDate(){
    String doubleDigit = hour() < 10 ? "0" : "";
    return String.valueOf(year()) + "-" +  String.valueOf(month()) + "-" + String.valueOf(day()) + "T" + doubleDigit + String.valueOf(hour())+ ":00:00.000Z";
  }
  
  int getSpecificParamater(String date, String type){    //RFC time
    switch(type){
      case "year":
        return Integer.valueOf(String.valueOf(date.charAt(0)) + String.valueOf(date.charAt(1)) + String.valueOf(date.charAt(2)) + String.valueOf(date.charAt(3)));
      case "day":
        if(!String.valueOf(date.charAt(8)).equals("0")){
          return Integer.valueOf(String.valueOf(date.charAt(8)) + String.valueOf(date.charAt(9)));
        }else{
          return Integer.valueOf(String.valueOf(date.charAt(9)));
        }
      case "month":
        if(!String.valueOf(date.charAt(5)).equals("0")){
          return Integer.valueOf(String.valueOf(date.charAt(5)) + String.valueOf(date.charAt(6)));
        }else{
          return Integer.valueOf(String.valueOf(date.charAt(6)));
        }
      case "hour":
        if(!String.valueOf(date.charAt(11)).equals("0")){
          return Integer.valueOf(String.valueOf(date.charAt(11)) + String.valueOf(date.charAt(12)));
        }else{
          return Integer.valueOf(String.valueOf(date.charAt(12)));
        }
      case "min":
        if(!String.valueOf(date.charAt(14)).equals("0")){
          return Integer.valueOf(String.valueOf(date.charAt(14)) + String.valueOf(date.charAt(15)));
        }else{
         return Integer.valueOf(String.valueOf(date.charAt(15)));
        }
      case "sec":
        if(!String.valueOf(date.charAt(17)).equals("0")){
          return Integer.valueOf(String.valueOf(date.charAt(17)) + String.valueOf(date.charAt(18)));
        }else{
          return Integer.valueOf(String.valueOf(date.charAt(18)));
        }
    }
    return -1;
  }
  
  void get_request(String address){
    get = new GetRequest(address);
    get.send();
  }
  
  void saveJSON(String inhalt, String dataName){
    dataName.replaceAll(" ","_");    //keione leerstellen lassen
    PrintWriter json = createWriter("savedJSON/"+ dataName + ".json");
    json.print(inhalt);
    json.flush();
    json.close();
  }
  
  double[][] allCoords;
  private PrintWriter BoxInfo;
  boolean loadBoxInfoSuccess = false;
  public float BoxZuwachs = 0.0;      //prozent
  private int boxesLastTime = 0;
  public String lastDate;
  private int boxesThisTime = 0;
  public int boxesDiff = 0;
  
  String error_code;
  String error_message;
  
  void readErrorMessage(String message){
    JSONObject response = parseJSONObject(message);    //content gotten
    error_code = response.getString("code");
    error_message = response.getString("message");
  }
  
  private void loadLastBoxesInfo(){
    try{
      String[] lines = loadStrings(BoxInfo_name);
      lastDate = lines[0];
      boxesLastTime = Integer.valueOf(lines[1]);
      
      loadBoxInfoSuccess = true;
    } catch(java.lang.RuntimeException e){
      loadBoxInfoSuccess = false;
    }
  }
  
  void load_all_boxes(String bbox, String date, String phenomenon, boolean minimal, boolean loadLocally){
    cursor(WAIT);
    if(!loadLocally){
      
      String completeAddress;
      //completeAddress = baseAddress + "?bbox=" + bbox + "&date=" + date + "&phenomenon=" + phenomenon + "&minimal=" + String.valueOf(minimal);    //ALTE METHODE
      completeAddress = baseAddress + "?bbox=" + bbox + "&minimal=" + String.valueOf(minimal);    //GETTET alle boxen
      println("GET " + completeAddress);
      println("AT " + date);
      
      try{
        get_request(completeAddress);
        
        JSONArray mainArray = parseJSONArray(get.getContent());
        
        saveJSON(get.getContent(), allBoxNames_fileName);    //saves all loaded Boxes
        
        allCoords = new double[mainArray.size()][2];
        for(int i=0;i<mainArray.size();i++) {
          JSONObject ArrayInhalt = mainArray.getJSONObject(i);
          //println("  Box ID: " + ArrayInhalt.getString("_id"));
          //println("  Box Name: " + ArrayInhalt.getString("name"));
          //GET COORDS Object:currentLocation ,inside -> Array:coordinates (with 2 Val:lat,long)
          
          boxesID.add(ArrayInhalt.getString("_id"));
          boxesName.add(ArrayInhalt.getString("name"));
        }
        
        for(int i = 0; i<boxesID.size(); i++){
          //println(boxesID.get(i));
          //println(boxesName.get(i));
        }
        
        loadLastBoxesInfo();
        boxesThisTime = mainArray.size();
        boxesDiff = boxesThisTime-boxesLastTime;
        BoxZuwachs = (float)boxesDiff/(float)boxesThisTime;
        
        BoxInfo = createWriter(BoxInfo_name);
        BoxInfo.println(day() + "." + month() + "." + year() + " / " + hour() + ":" + minute() + ":" + second() + " Uhr");
        BoxInfo.println(mainArray.size());
        BoxInfo.flush();
        BoxInfo.close();
        
      }catch(java.lang.RuntimeException e){
        launch(sketchPath()+"/data/ERR_BoxesLoading.exe");
        exit();
      }
      
      
    }else{
      try{
        String[] lines = loadStrings(sketchPath() + "/savedJSON/" + allBoxNames_fileName + ".json");
        String wholeText = "";
        for(int i = 0; i < lines.length; i++){
          wholeText+= lines[i];
        }
        
        JSONArray mainArray = parseJSONArray(wholeText);
        
        allCoords = new double[mainArray.size()][2];
        for(int i=0;i<mainArray.size();i++) {
          JSONObject ArrayInhalt = mainArray.getJSONObject(i);
          println("  Box ID: " + ArrayInhalt.getString("_id"));
          println("  Box Name: " + ArrayInhalt.getString("name"));
          //GET COORDS Object:currentLocation ,inside -> Array:coordinates (with 2 Val:lat,long)
          
          boxesID.add(ArrayInhalt.getString("_id"));
          boxesName.add(ArrayInhalt.getString("name"));
        }
        frontEnd.setCopyInfo("loaded Boxes locally!");
        
        
      }catch(java.lang.RuntimeException e){
        load_all_boxes("-180,-90,180,90","2019-01-02T01:38:30.378Z","Temperatur",true, false);    //if fails to load locally: load from API
        frontEnd.setCopyInfo("loaded Boxes through API!");
      }
    }
  }
  
  
  float[] coords = new float[2];
  String boxName;
  String boxId;
  String created_timestamp;  //empty for now
  String boxType; // exposure
  String[] sensorName;
  String[] sensorId;
  String[] measuredValue;
  String[] unit;
  String[] sensor_type;
  String[] lastMeasuredTime;
  
  void get_box_info(String id, boolean minimal){
    cursor(WAIT);
      minimal = false; //for now off! because following code wouldnt work
      String completeAddress;
      completeAddress = baseAddress + "/" + id + "?minimal=" + String.valueOf(minimal);
      //GetRequest get = new GetRequest(completeAddress);
      //get.send();
      get_request(completeAddress);
      println("Reponse Content: " + get.getContent());
      println("GET " + completeAddress);
      ts.thirdSelectedField = 0;
    try{
      JSONObject response = parseJSONObject(get.getContent());
      JSONObject curLoc = response.getJSONObject("currentLocation");
      println("-------------------------------------------------------");
      println("  Box Name: " + response.getString("name"));
      boxName = response.getString("name");
      boxId = response.getString("_id");
      boxType = response.getString("exposure");
      println("  timestamp: " + curLoc.getString("timestamp"));
      created_timestamp = curLoc.getString("timestamp");
      JSONArray curLoc_coordinates = curLoc.getJSONArray("coordinates");
      println("  Long: " + curLoc_coordinates.getFloat(0));
      println("  Lat: " + curLoc_coordinates.getFloat(1));
      coords[0] = curLoc_coordinates.getFloat(0);
      coords[1] = curLoc_coordinates.getFloat(1);
      JSONArray sensors = response.getJSONArray("sensors");
        sensorName = new String[sensors.size()];
        sensorId = new String[sensors.size()];
        unit = new String[sensors.size()];
        measuredValue = new String[sensors.size()];
        sensor_type = new String[sensors.size()];
        lastMeasuredTime = new String[sensors.size()];
      for(int i=0;i<sensors.size();i++) {
        JSONObject valuesOfSensors = sensors.getJSONObject(i);
        println("  sensorname: " + valuesOfSensors.getString("title"));
        sensorName[i] = valuesOfSensors.getString("title");
        println("  ID: " + valuesOfSensors.getString("_id"));
        sensorId[i] = valuesOfSensors.getString("_id");
        println("  type: " + valuesOfSensors.getString("sensorType"));
        sensor_type[i] = valuesOfSensors.getString("sensorType");
        println("  unit: " + valuesOfSensors.getString("unit"));
        unit[i] = valuesOfSensors.getString("unit");
          JSONObject measurementData = valuesOfSensors.getJSONObject("lastMeasurement");
          println("      last measured value: " + measurementData.getString("value"));
          measuredValue[i] = measurementData.getString("value");
          println("      last time scanned  : " + measurementData.getString("createdAt"));
          lastMeasuredTime[i] = measurementData.getString("createdAt");
      }
      result_success = true;
    }catch(java.lang.RuntimeException e){
       result_success = false;
       ErrorComplete = get.getContent();
       /*JSONObject Error = parseJSONObject(get.getContent());
       JSONObject _ErrorCode = Error.getJSONObject("code");
       ErrorCode = _ErrorCode.getString("code");
       JSONObject _ErrorMessage = Error.getJSONObject("message");
       ErrorMessage = _ErrorMessage.getString("message");*/
       readErrorMessage(get.getContent());
    }
    //
    frontEnd.setFeedBack(result_success);
  }
  
  float maxValue;
  float minValue;
  float durchSchnitt;
  
  float[] all_value;
  FloatList allVal = new FloatList();
  String[] all_date;
  StringList allDate = new StringList();
  
  int durchgeange = 0;
  boolean timedOut = false;
  final int timedOutDurchgaenge = 100;
  
  boolean allData_result_success = false;
  
  void getLatestMeasurements(String id, String sensorid, String fromDate, String toDate){
    cursor(WAIT);
    //https://api.opensensemap.org/boxes/5bf8373386f11b001aae627e/data/5bf8373386f11b001aae6285 ?from-date=2018-11-16T01:38:30.378Z&to-date=2018-11-28T01:38:30.378Z&download=false&format=json
    //ellipse(mappedX, map(zoomedInValues.get(i_two), minValZoomedIn, maxValZoomedIn, y+h, y),2,2);
    String completeAddress;
    durchgeange = 0; // reset durchgangsCounter
    HTTP_Log = createWriter(HTTP_Log_name);
    DATA_Log = createWriter(DATA_Log_name);
    HTTP_Log.println("Date:  " + day() + "." + month() + "." + year());
    HTTP_Log.println();
    HTTP_Log.println("-----------------------------------------");
    HTTP_Log.println();
    try
    {
      
      do{
        completeAddress = baseAddress + "/" + id + "/data/" + sensorid + "?from-date=" + fromDate + "&to-date=" + toDate + "&download=false&format=json";
        get_request(completeAddress);
        //println("Reponse Content: " + get.getContent());
        HTTP_Log.println("Durchgang: " + (durchgeange+1));
        HTTP_Log.println();
        println("GET " + completeAddress);
        HTTP_Log.println("GET: " + completeAddress);
        HTTP_Log.println("from: " + to_realTime(fromDate) + "  to: " + to_realTime(toDate));
        
        JSONArray mainArray = parseJSONArray(get.getContent());
        all_value = new float[mainArray.size()];
        all_date = new String[mainArray.size()];
        for(int i = 0; i < mainArray.size(); i++){
          JSONObject valuesOfSensors = mainArray.getJSONObject(i);
          //println("value: " + valuesOfSensors.getFloat("value"));
          //println("value: " + valuesOfSensors.getString("createdAt"));
          all_value[i] = valuesOfSensors.getFloat("value");
          all_date[i] = valuesOfSensors.getString("createdAt");
          
          allVal.insert(0,all_value[i]);
          allDate.insert(0,all_date[i]);
          
         //all_value[i] = 0;    //CLEAR ???
         //all_date[i] = "";
        }
        
        HTTP_Log.println("Data Amount now: " + mainArray.size());
        HTTP_Log.println("Loss from JSONArray to internal Array?: " + (mainArray.size()-all_value.length));
        HTTP_Log.println();
        HTTP_Log.println("Data Amount total: " + allVal.size());
        HTTP_Log.println();
        
        toDate = all_date[all_date.length-1];
        durchgeange++;
        if(durchgeange > timedOutDurchgaenge){
          timedOut = true;
        }
        HTTP_Log.flush();
      }while(isLower(getSpecificParamater(fromDate, "day"), getSpecificParamater(fromDate, "month"), getSpecificParamater(fromDate, "year"), getSpecificParamater(toDate, "day"),getSpecificParamater(toDate, "month"),getSpecificParamater(toDate, "year")) && !timedOut);
      
      //maxValue = max(all_value);
      //minValue = min(all_value);
      maxValue = allVal.max();
      minValue = allVal.min();
      durchSchnitt = Tab2.durchSchnitt(allVal);
      if(!timedOut){
        HTTP_Log.println("SUCCESS");
        allData_result_success = true;
        
        DATA_Log.println("Box ID: " + id + "  / Sensor ID: " + sensorid + "   / Sensor NAME: " + sensorName[0]);
        DATA_Log.println("-----------------------------------------------");
        
        for(int ma=0; ma<backEnd.allVal.size(); ma++){
          DATA_Log.println(backEnd.allDate.get(ma) +" -> "+ backEnd.allVal.get(ma));
        }
      } else{
        launch(sketchPath()+"/data/ERR_Timedout.exe");
        DATA_Log.println("Error");
        timedOut = false;
      }
      Tab2.schlauchIsInit = false;
      DATA_Log.flush();
      DATA_Log.close();
      //exit();
    }catch(java.lang.RuntimeException e){
      maxValue = 0;
      minValue = 0;
      durchSchnitt = 0;
      HTTP_Log.println("ERROR GETTING DATA");
      //exit();
    }
    HTTP_Log.flush();
    HTTP_Log.close();
    //Tab2.zoomWindowReset();    //reset starting index and ending index (from what index to what index should be shown)
    ts.firstIndex = 0;
    ts.lastIndex = allVal.size();
  }
  
  void clearValueData(){
    if(all_value == null) return;      //check if arrays have been init in the first place
      for(int len1 = 0; len1<all_value.length; len1++){    //CLEAR DATA FIRST
        all_value[len1] = 0;
        all_date[len1] = "";
      }
    allVal.clear();
    allDate.clear();
    ts.firstIndex = 0;
    ts.lastIndex = 0;
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
  
  void visualFeedback(String ID){
    if(ID!=null && !ID.isEmpty()){
      textSize(12);
      if(!result_success){
        fill(255,0,0,180);
        rect(width/2-10,5+ frontEnd.dropDownYPos-50,width*0.48,40);
        fill(255, 255);
        text("couldn't get the Data for ID: " + ID, width/2, -27 + frontEnd.dropDownYPos);
        /*text("Code: " + ErrorCode, width/2, 20);
        text("Message: " + ErrorMessage, width/2, 30);*/
        text(ErrorComplete, width/2 , -17 + frontEnd.dropDownYPos);
      } else{
        fill(0,255,0, 180);
        rect(width/2-10,5+ frontEnd.dropDownYPos-50,width*0.48,40);
        fill(255, 255);
        text("SUCCESS for ID: " + ID, width/2, -27 + frontEnd.dropDownYPos);
      }
    }
  }
}
