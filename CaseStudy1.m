clear all; close all; clc;
load('MillerCaseStudy1.mat')
load('MillerCaseStudy2.mat')
load('BrentCaseStudy1.mat')
load('BrentCaseStudy2.mat')

npoints = 102;

x = campTableB1.Num_Mod_Groups;
y = campTableB1.Num_Vessels;
z = campTableB1.Objective_Function;

% %Plane Fit
% B = [x(:) y(:) ones(size(x(:)))] \ z(:);                    % Linear Parameters
% z_fit = [x(:) y(:) ones(size(x(:)))] * B;                   % Fitted ‘z’

x1 = min(x):max(x);
y1 = min(y):max(y);
z1 = linspace(min(z),max(z),npoints);

[xq1,yq1] = meshgrid(x1,y1);
F1 = scatteredInterpolant(x,y,z);
%vq1 = F1(x1,y1);
vq1 = F1(xq1,yq1);
pairs = [x y];
for i = 1:length(x1)
    for j = 1:length(y1)
        spread = pairs(pairs(:,1)==i,:);
    end
end
surf(xq1,yq1,vq1)


scatter3(x,y,z,'b')
hold on

x = campTableB2.Num_Mod_Groups;
y = campTableB2.Num_Vessels;
z = campTableB2.Objective_Function;

x2 = linspace(min(x),max(x),npoints);
y2 = linspace(min(y),max(y),npoints);
z2 = linspace(min(z),max(z),npoints);

[xq2,yq2] = meshgrid(x2,y2);
F2 = scatteredInterpolant(x,y,z);
vq2 = F2(x2,y2);

scatter3(x,y,z,'r')
scatter3(x1,y1,vq1,'b','filled')
scatter3(x2,y2,vq2,'r','filled')

xlabel('Number of Module Groups')
ylabel('Number of Vessels')
zlabel('Objective Function')
legend('Sample Points 1','Sample Points 2','Trend 1','Trend 2')
view(-13,41)

MSE = sum((x1-x2).^2 + (y1-y2).^2 + (vq1-vq2).^2)/npoints
RMSE = sqrt(MSE)




