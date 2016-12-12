// Student's should use this to render their model

class Dancer {
  boolean personOne;
  //color blue;
  pt BodyProjection = P();
  pt BodyCenter = P();
  public Dancer(boolean personOne) {
    this.personOne = personOne;
  }
  
  float footRadius=3, kneeRadius = 6, hipRadius=12 ; // radius of foot, knee, hip
  float hipSpread = hipRadius; // half-displacement between hips
  float bodyHeight = 100; // height of body center B
  float ankleBackward=10, ankleInward=4, ankleUp=6, ankleRadius=4; // ankle position with respect to footFront and size
  float pelvisHeight=10, pelvisForward=hipRadius/2, pelvisRadius=hipRadius*1.3; // vertical distance form BodyCenter to Pelvis 
  float LeftKneeForward = 20; // arbitrary knee offset for mid (B,H)
  //added 
  float RightKneeForward = 20;
  //upperbody/chest 
  float upperbodyHeight  = pelvisHeight+50; 
  float upperbodyRadius = pelvisRadius+1;
  //shoulder 
  float shoulderHeight = upperbodyHeight+12; 
  float shoulderRadius = pelvisRadius*0.5;
  //neck
  float neckRadius = pelvisRadius/3;
  //head
  float headRadius = pelvisRadius/1.3;
  float face = pelvisRadius/1.45;
  float chinRadius = face*0.55;
  //arm
  float midArmRadius = shoulderRadius*0.8;
  float handRadius = shoulderRadius*0.64;
  
  //vec Up = V(0,0,1); // up vector
  //vec Right = N(Up,Forward); // side vector pointing towards the right
  //pt BodyProjection = L(left,1./3+transfer/3,right); // floor projection of B
  //pt BodyCenter = P(BodyProjection,bodyHeight,Up); // Body center
  //fill(blue); showShadow(BodyCenter,5); // sphere(BodyCenter,hipRadius);
  //fill(blue); arrow(BodyCenter,V(100,Forward),5); // forward arrow

  void location(pt left, pt right) {
    float location=0;
    pt begin = P();
    pt end = P();
    //This is a condition when dancer in the phase of "transfer and collect"
    if (phase==2) {
      if (toRight) {
        begin = right; end = left; 
      }
      else{
        begin = left; end = right;
      }
      location = 1;
    }
    //This is a condition when dancer in the phase of "rotate"
    else if (phase<=1) { 
      if (toRight) {
        begin = right; end = left; 
      }
      else{
        begin = left; end = right;
      }
      location = 1.2*t + 0.4; 
    } 
    //This is a condition when dancer in the phase of "aim"
    else {
      if (toRight) {
        begin = left; end = right; 
      }
      else{
        begin = right; end = left;
      }
      location = -1 + 1.2*t;
    }
    BodyCenter = P(BodyProjection, bodyHeight, V(0, 0, 1)); BodyProjection = L(begin, location, end); 
  }
  
  pt triangle(pt A, float rA, pt B, float rB, vec direction, boolean bool) {
      vec vecAB = U(V(A,B));
      vec unitAB = U(N((U(N(direction,vecAB))),vecAB));
      float w = (sq(rA)-sq(rB)+sq((d(A,B))))/(2*(d(A,B)));
      float h = sqrt(sq(rA)-sq(w));
      if (bool){
        return P(A,w,vecAB,-h,unitAB);
      }
      else{
        return P(A,w,vecAB,h,unitAB);
      }
  }
    

  void display(pt left, pt right, vec Forward)
  {
    vec Up = V(0, 0, 1); // up vector
    vec Right = N(Up, Forward); // side vector pointing towards the right

    // BODY
    location (left, right);
    fill(blue); showShadow(BodyCenter, 5); 

    // ANKLES
    pt RightAnkle =  P(right, -ankleBackward, Forward, -ankleInward, Right, ankleUp, Up);
    fill(red);  
    capletSection(right, footRadius, RightAnkle, ankleRadius);  
    pt LeftAnkle =  P(left, -ankleBackward, Forward, ankleInward, Right, ankleUp, Up);
    fill(green);  
    capletSection(left, footRadius, LeftAnkle, ankleRadius);  
    fill(blue);  
    sphere(RightAnkle, ankleRadius);
    sphere(LeftAnkle, ankleRadius);

    //HEELS added
    pt HeelRight = triangle(RightAnkle,10,right,15,Forward,false);
    fill(blue); 
    sphere(HeelRight,ankleRadius);
    
    // FEET (CENTERS OF THE BALLS OF THE FEET)
    fill(blue);  
    sphere(right, footRadius);
    pt RightToe =   P(right, 5, Forward);
    capletSection(right, footRadius, RightToe, 1);
    sphere(left, footRadius);
    pt LeftToe =   P(left, 5, Forward);
    capletSection(left, footRadius, LeftToe, 1);
 
    // HIPS
    pt RightHip =  P(BodyCenter, hipSpread, Right);
    pt current = P(RightHip.x,RightHip.y,0);
    if (personOne){ 
      hipOne = current; 
    }
    else {
      hipTwo = current;
    }
    fill(red); sphere(RightHip, hipRadius);
    pt LeftHip =  P(BodyCenter, -hipSpread, Right);
    current = P(LeftHip.x,LeftHip.y,0);
    if (personOne){
      hipThree = current; 
    }
    else {
      hipFour = current;
    }
    fill(green); sphere(LeftHip, hipRadius);

    // KNEES AND LEGs
    //float RightKneeForward = 20;
    //pt RightMidleg = P(RightHip,RightAnkle);
    pt RightKnee = triangle(RightHip,72,RightAnkle,62,Forward,true);
    fill(red);sphere(RightKnee, kneeRadius);
    capletSection(RightHip, hipRadius, RightKnee, kneeRadius);  
    capletSection(RightKnee, kneeRadius, RightAnkle, ankleRadius);  

    pt LeftMidleg = P(LeftHip, LeftAnkle);
    pt LeftKnee =  P(LeftMidleg, LeftKneeForward, Forward);
    fill(green);  
    sphere(LeftKnee, kneeRadius);
    capletSection(LeftHip, hipRadius, LeftKnee, kneeRadius);  
    capletSection(LeftKnee, kneeRadius, LeftAnkle, ankleRadius);  

    // PELVIS
    pt Pelvis = P(BodyCenter, pelvisHeight, Up, pelvisForward, Forward); 
    fill(blue); 
    sphere(Pelvis, pelvisRadius);
    capletSection(LeftHip, hipRadius, Pelvis, pelvisRadius);  
    capletSection(RightHip, hipRadius, Pelvis, pelvisRadius);  

    //BODY
    pt Midbody = P(BodyCenter, pelvisHeight+21, Up, pelvisForward, Forward); 
    fill(blue); sphere(Midbody, pelvisRadius-4);
    capletSection(Pelvis, pelvisRadius, Midbody, pelvisRadius-5);
    upperbodyHeight  = pelvisHeight+41;
    pt Chest = P(BodyCenter,upperbodyHeight ,Up, pelvisForward,Forward);
    fill(blue); sphere(Chest,pelvisRadius);
    capletSection(Midbody,pelvisRadius-5,Chest,upperbodyRadius);
    shoulderHeight = upperbodyHeight +11;
    pt ShoulderLeft = P(BodyCenter,shoulderHeight,Up,pelvisForward,Forward,upperbodyRadius,Right);
    pt ShoulderRight = P(BodyCenter,shoulderHeight,Up,pelvisForward,Forward,-upperbodyRadius,Right);
    fill(blue); sphere(ShoulderLeft,shoulderRadius); sphere(ShoulderRight,shoulderRadius);
    capletSection(ShoulderLeft,shoulderRadius,Chest,upperbodyRadius);
    capletSection(ShoulderRight,shoulderRadius,Chest,upperbodyRadius);
    pt Neck = P(BodyCenter,pelvisHeight+76,Up, pelvisForward,Forward);
    fill(blue);
    capletSection(Chest,neckRadius+3,Neck,neckRadius);
    
    //FIXED ARMS
    pt MidArmLEFT = P(BodyCenter,shoulderHeight,Up,pelvisForward,Forward,upperbodyRadius+36,Right);
    pt MidArmRIGHT = P(BodyCenter,shoulderHeight,Up,pelvisForward,Forward,-upperbodyRadius-36,Right);
    fill(blue); sphere(MidArmLEFT,midArmRadius); sphere(MidArmRIGHT,midArmRadius);
    capletSection(ShoulderLeft,shoulderRadius,MidArmLEFT,midArmRadius);
    capletSection(ShoulderRight,shoulderRadius,MidArmRIGHT,midArmRadius);
    pt HandPartLEFT = P(BodyCenter,shoulderHeight+30,Up,pelvisForward,Forward,upperbodyRadius+5,Right);
    pt HandPartRIGHT = P(BodyCenter,shoulderHeight+30,Up,pelvisForward,Forward,-upperbodyRadius-5,Right);
    fill(blue); sphere(HandPartLEFT,handRadius); sphere(HandPartLEFT,handRadius);
    capletSection(MidArmLEFT,midArmRadius,HandPartLEFT,handRadius);
    capletSection(MidArmRIGHT,midArmRadius,HandPartRIGHT,handRadius);
 
    //HEAD
    pt headsback = P(BodyCenter,pelvisHeight+76,Up, pelvisForward-2,Forward);
    fill(blue); sphere(headsback,headRadius);
    pt headsfront = P(BodyCenter,pelvisHeight+76,Up, pelvisForward,Forward);
    fill(blue); sphere(headsfront,face);
    capletSection(headsfront,face,headsback,headRadius);
    pt chinPart = P(BodyCenter,pelvisHeight+70,Up, pelvisForward+6,Forward);
    fill(blue); sphere(chinPart,chinRadius);
    capletSection(chinPart,chinRadius,headsfront,face);
    capletSection(chinPart,chinRadius,headsback,headRadius);

  }
  
  
  void capletSection(pt A, float a, pt B, float b) { // cone section surface that is tangent to Sphere(A,a) and to Sphere(B,b)
    vec VecOne = R(U((V(B,A))));
    vec VecTwo = V((P(A,(S(a, VecOne)))),(P(B,(S(b, VecOne)))));
    float alpha = angle((V(B,A)),VecTwo);
    vec VecThree = S(a * sin(alpha),U((V(B,A))));
    vec VecFour = S(b * sin(alpha),U((V(B,A))));
    pt offA = P(A, VecThree); 
    pt offB = P(B, VecFour);    
    coneSection(offA,offB,a*cos(alpha),b*cos(alpha));
    }  
} //<>//