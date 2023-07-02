function hobj = deck(LoA,Beam,Depth)
L = Beam; %Beam
W = LoA*2/3; %LoA
H = Depth;
ph = pi/4;
a = [-pi: pi/2 : pi];

x = [1;1.5].*(L/2).*[cos(a+ph); cos(a+ph)]/cos(ph);
y = [1.4;1.5].*(W/2).*[sin(a+ph); sin(a+ph)]/sin(ph);
z = (H/2)*[-ones(size(a)); ones(size(a))];

x = L/(max(x,[],'all')-min(x,[],'all')).*x;
y = W/(max(y,[],'all')-min(y,[],'all')).*y;

y = y+[(W-(max(y(1,:),[],'all')-min(y(1,:),[],'all')))/2;0]-W/2;
x(2,:) = 0.8.*x(2,:);
x(2,:) = x(1,:)+(x(2,:)-x(1,:))/2;
z(2,:) = z(1,:)+(z(2,:)-z(1,:))/2;
surf(x, y, z,'FaceColor','r','EdgeColor','k');
hold on
patch(x',y',z','r')


x = [x(2,:);x(2,:)];
y = [y(2,:);y(2,:)];
z = [z(2,:);z(2,:)+H/10];

surf(x, y, z,'FaceColor',[0.5 0.5 0.5],'EdgeColor','k');
hold on
patch(x',y',z',[0.5 0.5 0.5])

axis vis3d
axis equal
hobj = [];
end

