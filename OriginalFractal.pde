class complex {
  double r;
  double i;
  public complex(double _r, double _i) {
    r=_r;
    i=_i;
  }
  complex a(complex b) {
    return new complex(r+b.r,i+b.i);
  }
  complex s(complex b) {
    return new complex(r-b.r,i-b.i);
  }
  complex m(complex b) {
    return new complex(r*b.r-i*b.i,r*b.i+i*b.r);
  }
  complex p(int n) {
    complex b = new complex(1,0);
    for (int i=0;i<n;i++) {
      b=b.m(this);
    }
    return b;
  }
  double d(complex b) {
    return Math.sqrt(sq((float)(r-b.r))+sq((float)(i-b.i)));
  }
}

int fractal(complex c) {
  int n=0;
  complex z = new complex(0,0);
  while (true) {
    z = z.p(2).a(c);
    if (z.d(new complex(0,0))>2) {
      return n;
    }
    n++;
    if (n>=it) {
      return -1;
    }
  }
}

int it=10;
int res=1;
color[] cols = new color[it];
int[][] screen;
double ox=0;
double oy=0;
double s=1;
int n;
int mode=0;
int f=0;
double targetS;
double targetOX;
double targetOY;
double totalF;
double targetIT;

void setup() {
  size(800,800);
  for (int i=0; i<cols.length; i++) {
    cols[i] = color((int)(Math.random()*255), (int)(Math.random()*255), (int)(Math.random()*255));
  }
  screen = new int[width][height];
}

void draw() {
  if (mode==0) {
    noStroke();
    for (int y=0;y<height;y+=res) {
      for (int x=0;x<width;x+=res) {
        double px = ((double)x/width)-0.5;
        double py = ((double)y/width)-0.5;
        n = fractal(new complex(px*4/s+ox/s,py*4/s+oy/s));
        screen[x][y] = n;
      }
    }
    display(screen);
    noLoop();
  } else if (mode==1) {
    if (s>targetS) {
      mode=0;
    } else {
      background(0);
      f++;
      s*=1.1;
      ox=targetOX*s/targetS;
      oy=targetOY*s/targetS;
      res=3;
      it=(int)(10+(targetIT-10)*(f/totalF));
      for (int y=0;y<height;y+=res) {
        for (int x=0;x<width;x+=res) {
          double px = ((double)x/width)-0.5;
          double py = ((double)y/width)-0.5;
          n = fractal(new complex(px*4/s+ox/s,py*4/s+oy/s));
          screen[x][y] = n;
        }
      }
      display(screen);
    }
  }
}

//1, 2, 3, base case, 3, 2, 1,
//b
//h
//z
//indexoutofboundserror

//yaks
//4
//7
//5

void display(int[][] _screen) {
  for (int y=0;y<_screen.length;y+=res) {
    for (int x=0;x<_screen[y].length;x+=res) {
      n = _screen[x][y];
      if (n==-1) {
        fill(0);
      } else {
        fill(cols[Math.min(cols.length-1,n)]);
      }
      rect((float)(x),(float)(y),(float)res,(float)res);
    }
  }
}

void keyPressed() {
  double p=2;
  double d = 0.2;
  boolean shouldRedraw = true;
  if (keyCode==38&&mode==0) {
    s*=p;
    ox*=p;
    oy*=p;
  } else if (keyCode==40&&mode==0) {
    s/=p;
    ox/=p;
    oy/=p;
  } else if (key=='w'&&mode==0) oy-=d;
  else if (key=='s'&&mode==0) oy+=d;
  else if (key=='a'&&mode==0) ox-=d;
  else if (key=='d'&&mode==0) ox+=d;
  else if (keyCode==39&&mode==0) {
    it++;
    addColor();
  } else if (keyCode==37&&mode==0) it--;
  else if (key=='t'&&res>1) res--;
  else if (key=='g') res++;
  else if (key==' '&&mode==0) {
    mode=1;
    targetS=s;
    targetOX=ox;
    targetOY=oy;
    totalF=Math.log(targetS)/Math.log(1.1);
    targetIT=it;
    s=1;
    f=0;
    addColor(); //just for safety. not sure if this is required but I want to make sure there are enough colors.
    loop();
  } else shouldRedraw = false;
  if (shouldRedraw) redraw();
}

void addColor() {
  color[] newCols = new color[it];
  for (int i=0;i<newCols.length-1;i++) {
    newCols[i]=cols[i];
  }
  newCols[newCols.length-1]=color((int)(Math.random()*255), (int)(Math.random()*255), (int)(Math.random()*255));
  cols=newCols;
}
