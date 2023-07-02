clear all; close all; clc;
load('MillerCaseStudy1.mat')
load('MillerCaseStudy2.mat')
load('BrentCaseStudy1.mat')
load('BrentCaseStudy2.mat')

N = height(campTableB1);
zstring = 'Objective Function';

x1 = campTableB1.Num_Mod_Groups;
y1 = campTableB1.Num_Vessels;
z1 = campTableB1.Objective_Function;
X1 = [x1,y1,z1];

x2 = campTableB2.Num_Mod_Groups;
y2 = campTableB2.Num_Vessels;
z2 = campTableB2.Objective_Function;
X2 = [x2,y2,z2];

% -------------------------------------------------------------------------

X_ave=mean(X1,1);            % mean; line of best fit will pass through this point  
dX=bsxfun(@minus,X1,X_ave);  % residuals
C=(dX'*dX)/(N-1);           % variance-covariance matrix of X
[R,D]=svd(C,0);             % singular value decomposition of C; C=R*D*R'
% NOTES:
% 1) Direction of best fit line corresponds to R(:,1)
% 2) R(:,1) is the direction of maximum variances of dX 
% 3) D(1,1) is the variance of dX after projection on R(:,1)
% 4) Parametric equation of best fit line: L(t)=X_ave+t*R(:,1)', where t is a real number
% 5) Total variance of X = trace(D)
% Coefficient of determineation; R^2 = (explained variance)/(total variance)
D=diag(D);
R2=D(1)/sum(D);

% Visualize X and line of best fit
Sa = max([(max(x1) - X_ave(1))/R(1,1), (max(y1) - X_ave(2))/R(2,1), (max(z1) - X_ave(3))/R(3,1)]);
Sb = min([(min(x1) - X_ave(1))/R(1,1), (min(y1) - X_ave(2))/R(2,1), (min(z1) - X_ave(3))/R(3,1)]);

Xa=Sa*R(:,1)' + X_ave;
Xb=Sb*R(:,1)' + X_ave;
X_end1=[Xa;Xb];

F1 = scatteredInterpolant(x1,y1,z1,'nearest');
vq1 = F1(X_end1(:,1),X_end1(:,2));

% -------------------------------------------------------------------------
X_ave=mean(X2,1);            % mean; line of best fit will pass through this point  
dX=bsxfun(@minus,X2,X_ave);  % residuals
C=(dX'*dX)/(N-1);           % variance-covariance matrix of X
[R,D]=svd(C,0);             % singular value decomposition of C; C=R*D*R'

D=diag(D);
R2=D(1)/sum(D);

Sa = max([(max(x2) - X_ave(1))/R(1,1), (max(y2) - X_ave(2))/R(2,1), (max(z2) - X_ave(3))/R(3,1)]);
Sb = min([(min(x2) - X_ave(1))/R(1,1), (min(y2) - X_ave(2))/R(2,1), (min(z2) - X_ave(3))/R(3,1)]);

Xa=Sa*R(:,1)' + X_ave;
Xb=Sb*R(:,1)' + X_ave;
X_end2=[Xa;Xb];

F2 = scatteredInterpolant(x2,y2,z2,'nearest');
vq2 = F2(X_end2(:,1),X_end2(:,2));

MSE = sum((X_end1(:,1)-X_end2(:,1)).^2 + (X_end1(:,2)-X_end2(:,2)).^2 + (X_end1(:,2)-X_end2(:,2)).^2)/N;
RMSE = sqrt(MSE);

% -------------------------------------------------------------------------
subplot(3,1,1)
hold on
grid on
scatter(x1,z1,'b')
scatter(x2,z2,'r')
plot(X_end1(:,1),X_end1(:,3),'--b','LineWidth',2) % best fit line 
plot(X_end2(:,1),X_end2(:,3),'--r','LineWidth',2) % best fit line 

xlabel('Number of Module Groups')
ylabel(zstring)
legend('Sample Points 1','Sample Points 2','Principal Component 1','Principal Component 2','Nearest Interpolant 1','Nearest Interpolant 2','Location','southeast')

set(get(gca,'Title'),'String',sprintf('MSE = %.3f, RMSE = %.3f, Number of Samples = %d',MSE,RMSE,N))

subplot(3,1,2)
hold on
grid on
scatter(y1,z1,'b')
scatter(y2,z2,'r')
plot(X_end1(:,2),X_end1(:,3),'--b','LineWidth',2) % best fit line 
plot(X_end2(:,2),X_end2(:,3),'--r','LineWidth',2) % best fit line 

xlabel('Number of Vessels')
ylabel(zstring)
legend('Sample Points 1','Sample Points 2','Principal Component 1','Principal Component 2','Nearest Interpolant 1','Nearest Interpolant 2','Location','southeast')


subplot(3,1,3)
hold on
grid on
scatter3(x1,y1,z1,'b')
scatter3(x2,y2,z2,'r')
plot3(X_end1(:,1),X_end1(:,2),X_end1(:,3),'--b','LineWidth',2) % best fit line 
plot3(X_end2(:,1),X_end2(:,2),X_end2(:,3),'--r','LineWidth',2) % best fit line 

xlabel('Number of Module Groups')
ylabel('Number of Vessels')
zlabel(zstring)
legend('Sample Points 1','Sample Points 2','Principal Component 1','Principal Component 2')
view(-13,41)



% xr = min(x1):max(x1);
% yr = min(y1):max(y1);
% [xq1,yq1] = meshgrid(xr,yr);
% F1 = scatteredInterpolant(x1,y1,z1,'nearest');
% vqs1 = F1(xq1,yq1);

% plot3(X_end1(:,1),X_end1(:,2),vq1,'--b') %Interpolant
% plot3(X_end2(:,1),X_end2(:,2),vq2,'--r')

% mesh(xq1,yq1,vqs1,'EdgeColor','b')
% mesh(xq2,yq2,vqs2,'EdgeColor','r')
