function circle(x,y,h,MATB_DATA)
r=1.5;
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h(1).XData=xunit; h(1).YData=yunit;
h(2).XData=x; h(2).YData=y;

h(3).XData=[x x]; h(3).YData=[y+1.5 y+0.5];
h(4).XData=[x x]; h(4).YData=[y-1.5 y-0.5];
h(5).XData=[x+1.5 x+0.5]; h(5).YData=[y y];
h(6).XData=[x-1.5 x-0.5]; h(6).YData=[y y];
