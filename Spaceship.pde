class Spaceship
{
  int x,
  y,
  w=60,
  h=41,
  speed =4,
  dam,
  bulletSizeX=20,
  bulletSizeY=2;
  
  boolean hit,
  wPressed,
  aPressed, 
  dPressed,
  sPressed;
  
  float health=100,
  alpha=255;
  
  ArrayList bullets = new ArrayList();
  AudioSample shoot;
  PImage spaceship;

  Spaceship(int _x, int _y, String filename)
  {
    x=_x;
    y=_y;
    spaceship = loadImage(filename);
    shoot = minim.loadSample(dataPath("shoot.aiff"),512);
    shoot.setGain(-12);
  }

//calling all relevant functions.
  void display()
  {
    move();
    shoot();
    colWithEnemy();
    colWithMeteor();
    hitEnemy();
    image(spaceship, x, y, w, h);
  }

 //functionality of every key that is pressed.
  void keyPressed()
  {
    if (key=='w'|| key=='W')
    {
      wPressed = true;
    }

    if (key=='s'|| key=='S')
    {
      sPressed = true;
    }

    if (key=='a'|| key=='A')
    {
      aPressed = true;
    }

    if (key=='d'|| key=='D')
    {
      dPressed = true;
    }

    if (key==32)
    {
      shoot.trigger();
      //I add a bullet every time the space key is pressed.
      bullets.add(new Bullet(x+60, y+20, 8, #77AAFF, bulletSizeX, bulletSizeY));
    }
  }

  void keyReleased()
  {
    if (key=='w'|| key=='W')
    {
      wPressed = false;
    }

    if (key=='s'|| key=='S')
    {
      sPressed = false;
    }

    if (key=='a'|| key=='A')
    {
      aPressed = false;
    }

    if (key=='d'|| key=='D')
    {
      dPressed = false;
    }
  }

  void move()
  {
    y=back.bounds(y, h, 0, height);
    x=back.bounds(x, w, 0, width);

    if (wPressed)
    {
      y -= speed;
    }

    if (sPressed)
    {
      y += speed;
    }

    if (aPressed)
    {
      x -= speed;
    }

    if (dPressed)
    {
      x += speed;
    }
  }

  void shoot()
  {
    //Because I call this function in the display function, which is being called
    //on every frame, the bullet array list keeps listening to new bullets.
    //Wheneve he finds one (space is pressed), he automatically grabs it and shoots it.
    for (int i = bullets.size()-1; i >= 0; i--) { 
      Bullet bullet = (Bullet) bullets.get(i);
      bullet.display();
      bullet.move();
      //Remove bullet if it leaves the screen
      if (bullet.x+bullet.w > width) {
        bullets.remove(i);
      }
    }
  }

  void colWithEnemy() {
    for (int i = enemies.size()-1; i >= 0; i--) {
      Enemy enemy = (Enemy) enemies.get(i);
      //Collision detection.
      if ( (enemy.x<this.x+this.w && enemy.x>this.x && enemy.y>this.y && enemy.y< this.y+this.h) || (enemy.x + enemy.w <this.x+this.w && enemy.x + enemy.w>this.x && enemy.y +enemy.h>this.y && enemy.y+enemy.h< this.y+this.h) || 
        (enemy.x<this.x+this.w && enemy.x>this.x && enemy.y+enemy.h>this.y && enemy.y+enemy.h< this.y+this.h) || (enemy.x + enemy.w <this.x+this.w && enemy.x + enemy.w>this.x && enemy.y>this.y && enemy.y< this.y+this.h)) {
        gotHit(-0.1);
        score-=5;
      }
    }
  }

  void colWithMeteor() {
    //Collision detection.
    if ( (this.x<obs.x+obs.w && this.x>obs.x && this.y>obs.y && this.y< obs.y+obs.h) || (this.x + this.w <obs.x+obs.w && this.x + this.w>obs.x && this.y +this.h>obs.y && this.y+this.h< obs.y+obs.h)) {
      gotHit(-0.5);
      score-=5;
    }
  }

  //A function that receives the amount of health to reduce and returns nothing.
  void setHealth(float _health) {
    health+=_health;
    if (health<=0) {
      gameOver=true;
      newGame=false;
    }
  }

  //All of the Health bar graphical and functional characteristics.
  void healthBar() {
    stroke(150);
    strokeWeight(1);
    noFill();
    rect(10, 10, 150, 15);
    fill(255, 100);
    rect(10, 10, constrain(health*1.5, 0, 150), 15);
    textSize(12);
    fill(200);
    //I order to show only one figure after the decimal point I use the String.format function.
    text(String.format("%.1f", health)+"%", 165, 25);
    noFill();
    noStroke();
  }

  //defines what happens when the spaceship is hit. First, health is reduced.
  //Then, I create this fading out red color in order to make it look more realistic.
  void gotHit(float healthToReduce) {
    hit=true;
    setHealth(healthToReduce);
    if (hit) {
      fill(200, 0, 0, alpha);
      rect(0, 0, width, height);
      noFill();
      alpha-=10;
      if (alpha<0) {
        hit=false;
        alpha=255;
      }
    }
  }

  void hitEnemy() {
    for (int i = enemies.size()-1; i >= 0; i--) {
      Enemy enemy = (Enemy) enemies.get(i);
      for (int j = bullets.size()-1; j >= 0; j--) {
        Bullet bullet = (Bullet) bullets.get(j);
        //collision detection between the bullet and the enemy.
        if ((bullet.x+bullet.w) > enemy.x && (bullet.x+bullet.w)<(enemy.x+enemy.w) && (bullet.y+bullet.h)>enemy.y && bullet.y<(enemy.y+enemy.h) && enemy.shouldExplode==false) {
          enemy.setHealth(-50);
          if (enemy.getHealth()<=0) {
            //sets should explode to true - therefore triggering the explosion effect.
            enemy.shouldExplode = true;
          }
          bullets.remove(j);
        }
      }
      //when the explosion is over the enemy should be erased.
      if ( enemy.shouldBeErased == true)
      {
        enemies.remove(i); 
        enemy.shouldBeErased=false;
      }
    }
  }
}













