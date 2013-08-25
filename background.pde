class Background
{
  float starSize;
  int amount = 150;
  float posx[] = new float[amount];
  float posy[] = new float[amount];

  //calculate new random location to each star. This is called in the setup function.
  void calculate()
  {
    for (int i = 0; i< amount; i++)
    {
      posx[i] = random(0, width);
      posy[i] = random(0, height);
    }
  }

  void display() {
    for (int i =0; i < amount; i++)
    {
      fill(255);
      starSize = random(1.3, 2.5);
      rect(posx[i], posy[i], starSize, starSize);
      noFill();
    }
  }

//The stars move and loop when reaching x=0, giving the game a dynamic effect. 
  void move() {
    for (int i =0; i < amount; i++) {
      posx[i] = posx[i]-0.8;
      if (posx[i] <= 0)
      {
        posx[i]=width;
      }
    }
  }
  
//setting screen bounds, to be used after in other classes.
  int bounds(int pos, int size, int minSize, int maxSize) {
    if ((pos+size)>maxSize) {
      return (maxSize-size);
    }
    else if (pos<=minSize) {
      return minSize;
    }
    else return pos;
  }
}

