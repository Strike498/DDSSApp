function [x, y] = rotateP(v,deg,center)
x = v(1,:);
y = v(2,:);
center = repmat(center,1,length(x));
theta = deg*pi/180;
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
s = v - center;     
so = R*s;           
vo = so + center;
x = double(vo(1,:));
y = double(vo(2,:));

end