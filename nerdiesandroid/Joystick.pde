//joystick for throttle and yaw
void Joystick() { 
  pushStyle();
  background(51);
  noStroke(); 
  smooth();
  ellipseMode(RADIUS);
  rectMode(CORNERS);
  if(mousePressed && (mouseY > edge) && (mouseY < (height-edge)) && (mouseX > edge) && (mouseX < (width-edge)))
  {
    mx = mouseX;
    my = mouseY;
  }
    mx = constrain(mx, inner, width - inner);
    yaw = 255*(mx - edge) / (width - 2 * edge);
    my = constrain(my, inner, height - inner);
    throttle = 255 - (255*(my - edge) / (height - 2 * edge));
    fill(76);
    rect(edge, edge, width-edge, height-edge);
    fill(255);  
    ellipse(mx, my, radius, radius);
    
  popStyle();
}
