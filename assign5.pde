// game state constants
final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;

// game state variable
int gameState;

// enemy form constants
final int STRAIGHT = 0;
final int SLOPE = 1;
final int DIAMOND = 2;

// image variables
PImage gameStartImg1;
PImage gameStartImg2;
PImage backgroundImg1;
PImage backgroundImg2;
PImage enemyImg;
PImage fighterImg;
PImage hpImg;
PImage treasureImg;
PImage endImg1;
PImage endImg2;
PImage shootImg;
//PImage [] flameImg;

// object x and y
int rectX;
float treasureX;
float treasureY;
//float enemyY;
//float enemyX;
int bg1X;
int bg2X;
float fighterX, fighterY;
int[] enemyX;
int[] enemyY;
float[] shootX;
float[] shootY;
//float [] flameX;
//float [] flameY;

// other variables
// number of enemys
int enemyCount = 8;

// max number of shoots
int maxShoot = 5;

// shoot counter
int shoot = 0;

// button
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

// fly speed
int speed = 5;

// shoot speed
int shootSpeed = 5;

// determine enemy form (straight, slope, diamond)
int times = 1;

// score
int score = 0;





void setup () {
  size(640, 480) ;
  loadAllImage();
  setXAndY();
  enemyX = new int[enemyCount];
  enemyY = new int[enemyCount];
  shootX = new float[maxShoot];
  shootY = new float[maxShoot];
  initialShoot();
  gameState = 0;
  addEnemy(0);
  

}

void draw()
{
  switch(gameState){
    
    case GAME_START:
      image(gameStartImg1,0,0);
      if(mouseX > 210 && mouseX < 440){
        if(mouseY > 380 && mouseY < 410){
          image(gameStartImg2,0,0);
          if(mousePressed){
            gameState = GAME_RUN;
          }
        }
      }
      break;
    case GAME_RUN:
      // set background
      backgroundMoving();
      
      // show treasure, fighter, hp, enemys, shoots
      image(treasureImg,treasureX,treasureY);
      image(fighterImg,fighterX,fighterY);
      printEnemys();
      fill(255,0,0);
      rectMode(CORNERS);
      rect(15,10,rectX,40);
      image(hpImg,10,10);
      printShoots();
      
      fill(255,255,255);
      textSize(32);
      text("Score: " + score, 0, 440);
      
      // determine next form of enemy
      if(times%3 == 1){
        if(enemyX[4] == 640){
          addEnemy(SLOPE);
          times++;
        }
      }
      else if(times%3 == 2){
         if(enemyX[4] == 640){
          addEnemy(DIAMOND);
          times++;
        }
      }
      else{
         if(enemyX[7] == 640){
          addEnemy(STRAIGHT);
          times++;
        }
      }
      
      // detect button
      if (upPressed) {
        if(fighterY != 0){
          fighterY -= speed;
        }
      }
      if (downPressed) {
        if(fighterY != height-50){
          fighterY += speed;
        }
      }
      if (leftPressed) {
        if(fighterX != 0){
          fighterX -= speed;
        }
      }
      if (rightPressed) {
        if(fighterX != width-50){
          fighterX += speed;
        }
      }
      
      // detect if enemy hit fighter
      for(int i = 0; i < enemyCount; i++){
        if(fighterX >= enemyX[i]-45 && fighterX < enemyX[i]+60 && fighterY >= enemyY[i]-45 && fighterY <= enemyY[i]+60){
          enemyY[i] = 480;
          rectX = rectX - 40;
          if(rectX < 15){
            rectX = 15;
          }
          
          if(rectX <= 15){
            gameState = GAME_OVER;
          }
          
          
        }
      }
      
      // detect if fighter eat treasure
      if(fighterX >= treasureX-45 && fighterX < treasureX+40 && fighterY >= treasureY-45 && fighterY <= treasureY+40){
        
        treasureX = random(600);
        treasureY = random(440);
        rectX = rectX + 20;
        if(rectX >= 215){
          rectX = 215;
        }
        
      }
      
      // detect if shoot shot enemys
      for(int i = 0; i < enemyCount; i++){
        for(int j = 0; j < maxShoot; j++){
          if((enemyX[i] != -1 || enemyY[i] != -1)&&(shootX[j] != -1 || shootY[j] != -1)){
            if(shootX[j] >= enemyX[i]-45 && shootX[j] < enemyX[i]+60 && shootY[j] >= enemyY[i]-45 && shootY[j] <= enemyY[i]+60){
              shootX[j] = -1;
              shootY[j] = -1;
              enemyY[i] = 480;
              scoreChange(20);
            }
          }
        }
      }
      
      for(int i = 0; i < maxShoot; i++){
        if(shootX[i] + shootImg.width <= 0){
          shootX[i] = -1;
          shootY[i] = -1;
        }
      }

      break;
    case GAME_OVER:
      // reset hp
      rectX = 215;
      
      image(endImg1,0,0);
      if(mouseX > 210 && mouseX < 440){
        if(mouseY > 315 && mouseY < 345){
          image(endImg2,0,0);
          if(mousePressed){
            gameState = GAME_RUN;
          }
        }
      }
      // reset enemys
      addEnemy(STRAIGHT);
      // reset times
      times = 1;
      // reset shoot
      initialShoot();
      score = 0;
      break;
          
  }
}

// 0 - straight, 1-slope, 2-dimond
void addEnemy(int type)
{	
	for (int i = 0; i < enemyCount; ++i) {
		enemyX[i] = -1;
		enemyY[i] = -1;
	}
	switch (type) {
		case 0:
			addStraightEnemy();
			break;
		case 1:
			addSlopeEnemy();
			break;
		case 2:
			addDiamondEnemy();
			break;
	}
}

void addStraightEnemy()
{
	float t = random(height - enemyImg.height);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h;
	}
}
void addSlopeEnemy()
{
	float t = random(height - enemyImg.height * 5);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h + i * 40;
	}
}
void addDiamondEnemy()
{
	float t = random( enemyImg.height * 3 ,height - enemyImg.height * 3);
	int h = int(t);
	int x_axis = 1;
	for (int i = 0; i < 8; ++i) {
		if (i == 0 || i == 7) {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h;
			x_axis++;
		}
		else if (i == 1 || i == 5){
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 1 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 1 * 40;
			i++;
			x_axis++;
			
		}
		else {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 2 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 2 * 40;
			i++;
			x_axis++;
		}
	}
}

void loadAllImage(){
  gameStartImg1 = loadImage("img/start2.png");
  gameStartImg2 = loadImage("img/start1.png");
  backgroundImg1 = loadImage("img/bg1.png");
  backgroundImg2 = loadImage("img/bg2.png");
  enemyImg = loadImage("img/enemy.png");
  fighterImg = loadImage("img/fighter.png");
  hpImg = loadImage("img/hp.png");
  treasureImg = loadImage("img/treasure.png");
  endImg1 = loadImage("img/end2.png");
  endImg2 = loadImage("img/end1.png");
  shootImg = loadImage("img/shoot.png");
}

void setXAndY(){
  bg2X = 640;
  bg1X = 0;
  rectX = 55;
  treasureX = random(600);
  treasureY = random(440);
  fighterX = 580;
  fighterY = 240;
}

void keyPressed(){
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
  else if(key == ' '){
    for(int i = 0; i < maxShoot; i++){
      if(shootX[i] == -1){
        shootX[i] = fighterX - shootImg.width;
        shootY[i] = fighterY + (fighterImg.height / 2) - (shootImg.height / 2);
        break;
      }
    }  
  }
}

void keyReleased(){
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }
  
}

void backgroundMoving(){
  image(backgroundImg2,bg2X-640,0);
  image(backgroundImg1,bg1X-640,0);
  bg2X = bg2X + 1;
  bg2X = bg2X % 1280;                                                                    
  bg1X = bg1X + 1;
  bg1X = bg1X % 1280;
}

void printEnemys(){
  for (int i = 0; i < enemyCount; ++i) {
    if (enemyX[i] != -1 || enemyY[i] != -1) {
      image(enemyImg, enemyX[i], enemyY[i]);
      enemyX[i]+=speed;
    }
  }
}

void initialShoot(){
 for(int i = 0; i < maxShoot; i++){
   shootX[i] = -1;
   shootY[i] = -1;
 }
}

void printShoots(){
  for (int i = 0; i < maxShoot; ++i) {
    if (shootX[i] != -1 || shootY[i] != -1) {
      image(shootImg, shootX[i], shootY[i]);
      shootX[i]-=shootSpeed;
    }
  }
}

void scoreChange(int value){
  score = score + value;
}
