function hobj = bow(LoA,Beam,Depth)
L = Beam; %Beam
W = LoA*1/3; %LoA
H = Depth;
ph = pi/20;
a = [-ph: ph : pi-ph, -ph];
x = [1;1.5].*(L/2).*[cos(a+ph); cos(a+ph)]/cos(ph);
y = [1;1.5].*(W/2).*[sin(a+ph); sin(a+ph)]/sin(ph);
z = (H/2)*[-ones(size(a)); ones(size(a))];

x = L/(max(x,[],'all')-min(x,[],'all')).*x;
x(2,:) = 0.8.*x(2,:);
y = W/(max(y,[],'all')-min(y,[],'all')).*y;
surf(x, y, z,'FaceColor','r','EdgeColor','k');
hold on
patch(x',y',z','r')

ph = pi/4;
a = [-ph: ph : pi-ph, -ph];
x = [1.1;1].*(L/2).*[cos(a+ph); cos(a+ph)]/cos(ph);
y = [1.1;1].*(W/2).*[sin(a+ph); sin(a+ph)]/sin(ph);
z = (H/4)*[-ones(size(a)); ones(size(a))]+H/2+H/4;

x = L/(max(x,[],'all')-min(x,[],'all')).*0.8*x;
y = W/(max(y,[],'all')-min(y,[],'all')).*2/3*y;

surf(x, y, z,'FaceColor','w','EdgeColor','k');
patch(x',y',z','w')

zoff = max(z,[],'all')-min(z,[],'all');
ph = pi/5;
a = [-2*ph: ph : pi, -2*ph];

x = [1;1/3].*(L/2).*[cos(a+ph); cos(a+ph)]/cos(ph);
y = [1;1/3].*(W/2).*[sin(a+ph); sin(a+ph)]/sin(ph);
z = (H/3)*[-ones(size(a)); ones(size(a))]+H/2+H/3+zoff;

x = L/(max(x,[],'all')-min(x,[],'all')).*1/2*x;
y = W/(max(y,[],'all')-min(y,[],'all')).*1/4*y;

yoff = [(max(y(1,:),[],'all')-min(y(1,:),[],'all'))/2;2*(max(y(1,:),[],'all')-min(y(1,:),[],'all'))/4];
y = y+yoff;

x3 = x(1,:).*1.2;
y3 = y(1,:).*1.2;
z3 = z(1,:)+(max(z,[],'all')-min(z,[],'all'))*3/4;

x = [x(1,:);x3;x3];
y = [y(1,:);y3;y3];
z = [z(1,:);0.9.*z3;z3];


surf(x, y, z,'FaceColor','w','EdgeColor','k');
patch(x',y',z','w')

zoff = max(z,[],'all');
ph = pi;
a = [-pi: pi/2 : pi]+pi/4;
x = [1;1].*(L/2).*[cos(a+ph); cos(a+ph)]/cos(ph);
y = [1;1].*(W/2).*[sin(a+ph); sin(a+ph)]/sin(ph);
z = [zoff;zoff+H/6].*ones(2,size(a,2));

x = L/(max(x,[],'all')-min(x,[],'all')).*1/3*x;
y = W/(max(y,[],'all')-min(y,[],'all')).*1/12*y+W/8;

surf(x, y, z,'FaceColor',[0.5 0.5 0.5],'EdgeColor','k');
patch(x',y',z','k')

zoff = max(z,[],'all');
ph = pi;
a = [-pi: pi/12 : pi];
x = [1.5;1].*(L/2).*[cos(a+ph); cos(a+ph)]/cos(ph);
y = [1.5;1].*(W/2).*[sin(a+ph); sin(a+ph)]/sin(ph);
z = [zoff;zoff+H/6].*ones(2,size(a,2));

x = W/(max(x,[],'all')-min(x,[],'all')).*x/16;
y = W/(max(y,[],'all')-min(y,[],'all')).*y/16+W/8;

surf(x, y, z,'FaceColor',[0.5 0.5 0.5],'EdgeColor','k');
patch(x',y',z','k')

zoff = max(z,[],'all');
ph = pi;
a = [-pi: pi/2 : pi]+pi/4;
x = [1;1].*(L/2).*[cos(a+ph); cos(a+ph)]/cos(ph);
y = [1;1].*(W/2).*[sin(a+ph); sin(a+ph)]/sin(ph);
z = [zoff;zoff+H/8].*ones(2,size(a,2));

x = L/(max(x,[],'all')-min(x,[],'all')).*1/4*x;
y = W/(max(y,[],'all')-min(y,[],'all')).*1/50*y+W/8;

surf(x, y, z,'FaceColor',[0.5 0.5 0.5],'EdgeColor','k');
patch(x',y',z','k')

ph = pi;
a = [-pi: pi/6 : pi];
x = [1;0.3].*(L/2).*[cos(a+ph); cos(a+ph)]/cos(ph);
y = [1;0.3].*(W/2).*[sin(a+ph); sin(a+ph)]/sin(ph);
z = [zoff;zoff+H].*ones(2,size(a,2));

x = W/(max(x,[],'all')-min(x,[],'all')).*x/32;
y = W/(max(y,[],'all')-min(y,[],'all')).*y/32+W/8;

surf(x, y, z,'FaceColor',[0.5 0.5 0.5],'EdgeColor','k');
patch(x',y',z','k')

zoff = zoff+H/4;
ph = pi;
a = [-pi: pi/2 : pi]+pi/4;
x = [1;1].*(L/2).*[cos(a+ph); cos(a+ph)]/cos(ph);
y = [1;1].*(W/2).*[sin(a+ph); sin(a+ph)]/sin(ph);
z = [zoff;zoff+H/16].*ones(2,size(a,2));

x = L/(max(x,[],'all')-min(x,[],'all')).*1/8*x;
y = W/(max(y,[],'all')-min(y,[],'all')).*1/64*y+W/8;

surf(x, y, z,'FaceColor',[0.5 0.5 0.5],'EdgeColor','k');
patch(x',y',z','k')

zoff = zoff+H/4;
ph = pi;
a = [-pi: pi/2 : pi]+pi/4;
x = [1;1].*(L/2).*[cos(a+ph); cos(a+ph)]/cos(ph);
y = [1;1].*(W/2).*[sin(a+ph); sin(a+ph)]/sin(ph);
z = [zoff;zoff+H/16].*ones(2,size(a,2));

x = L/(max(x,[],'all')-min(x,[],'all')).*1/6*x;
y = W/(max(y,[],'all')-min(y,[],'all')).*1/64*y+W/8;

surf(x, y, z,'FaceColor',[0.5 0.5 0.5],'EdgeColor','k');
patch(x',y',z','k')

axis vis3d
axis equal
hobj = [];
end
