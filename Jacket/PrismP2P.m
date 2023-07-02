function out = PrismP2P(ax,sides,R,start,final)

vector = final-start;
magnitude = norm(vector);

a = linspace(0, 2*pi, sides+1);
x = [R; R]*cos(a)+start(1);
y = [R; R]*sin(a)+start(2);
z = [ones(1,size(x,2)).*start(3); ones(1,size(x,2)).*magnitude+start(3)];

up = [0 0 magnitude];
rot = vrrotvec2(up,vector);


% gca;
out(1) = surf(ax,x, y, z,'FaceColor',[0.9 0.6 0.2],'EdgeColor','none');
hold(ax,'on')
out(2) = patch(ax,x',y',z',[0.9 0.6 0.2]);
rotate(out,rot(1:3),rad2deg(rot(4)),start);
end
