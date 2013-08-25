class Button {

  int x, 
  y, 
  w, 
  h, 
  text_x, 
  text_y;
  
  String text;

  Button (int x, int y, int w, int h, String text, int text_x, int text_y) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text=text;
    this.text_x=text_x;
    this.text_y=text_y;
  }

  void display() {
    if (hover()) {
      //Just trying the colors in hex..:)
      fill(#555588, 150);
      if (clicked()) {
        fill(#5555DD, 150);
      }
    }
    else {
      fill(#555555, 150);
    }
    rect(x, y, w, h);
    fill(200);
    textSize(12);
    text(text, text_x, text_y);
  }

//wheneve the mouse is hovering the button, the function will return true
  boolean hover() {
    if (mouseX<x+w && mouseX>x && mouseY<y+h && mouseY>y)
    {
      cursor(HAND);
      return true;
    }
    else {
      return false;
    }
  }

  boolean clicked() {
    if (hover()) {
      if (mousePressed) {
        return true;
      }
      else{
        return false;
      }
    }
    else return false;
  }
}

