class Boss extends Enemy {
  float r;
  float theta =0;
  int x2=(int)random(50, 500), y2 =(int)random(50, 200);
  
  Boss() {
    super(width, 100, 4);
  }


  void move()
  {
    bounds();
    //the move function works on the counter from the Enemy class.
    if (counter >0 && counter < 1)
    {
      //a random radius, moving direction (0 and 1) and time limits are set in the begining of each count
      r=random(100, 250);
      t1 = random(0.02, 2);
      t2 = random(9, 10);
      speedX=(int)random(0, 2);
    }
    else if (counter > t1 && counter < t2)
    {
      if (speedX==0) {
        x2--;
      }
      else {
        x2++;
      }
      //A bit more sophisticated way of movement than a regular enemy, using cos and sin to create a circular motion.
      theta+=PIE/(frameRate*2);
      x=x2 + (int)(r*(cos(theta))*(sin(theta)));
      y=y2 + (int)((r/2)*cos(theta));
    }
  }

//The boss can go out of the bounds of the screen.
  void bounds() {
    if (x+w<0) {
      x2=width;
    }
    else if (x>width) {
      x2=(int)-w;
    }
    else if (y+h<0) {
      y=height;
    }
    else if (y>height) {
      y=(int)-h;
    }
  }

//Also here, overriding the shooting function to make the boss more lethal. 
//Here, instead of shooting one bullet in the period of time selected by random (as I do in the enemy class),
//I shoot during the whole period of time.
  void shoot() {
    if (counter>0 && counter<0.1)
    {
      t3_shoot=(int)random(0.1, 8);
    }
    else if (counter>t3_shoot) {
      bullets.add(new Bullet(x, y+h/2, -8, bulletColor, bulletSizeX, bulletSizeY));
    }
    for (int i = bullets.size()-1; i >= 0; i--) {
      Bullet bullet = (Bullet) bullets.get(i);
      bullet.display();
      bullet.move();
      if (bullet.x+bullet.w < 0) {
        bullets.remove(i);
      }
    }
  }
}

