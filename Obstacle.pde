class Obstacle
{
  float x = width, 
  y, 
  w,
  h, 
  t1, 
  counter, 
  speed;
  
  Obstacle(float _speed) {
    speed = _speed;
  }

  void display()
  {
    fill(160, 160);
    rect(move(), y, w, h, 3);
    counter();
  }

  float move()
  {
  // A farily simple method of moving. Every begining of the counter it resets 
  //the value and chooses a random X, Y, height of obstacle and the time it will move.
  //The function returns the current X and I use it when I draw the obstacle.
    if (counter>0 && counter <0.2) {
      x=width+5; 
      y= random(10, 250);
      w=random(5, 10);
      h=random(60, 150);
      t1=random(1, 15);
    }
    else if (counter>t1) {
      if (x+w>-5) {
        x -= speed;
      }
    }
    return x;
  }

//A function that sets the speed of the obstacle. I use it in the different levels.
  void setSpeed(float _speed) {
    speed  = _speed;
  }
  
  //Same counter function, but this time it counts until 20.
  void counter()
  {
    counter+=1/frameRate;
    if (counter > 20)
    {
      counter=0;
    }
  }
}

