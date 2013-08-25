public class Enemy
{
  int x, 
  y, 
  t3_shoot, 
  r = 1, 
  alpha=255, 
  screenBuffer=65, 
  health, 
  bulletSizeX, 
  bulletSizeY, 
  scoreVal;

  float w, 
  h, 
  counter, 
  speedX, 
  speedY, 
  t1, 
  t2, 
  initHealth, 
  damage;

  boolean shouldExplode, 
  shouldBeErased, 
  shoot;

  PImage img;

  ArrayList bullets = new ArrayList();
  AudioSnippet explode;

  color bulletColor = #FF3030;

  Enemy(int _x, int _y, int type)
  {
    x=_x;
    y=_y;

    //different properties for different kinds of enemies.
    if (type==0) {
      properties("enemy1.png", 25, (25/1.3), 50, 0.2, 20, 3, 1000);
    }
    else if (type==1) {
      properties("enemy2.png", 25, 25, 100, 1, 30, 5, 2000);
    }
    else if (type==2) {
      properties("enemy3.png", 30, 30, 200, 2, 30, 5, 3000);
      bulletColor = #CD7F32;
    }
    else if (type==3) {
      properties("enemy4.png", 50, 50/1.41, 500, 5, 30, 5, 5000);
      bulletColor = #FFFFFF;
    }
    else if (type==4) {
      properties("enemy5.png", 80, 80/1.3, 2500, 0.25, 30, 5, 20000);
    }

    initHealth = health;
    explode = minim.loadSnippet(dataPath("explosion.wav"));
    explode.setGain(-8);
  }

  //A function gathering all of the differences between the enemies
  void properties(String image, float _w, float _h, int _health, float _damage, int _bulSizeX, int _bulSizeY, int _scoreVal) {
    img = loadImage(image);
    w=_w;
    h=_h;
    health=_health;
    damage=_damage;
    bulletSizeX=_bulSizeX;
    bulletSizeY=_bulSizeY;
    scoreVal=_scoreVal;
  }

  //calling all of the relevant functions.
  void display() {
    counter();
    move();
    shoot();
    hitSpaceship();

    //if the enemy is alive, show health bar and the image, else - explode.
    if (shouldExplode == false)
    {
      healthBar();
      image(img, x, y, w, h);
    }

    else
    {
      explosion();
    }
  }

  //The health bar changing colors according to the strength of the enemy
  void healthBar() {
    if (getHealth()<=initHealth && getHealth() >initHealth/2) {
      fill(0, 200, 0);
    }
    else if (getHealth()<=initHealth/1.5 && getHealth()>initHealth/4) {
      fill(255, 130, 0);
    }
    else {
      fill(200, 0, 0);
    }
    rect(x, y-5, w*getHealth()/initHealth, 2);
  }

  void move()
    //the enemy moves according to a counter, this counter intialises the 
    //enemy speed and time it should move by every 10 seconds.
  {
    if (counter >0 && counter < 1)
    {
      speedX = (int)random(-3, -1);
      speedY = (int)random(-3, 3);
      t1 = random(0.02, 5);
      t2 = random(5, 10);
      if ((t2-t1) > 6) {
        t1 = 0;
        t2 = 0;
      }
    }
    else if (counter > t1 && counter < t2)
    {
      x += speedX;
      y += speedY;
    }

    //setting the bounds for the enemies. I've added a screen buffer in order 
    //to draw the enemies outside the screen and then make them enter the screen elegantly.
    speedY=bounds(y, h, speedY, 0, height);
    speedX=bounds(x, w, speedX, 60, width+screenBuffer);
  }

  //Counter function. I tried making this function return a float and hence no need for the counter float variable,
  //but for some reason it didn't count at a normal speed, it counted much faster.
  void counter()
  {
    counter+=1/frameRate;
    if (counter > 10)
    {
      counter=0;
    }
  }

  // A funditon that receives the location of the enemy 
  //and return the speed, either positive or negative.
  float bounds(int pos, float size, float speed, int minScreenSize, int screenSize) { 
    if ((pos+size)>screenSize || pos<=minScreenSize) {
      return -1*speed;
    }
    else return speed;
  }

  //explosion properties: size, color etc.
  void explosion() {
    explode.play();
    int limit=10;
    if (r>0 && r<100) {
      fill(255, 125, 0, alpha);
      ellipse(x+w/2, y+h/2, r, r);
      r+=5;
      alpha-=8;
    }
    else {
      shouldBeErased = true;
    }
  }

  //A function that receives the amount of health to reduce and returns nothing.
  void setHealth(float _health) {
    health+=_health;
    if (health==0) {
      score+=scoreVal;
    }
  }

  //A simple function that return the current health
  int getHealth() {
    return health;
  }


  //Same Idea as the move function, also using the same counter but with different usage.
  void shoot() {
    if (counter>0 && counter<0.1)
    {
      t3_shoot=(int)random(0.1, 8);
      shoot=true;
    }
    else if (counter>t3_shoot && x<width) {
      if (shoot) {
        //in order to shoot one bullet at a time I had to create a boolean that turns off just after I add
        // one bullet, therefore stops the function from adding more bullets and shooting them.
        bullets.add(new Bullet(x, y+h/2, -8, bulletColor, bulletSizeX, bulletSizeY));
        shoot=false;
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

  void hitSpaceship() {
    for (int i = bullets.size()-1; i >= 0; i--) {
      Bullet bullet = (Bullet) bullets.get(i);
      if ((bullet.x<ship.x+ship.w) && (bullet.x>ship.x)&&(bullet.y<ship.y+ship.h)&&(bullet.y>ship.y)) {
        //depending on the enemy type, the matching damage will be removed from the spaceship's health.
        ship.gotHit(-damage);
        bullets.remove(i);
      }
    }
  }
}

