//  ******************* Tango dancer 3D 2016 ***********************
Boolean animating=true, PickedFocus=false, center=true, showViewer=false, showBalls=false, showCone=true, showCaplet=true, showImproved=true, solidBalls=false;
float t=0;
int phase = 0; 
int step = 2;
boolean toRight=true;
vec PersonOneDir;
pt begin;
pt target;
pt weight;
pt alt;
pt PersonTwoALT;
pt hipFour, hipTwo;
pt hipThree, hipOne;
Dancer personOne, personTwo;
pts PathOne;
void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  size(750, 750, P3D); // P3D means that we will do 3D graphics
  noSmooth();
  frameRate(43);
  personOne = new Dancer(true); 
  //TODO
  //personTwo
  PathOne = new pts();
  PathOne.declare();
  PathOne.loadPts("data/pts");
  //load path here 
  begin = PathOne.G[0];weight = PathOne.G[PathOne.nextPOINT(0)];target = PathOne.G[PathOne.nextPOINT(1)];  
  }


void draw() {
  background(255);
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  showFloor(); // draws dance floor as yellow mat
  doPick(); // sets point Of and picks closest vertex to it in P (see pick Tab)
  t+=1.0/((71/30.0)*43);
  if(t>1){
    t=0; toRight=!toRight;
  }
  phase = (t<0.5)?((t<0.25)?0:1):((t<0.75)?2:3);
  if(t==0) {
    begin=weight;weight=target;
    step=PathOne.nextPOINT(step);
    target=PathOne.G[step];
  }
  pt A = PathOne.Pt(0);
  pt B = PathOne.Pt(1);
  fill(black);  
  PersonOneDir = V(1,0,0);
  pt r=B,l=A;
  PersonOneDir = PersonDirection (toRight,PathOne);
  l=position (toRight, true,begin,weight,target,hipOne,hipThree).x;
  r=position (toRight, true,begin,weight,target,hipOne,hipThree).y;

  //DANCE PATH
  pushMatrix(); noFill(); PathOne.loop = true;
  pen(green,4);
  PathOne.drawCurve(); PathOne.lineFunc();
  noStroke(); popMatrix();
  
  //PERSON FIGURE 
  personOne.display(l,r, PersonOneDir); 
  
   //if(viewpoint) {Viewer = viewPoint(); viewpoint=false; showViewer=true;} // remember current viewpoint to shows viewer/floor frustum as part of the scene
     
 //if(showViewer) // shows viewer/floor frustum (toggled with ',')
 //    {
 //    noFill(); stroke(red); show(Viewer,P(200,200,0)); show(Viewer,P(200,-200,0)); show(Viewer,P(-200,200,0)); show(Viewer,P(-200,-200,0));
 //    noStroke(); fill(red,100); 
 //    show(Viewer,5); noFill();
 //    }
  
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas

  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX,mouseY,26,26); fill(red); text(key,mouseX-5,mouseY+4);}  
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  //if (animating) { t+=PI/30; if(t>=TWO_PI) t=0; s=(cos(t)+1.)/2; } // periodic change of time 
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
}
  
//recursion function, returns pair points 
class pointFunc {
  pt x,y;
  public pointFunc(pt x, pt y) {
    this.x=x;this.y=y;
  }
}

pointFunc position (boolean bool1, boolean bool, pt begin, pt weight, pt target, pt bottom, pt bottom1) {
  pt pointOne=P(); 
  pt pointTwo=P();
  if (bool1) {
    pointOne=weight;
  } 
  else {
    pointTwo=weight;
  }
  
  //based on phase
  if (phase == 0) {if (bool1) {pointTwo=begin;} else {pointOne=begin;}}
  else if (phase==1) {
    if (bool1) {
      pointTwo=LERP(begin, (t-0.25)*4, bottom);
      if (bool) {
      alt = pointTwo; 
      }
      else {
      PersonTwoALT = pointTwo;
      }
    }
    else {
      pointOne=LERP(begin, (t-0.25)*4, bottom1);
      if (bool) {
        alt = pointOne;
      }
    }
  } else if (phase==2) {
    if (bool1) {
      pt point = (bool)?alt:PersonTwoALT;
      point = LERP(LERP(point,0.065,P(bottom, S(.2,V(bottom1,bottom)))),0.01,target); 
      if (bool) {
      alt=point;
      } 
      else {
      PersonTwoALT=point;
      }
      pointTwo = point;
    } else {
      pt point = (bool)?alt:PersonTwoALT;
      point = LERP(LERP(point,0.065,P(bottom1, S(.2,V(bottom,bottom1)))),0.01,target);
        if (bool) {
        alt=point; 
        }
        else{
            PersonTwoALT=point;
          }  
      pointOne = point;
    }
  } 
  else {
    if (bool1) {
    pointTwo=LERP(LERP((bool)?alt:PersonTwoALT,(t-3.0/4),bottom), (t-0.75)*4, target);
    }
    else {
    pointOne=LERP(LERP((bool)?alt:PersonTwoALT,(t-3.0/4),bottom1), (t-0.75)*4, target);
    }
  }
  return new pointFunc(pointOne,pointTwo);
}

vec PersonDirection(boolean bool, pts path) {
  vec direction;
  if (phase<=1) {
    if(path.DirectionControl[path.previousPOINT(step)]==0) {direction = U(V(begin,weight));} 
    else if (!bool&&PathOne.DirectionControl[path.previousPOINT(step)]==1) {direction = R(U(V(weight,begin)));} 
    else if (bool&&path.DirectionControl[path.previousPOINT(step)]==1) {direction = R(U(V(begin,weight))); }
    else { direction = U(V(weight,begin));}
  } 
  else if (phase==2) { 
    vec pre = (path.DirectionControl[path.previousPOINT(step)]<2)? 
      ((path.DirectionControl[path.previousPOINT(step)]==0)?
        V(begin,weight):
        (bool)?
          R(V(begin,weight)):
          R(V(weight,begin))):
       V(weight,begin);
    if(path.DirectionControl[step]==0) {direction = U(L(pre,V(weight,target),(t-1.0/2)*4));} 
    else if (bool&&(path.DirectionControl[step]==1)) {direction = U(L(pre,R(V(target,weight)),(t-1.0/2)*4));} 
    else if (!bool&&(path.DirectionControl[step]==1)) {direction = U(L(pre,R(V(weight,target)),(t-1.0/2)*4));} 
    else { direction = U(L(pre,V(target,weight),(t-1.0/2)*4));}
  } 
  else { 
    if(path.DirectionControl[step]==0) {direction = U(V(weight,target));}
    else if (bool&&path.DirectionControl[step]==1) {direction = R(U(V(target,weight)));}
    else if (!bool&&path.DirectionControl[step]==1) {direction = R(U(V(weight,target)));}
    else {direction = U(V(target,weight));}
  }  
  return direction;
}

  
pt LERP(pt a, float t, pt b) {
  return P(a.x*(1-t)+b.x*t,a.y*(1-t)+b.y*t,a.z*(1-t)+b.z*t);
}