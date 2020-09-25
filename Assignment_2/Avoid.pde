class Avoid {
   PVector pos;
   color fillColour;
   
   //Constructor
   Avoid (float xx, float yy, color colour) {
     pos = new PVector(xx,yy);
     fillColour = colour;
   }
   
   void go () {
     
   }
   
   void draw () {
     //fill(0, 255, 200);
     fill(fillColour);
     ellipse(pos.x, pos.y, 15, 15);
   }
}
