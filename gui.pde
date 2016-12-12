void keyPressed() 
  {
  if(key=='`') picking=true; 
  if(key=='?') scribeText=!scribeText;
  if(key=='!') snapPicture();
  if(key=='~') filming=!filming;
  if(key=='i') showImproved=!showImproved;
  if(key==']') showBalls=!showBalls;
  if(key=='C') showCaplet=!showCaplet;
  if(key=='K') showCone=!showCone;;
  //if(key=='q') Q.copyFrom(P);
  //if(key=='p') P.copyFrom(Q);
  //if(key=='e') {PtQ.copyFrom(Q);Q.copyFrom(P);P.copyFrom(PtQ);}
  if(key=='c') center=!center; // snaps focus F to the selected vertex of P (easier to rotate and zoom while keeping it in center)
  if(key=='t') PickedFocus=true; // snaps focus F to the selected vertex of P (easier to rotate and zoom while keeping it in center)
  if(key=='x' || key=='z' || key=='d') PathOne.setPicked(); // picks the vertex of P that has closest projeciton to mouse
  if(key=='d') PathOne.deletePicked();
  if(key=='W') {PathOne.savePts("data/pts"); /*Q.savePts("data/pts2");*/}  // save vertices to pts2
  if(key=='L') {PathOne.loadPts("data/pts"); /*Q.loadPts("data/pts2");*/}   // loads saved model
  if(key=='w') PathOne.savePts("data/pts");   // save vertices to pts
  if(key=='l') PathOne.loadPts("data/pts"); 
  if(key=='a') animating=!animating; // toggle animation
  if(key==',') {if(showViewer) showViewer=false; else viewpoint=!viewpoint;}
  if(key=='#') exit();
  if(key=='b')solidBalls=!solidBalls;
  if(key=='=') {}
  if (key=='S') PathOne.savePts("data/pts");
  change=true;   // to save a frame for the movie when user pressed a key 
  }

void mouseWheel(MouseEvent event) 
  {
  dz -= event.getAmount(); 
  change=true;
  }

void mousePressed() 
  {
  if (!keyPressed) picking=true;
  if (!keyPressed) {PathOne.setPicked();}
  if(keyPressed&&key=='i') PathOne.insertClosestProjection(Of); // Inserts new vertex in P that is the closeset projection of O
  
  //added for path control
  //while pressing a, click on point, dancer will go forward
  //while pressing b, click on point, dancer will go backward
  
  if(keyPressed) {
   if (key=='a')  PathOne.PathControl(0);   
   if (key=='b')  PathOne.PathControl(2); 
  }
  change=true;
  }
  
void mouseMoved() 
  {
  if (keyPressed && key==' ') {rx-=PI*(mouseY-pmouseY)/height; ry+=PI*(mouseX-pmouseX)/width;};
  //if (keyPressed && key=='s') dz+=(float)(mouseY-pmouseY); // approach view (same as wheel)
  change=true;
  }
  
void mouseDragged() 
  {
  if (!keyPressed) PathOne.setPickedTo(Of); 
  //if (!keyPressed) {Of.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); }
  if (keyPressed && key==CODED && keyCode==SHIFT) {Of.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));};
  if (keyPressed && key=='x') PathOne.movePicked(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  //if (keyPressed && key=='z') PathOne.movePicked(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='X') PathOne.moveAll(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  //if (keyPressed && key=='Z') PathOne.moveAll(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='f')  // move focus point on plane
    {
    if(center) F.sub(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    else F.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
  if (keyPressed && key=='F')  // move focus point vertically
    {
    if(center) F.sub(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    else F.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
  change=true;
  }  

// **** Header, footer, help text on canvas
void displayHeader()  // Displays title and authors face on screen
    {
    scribeHeader(title,0); scribeHeaderRight(name); 
    fill(white); image(myFace, width-myFace.width/4.3,25,myFace.width/4.3,myFace.height/4.3); 
    }
void displayFooter()  // Displays help text at the bottom
    {
    scribeFooter(guide,1); 
    scribeFooter(menu,0); 
    }

String title ="Move Backward: click on point while pressing 'b'; Move Forward: click on point while pressing 'a'", 
       name ="Yining Zhang (Faye)",
       menu="?:help, !:picture, ~://(begin/stop)capture, space:rotate, s/wheel:closer, f/F:refocus, a:anim, #:quit",
       guide="Control Points x/z:s//elect&edit, e:exchange, q/p:copy, l/L:load, w/W:write, C/K:show caplet/cone"; // user's guide