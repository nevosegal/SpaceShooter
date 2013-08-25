class Bullet
{
  float x, 
  y, 
  speed;
  int w, 
  h;
  color col;

  Bullet(float _x, float _y, int _speed, color _color, int _w, int _h)
  {
    x=_x;
    y=_y;
    speed = _speed;
    col=_color;
    w=_w;
    h=_h;
  }

  void display()
  {
    fill(col, 180);
    rect(x, y, w, h, 5);
  }

  void move()
  {
    x += speed;
  }
}

