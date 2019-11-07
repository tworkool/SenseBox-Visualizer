helperTab help = new helperTab();

class helperTab{
  
  void updateTextField(){
    if(hintTxtfield.getPosition()[0] + hintTxtfield.getWidth() > width){
      hintTxtfield.setPosition(pmouseX,pmouseY);
    }else if(hintTxtfield.getPosition()[1] + hintTxtfield.getHeight() > height){
      hintTxtfield.setPosition(pmouseX,pmouseY);
    }else{
      hintTxtfield.setPosition(pmouseX,pmouseY);
    }
  }
  
  void setTextArea(String txt){
    hintTxtfield.setText(txt);
    //hintTxtfield.setWidth(int(txt.length()*1.2));
    hintTxtfield.show();
    updateTextField();
  }
  
  void showHints(){
    
    if(controlp5.onMouseOver()){
      setTextArea("select a box");
    }else {
      hintTxtfield.hide();
    }
    
    if(tabs.currentSideVisible == 0){
      
    }else if(tabs.currentSideVisible == 1){
      if(Tab2.onSearchbutton){
        
      }
      
      if(ts.onOpenData) {
      }
      if(ts.onOpenLog){
      }
      
    }else if(tabs.currentSideVisible == 2){
      if(Tab3.onFeedBackbutton()){
        
      }
      for(int i = 0; i< Tab3.selectedRect.length; i++){
        if(Tab3.selectedRect[i]){
          
        }
      }
    }
    
  }
}
