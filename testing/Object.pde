class Object {

  float x, y, xVel, yVel, w, h;
  float vol; 
  float r, g, b;
  boolean isHit = false; 
  float timer = -1;
  boolean changed = false;
  float cTimer = -1; 
  float angle; 
  
  Object() {
    //rgb(66, 134, 244)
    //rgb(60, 97, 155)
    r = 153; 
    g = 209; 
    b = 255;
    
    //rgb(143, 224, 247)


    //r = 255; 
    //g = 255;
    //b = 255;
      
    //vol = w; 
    //r = 60;
    //g = 97;
    //b = 155;

    angle = random(-PI/8, PI/8); 

  }

  void collision(ObjectR o) {

    boolean eqBlueBigger = o.w >= w - 10 && o.w <= w + 10;
    boolean eqRedBigger = w >= o.w - 10 && w <= o.w + 10;

    if (isHit == false) {      
      if (dist(o.x, o.y, x, y) < o.w/2 + w/2 && o.w > w            //if touching and red is bigger than blue  [(o.w - w) > 30]
        && o.w > 150 && w > 150                                    //if both are bigger than 150
        && !(o.w <= 150) && !(w <= 150)                            //if size is not lower than 150
        && !eqRedBigger) { 
        //bouncing off: small vs. large
        println("scenario 1: bounce");
        o.xVel = -o.xVel;
        xVel = -xVel; 
        //o.yVel = -o.yVel;
        //yVel = - yVel; 
        isHit = true;
        o.isHit = true;
      } else if (dist(o.x, o.y, x, y) < o.w/2 + w/2 && w > o.w             //if touching and blue is bigger than red 
        && o.w > 150 && w > 150                                            //if both are bigger than 150 
        && !(o.w <= 150) && !(w <= 150)                                    //if size is not lower than 150
        && !eqBlueBigger) {
        //bouncing off: large vs small
        println("scenario 2: bounce");
        o.xVel = -o.xVel;
        xVel = -xVel; 
        //o.yVel = -o.yVel;
        //yVel = - yVel; 
        isHit = true;
        o.isHit = true;
      } else if (dist(o.x, o.y, x, y) < o.w/2 + w/2              //if touching
        && w > 5 && w <= 150 && o.w > 5 && o.w <= 150            //sizes are regular (above 5, but under/equals 150)            
        && ((eqBlueBigger) || (eqRedBigger)) ) {                    //sizes are about the same (difference of 20 or less)) {   //normal && o.w <100 && o.w > 20 && w <100 && w > 20
        //merging: removes original circles and creates new object
        isHit = true;
        o.isHit = true; 
        println("scenario 3: purple merge"); 
        boom.remove(this);
        boomR.remove(o); 
        //purple
        ObjectM lala = new ObjectM(x, y);
        lala.w = w; 
        lala.h = h; 
        merge.add(lala); 
        //lala.drawMe();
      } else if (isHit == false && o.isHit == false 
        && dist(o.x, o.y, x, y) < o.w/2 + w/2 && w > o.w                                         //if circles are touching and blue is bigger than red
        && ((w > 5 && w <= 150 && o.w > 5 && o.w <= 150 && !eqBlueBigger && !eqRedBigger)        //case 1: both circles are medium and not at equilibrium
        || (w > 150 && o.w > 5 && o.w <= 150 && !eqBlueBigger)                                   //case 2: blue (w) is loud (>150), red (o.w) is medium and not at equilibrium
        || (o.w > 150 && w > 5 && w <= 150 && !eqRedBigger)  )) {  //if circles are touching and left circ is bigger than right circ
        //merging: two circles touch and travel together
        isHit = true;
        o.isHit = true; 
        println("scenario 4: merge and go right");
        float xDist = o.x - x;
        float yDist = o.y - y;
        //println(xDist, yDist);

        float newOX = x + xDist;
        float newOY = y + yDist;

        o.x = newOX;
        o.y = newOY;
        o.xVel = xVel;
        o.yVel = yVel;
      } else if ((dist(o.x, o.y, x, y) < o.w/2 + w/2 )&& w < o.w && isHit ==false && o.isHit == false) {  //if circles are touching and left circ is smaller than right circ
        //merging: two circles touch and travel together
        isHit = true;
        o.isHit = true; 
        println("scenario 5: merge and go left");
        float xDist = o.x - x;
        float yDist = o.y - y;
        //println(xDist, yDist);

        float newOX = x + xDist;
        float newOY = y + yDist;

        //o.x = x; 
        //o.y = y; 

        o.x = newOX;
        o.y = newOY;
        xVel = o.xVel;
        yVel = o.yVel;
      } else if (isHit == false && o.isHit == false 
        && dist(o.x, o.y, x, y) < o.w/2 + w/2 && w < o.w                                         //if circles are touching and blue is bigger than red
        && ((o.w > 5 && o.w <= 150 && w > 5 && w <= 150 && !eqBlueBigger && !eqRedBigger)        //case 1: both circles are medium and not at equilibrium
        || (o.w > 150 && w > 5 && w <= 150 && !eqRedBigger)                                      //case 2: blue (w) is loud (>150), red (o.w) is medium and not at equilibrium
        || (w > 150 && o.w > 5 && o.w <= 150 && !eqBlueBigger)  )                                //if circles are touching and left circ is smaller than right circ
        ) {  
        //merging: two circles touch and travel together
        println("scenario 5: merge and go left");
        isHit = true;
        o.isHit = true;
        float xDist = o.x - x;
        float yDist = o.y - y;
        //println(xDist, yDist);

        float newOX = x + xDist;
        float newOY = y + yDist;

        o.x = newOX;
        o.y = newOY;
        xVel = o.xVel;
        yVel = o.yVel;
      } else if (dist(o.x, o.y, x, y) < o.w/2 + w/2 
        && isHit == false && o.isHit == false) {
        //explosion: if blue is bigger than red, remove both objects and create explosion
        if (o.w > 150 && w > 150 
          && eqBlueBigger) {
          println("Scenario 6: Blue bigger than red, explode");
          isHit = true;
          o.isHit = true;

          int current = 0;
          while (current != 30) {
            current += 1;
            Particle p = new Particle(x, y);
            explosion.add(p);
          }
          boom.remove(this);
          boomR.remove(o);
        } else if (o.w > 150 && w > 150
          && eqRedBigger) {
          //explosion: if red is bigger than blue, remove both objects and create explosion

          println("Scenario 7: Red bigger than blue, explode.");
          isHit = true;
          o.isHit = true;

          int current = 0;
          while (current != 30) {
            current += 1;
            Particle p = new Particle(x, y);
            explosion.add(p);
          }
          boom.remove(this);
          boomR.remove(o);
        }
      }
    }
    }


    void drawMe() {
      
      if(xVel ==0 && yVel== 0){
       boom.remove(this); 
      }
      
      if (timer>0) {
        timer --;
      }
      if (timer == 0) {
        boom.remove(this);
      }
      pushMatrix();
      pushStyle(); 
      rectMode(CENTER);
      noStroke(); 
      if(w>=200){
       rotate(angle); 
      }
      //translate(x,y);
      //if(w<6){
      //  r = 143;
      //  g = 224;
      //  b = 247;
      //}
      //if(w>=6 && w<200){ //rgb(127, 198, 219)
      //  r = 127;
      //  g = 198;
      //  b = 219;
      //}
      //if(w>=200){ //rgb(107, 168, 186)
      //  r =  255;
      //  g = 255;
      //  b = 255;
      //}
      fill(r, g, b);
      ellipse(x, y, w, h);
  
      if (w>=0 && w<=5) {         //whispers
        //println("size is right"); 
        if (x >= (500)) { 
          x += xVel;
          y += yVel;
          if (xVel>0) {
            xVel -= 0.1;
          }          
          if (yVel>0) {
            yVel -= 0.01;
          }
          if (yVel <= 0 && xVel <= 0) {         //need to set a timer and after timer it removes itself
            g = 255;
            if (timer == -1)
              timer = 50;
          }
        } else {
          x += xVel;
          y += yVel;
        }
      }
      if (w>5 && w<200) {      //normal 
        x += xVel;
        y += yVel;
        if (x >= (width/2)) { 
          x += xVel;
          y += yVel;
          if (xVel>0) {
            xVel -= 0.1;
          }
          if (yVel>0) {
            yVel -= 0.01;
          }
          //else if(yVel<0){
          //  yVel += 0.01;  
          //}
          if (yVel <= 0 && xVel <= 0) {         //need to set a timer and after timer it removes itself
            g = 255;
            if (timer == -1)
              timer = 50;
          }
        } else {
          x += xVel;
          y += yVel;
        }
      }
      if (w>=200) {
          x += xVel;
          y += yVel;   
        
        cTimer ++; 
        if(cTimer >= 15 && changed == false){
          yVel = -yVel; 
          changed = true;
          cTimer = 0; 
        }
        else if(cTimer>=15 && changed == true){
          yVel = -yVel; 
          changed = false; 
          cTimer = 0;
        }   
        //if (x >= (width/2)) { 
          
          //x += xVel;
          //y += yVel;
          //if (xVel>0) {
          //  xVel -= 0.1;
          //}          
          //if (yVel>0) {
          //  yVel -= 0.01;
          //}
          ////if(yVel<0){
          ////  yVel += 0.01;  
          ////}
          //if (yVel <= 0 && xVel <= 0) {         //need to set a timer and after timer it removes itself
          //  g = 255;
          //  if (timer == -1)
          //    timer = 50;
          //}
        //} 
        //else {
          //x += xVel;
          //y += yVel;
        }
//      }
              
      for (int i = 0; i<boomR.size(); i ++) {
        collision(boomR.get(i));
      }
      popStyle();
      popMatrix(); 
    }
  }