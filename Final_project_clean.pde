import java.io.File;
import java.io.*;
import javax.swing.JOptionPane;
import ddf.minim.*;

Minim minim;
AudioPlayer player;
PFont font;
File f;

// object variables
Background back = new Background();
ArrayList enemies = new ArrayList();
Button backButton;
Button newGameButton;
Boss boss;
Spaceship ship;
Bullet bullet;
Obstacle obs;

//primitive variables
boolean menu, 
newGame, 
scores, 
inst, 
gameOver, 
exit;
int level=0, 
numEnemies, 
score;
int[] highScore = new int[1];

void setup()
{
  size(600, 350);
  back.calculate();
  fileInit();
  menu=true;
  minim = new Minim(this);

  //creating a new instance of each object
  backButton= new Button(20, 20, 70, 25, "Back", 33, 40);
  newGameButton= new Button(240, 200, 120, 25, "New Game", 255, 220);
  ship = new Spaceship(20, height/2, "spaceship2.png");
  obs = new Obstacle(6);

  font=createFont("PressStart2P.ttf", 20);

  //loading a file and looping it
  player = minim.loadFile(dataPath("Sector_4.mp3"));
  player.loop();
}


void draw() {
  background(0);
  back.display();

  if (menu) {
    menu();
  }
  else if (menu==false && newGame) {
    newGame();
  }
  else if (menu==false && scores) {
    scores();
  }
  else if (menu==false && inst) {
    inst();
  }
  else if (menu==false && exit) {
    exit_game();
  }
  else if (gameOver) {
    gameOver();
  }
}

void menu() {
  String[] menuNames = {
    "START GAME", "HIGH SCORE", "INSTRUCTIONS", "EXIT"
  };

  fill(100, 130);
  rect(150, 0, 300, 350);
  textFont(font);
  fill(220);

  //centering all of the text using a small trick I thought of. 
  //I call the centerText() function in order to do so.
  for (int i=0; i<menuNames.length;i++) {
    text(menuNames[i], centerText(menuNames[i]), 120+45*i);
  }

  //If a menu line return true (only if it is clicked), move to the relevant screen
  for (int i=0 ; i<menuNames.length; i++) {
    if (mouseX>((width/2)-(textWidth(menuNames[i])/2)) && mouseX<((width/2)+(textWidth(menuNames[i])/2))&& mouseY>100+45*i && mouseY< 120+45*i) {
      cursor(HAND);
      if (menuLine(((width/2)-(textWidth(menuNames[i])/2)), 120+45*i, menuNames[i])) {
        if (i==0) {
          newGame=true;
        }
        else if (i==1) {
          scores=true;
        }
        else if (i==2) {
          inst=true;
        }
        else {
          exit=true;
        }
      }
    }
  }
}

// A function that defines what happens when hovering/clicking over each line of the menu
boolean menuLine(float textX, float textY, String text) {
  fill(255, 0, 0, 150);
  text(text, textX, textY);
  noFill();
  if (mousePressed) {
    menu=false;
    return true;
  }
  return false;
}

//new game window
void newGame() {
  //remove cursor
  noCursor();

  //call the releveant functions.
  back.move();
  ship.display();
  ship.healthBar();
  scoreBar();
  for (int i = enemies.size()-1; i >= 0; i--) {
    Enemy enemy = (Enemy) enemies.get(i);
    enemy.display();
  }

  //change levels
  if (level==0) {
    level(20, 0);
  }
  else if (level==1) {
    level(25, 0);
  }
  else if (level==2) {
    level(20, (int)random(0, 2));
    obs.display();
  }
  else if (level==3) {
    level(20, (int)random(0, 2));
    obs.display();
    obs.setSpeed(8);
  }
  else if (level==4) {
    level(25, (int)random(1, 3));
    obs.display();
    obs.setSpeed(8);
  }
  else if (level==5) {
    level(25, (int)random(1, 3));
    obs.display();
    obs.setSpeed(10);
  }
  else if (level==6) {
    level(15, (int)random(2, 4));
    obs.display();
    obs.setSpeed(10);
  }
  else if (level==7) {
    level(15, (int)random(2, 4));
    obs.display();
    obs.setSpeed(12);
  }
  else if (level==8) {
    level(15, (int)random(2, 4));
    obs.display();
    obs.setSpeed(12);
  }
  else if (level==9) {
    if (numEnemies<2) {
      enemies.add(new Boss());
      numEnemies++;
    }
    obs.display();
    obs.setSpeed(12);
    if (enemies.isEmpty()) {
      gameOver=true;
      newGame=false;
    }
  }
}

//High score window
void scores() {
  String highScoreStr = "Your highest score is:";
  backButton.display();
  if (backButton.hover()==false) {
    cursor(MOVE);
  }

  textSize(18);
  text(highScoreStr, centerText(highScoreStr), 150);
  textSize(24);
  text(highScore[0], centerText(str(highScore[0])), 200);
}

//Instructions window
void inst() {
  backButton.display();
  if (backButton.hover()==false) {
    cursor(MOVE);
  }
  text("Use keys 'w', 's', 'a' and 'd' to navigate", 25, 100);
  text("the spaceship and the space bar to shoot.", 25, 130);
  text("The objective is to obtain the highest score.", 25, 190);
  text("Make sure you don't get hit by or collide", 25, 220);
  text("into enemies!", 25, 250);
}

//Game over window
void gameOver() {

  //display the buttons
  backButton.display();
  newGameButton.display();

  if (backButton.hover()==false && newGameButton.hover()==false) {
    cursor(MOVE);
  }

  if (backButton.clicked()) {
    resetGame();
    menu=true;
    gameOver=false;
  }
  else if (newGameButton.clicked()) {
    resetGame();
    newGame=true;
    gameOver=false;
  }

  textSize(24);
  String [] answers = {
    "Ooooopppssss....!", "Well Done!", "Excellent!!"
  };
  int [] answerLimits = {
    0, 25000, 200000, 2000000, 0
  };

  //displaying the different text at the appropriate times. If the player scored less then 25000, the first answer in the array will appear etc..
  for (int i=0; i<answerLimits.length-1; i++) {
    if (constrain(score, 0, 20000000)>=answerLimits[i] && constrain(score, 0, 20000000)<answerLimits[i+1]) {
      text(answers[i], centerText(answers[i]), 120);
      //      println(answerLimits[i+1]);
    }
  }
  text("Your score is "+constrain(score, 0, 2000000), centerText("Your score is "+constrain(score, 0, 2000000)), 170);

  //if the achieved score is bigger then the previous record, replace it.
  if (score>highScore[0]) {
    highScore[0]=score;
    saveStrings("High_Scores.txt", str(highScore));
  }
}


//A function describing the pop-up that should appear when the exit game button is clicked.
void exit_game() {
  String question = "Are you sure you want to exit?";
  String title = "Exit";

  //an integer variable in range of 0 and 1 receives the answer, when 0 is YES and 1 is NO.
  int answer = JOptionPane.showConfirmDialog(null, question, title, JOptionPane.YES_NO_OPTION);
  if (answer==JOptionPane.YES_OPTION) {
    exit();
  }
  else {
    menu=true;
    exit=false;
  }
}

//A reset game function, sets all the values to the original.
void resetGame() {
  for (int i = enemies.size()-1; i >= 0; i--) {
    enemies.remove(i);
  }
  level=0;
  score=0;
  numEnemies=0;
  ship.health =100;
  ship.x=20;
  ship.y=height/2;
}

//a function that defines the number of enemies and their type on a specified level.
void level(int _numEnemies, int enemyType) {
  if (numEnemies<_numEnemies) {
    enemies.add(new Enemy(610, (int)random(20, 320), enemyType));
    numEnemies++;
  }
  else if (enemies.isEmpty()) {
    numEnemies=0;
    score += 5000;
    level++;
  }
}

//initialising the game "database" - a text file containing the highest score
void fileInit() {
  //if file exists, load it.
  if (new File(sketchPath("High_Scores.txt")).isFile())
  {
    println("Loading high score database...");
    String [] num = loadStrings("High_Scores.txt");
    highScore = parseInt(num);
    println("Successful!");
  }
  //else, create it.
  else if (!new File(sketchPath("High_Scores.txt")).isFile())
  {
    println("Creating high score database...");
    f=new File(sketchPath("High_Scores.txt"));
    saveStrings("High_Scores.txt", str(highScore));
    println("Successful!");
  }
}

void scoreBar() {
  //display score
  fill(255, 200);
  textSize(14);
  text("Score: " + constrain(score, 0, 2000000), 400, 28);
  noFill();
}

//A function that receives a string and returns its centered position according to it's length.
float centerText(String text) {
  return ((width/2)-(textWidth(text)/2));
}

void keyPressed()
{
  ship.keyPressed();
}

void keyReleased()
{
  ship.keyReleased();
}

void mouseReleased() {
  if (backButton.hover()) {
    menu=true;
    scores=false;
    inst=false;
    gameOver=false;
  }
}

void exit() {
  player.close();
  ship.shoot.close();
  minim.stop();
  super.exit();
}

