clear; close all; %clc; 
Length = 106.5;
Width = 55.5;
Height = 144.65;
Mass = 28732;
Origin = [-3.11250000000000,-2.06666666666667,165.060833333333];
CoG = [-3.35519455659195,-2.23983711541139,146.485848009188];
LiftPoints = [10.6448054434080,11.7601628845886,163.940000000000;...
    -17.3551945565920,11.7601628845886,163.940000000000;...
    -17.3551945565920,-16.2398371154114,163.590000000000;...
    10.6448054434080,-16.2398371154114,163.590000000000];
plot(LiftPoints(1,1),LiftPoints(1,2),'bo')
hold on
plot(LiftPoints(2,1),LiftPoints(2,2),'ro')
plot(LiftPoints(3,1),LiftPoints(3,2),'go')
plot(LiftPoints(4,1),LiftPoints(4,2),'mo')
b = max(LiftPoints(:,1))-min(LiftPoints(:,1));
b1 = abs(CoG(1)-LiftPoints(1,1));
b2 = abs(LiftPoints(2,1)-CoG(1));
b3 = abs(CoG(1)-LiftPoints(3,1));
b4 = abs(LiftPoints(4,1)-CoG(1));
h = max(LiftPoints(:,2))-min(LiftPoints(:,2));
h1 = abs(CoG(2)-LiftPoints(1,2));
h2 = abs(LiftPoints(2,2)-CoG(2));
h3 = abs(CoG(2)-LiftPoints(3,2));
h4 = abs(LiftPoints(4,2)-CoG(2));



WA = Mass*(h2/h)*(b2/b);
WB = Mass*(b1/b)*(h2/h);
WC = Mass*(h1/h)*(b1/b);
WD = Mass*(b2/b)*(h1/h);

idx = 0;
x = 1:1:101;
for i = x
    idx = idx+1;
    H = max(LiftPoints(:,3)) + i;
    H1 = H-LiftPoints(1,3);
    H2 = H-LiftPoints(2,3);
    H3 = H-LiftPoints(3,3);
    H4 = H-LiftPoints(4,3);
    theta1(idx) = atan(H1/sqrt((Length/2)^2 + (Width/2)^2));
    theta2(idx) = atan(H2/sqrt((Length/2)^2 + (Width/2)^2));
    theta3(idx) = atan(H3/sqrt((Length/2)^2 + (Width/2)^2));
    theta4(idx) = atan(H4/sqrt((Length/2)^2 + (Width/2)^2));
    Fs1(idx) = abs(WA/(sin(theta1(idx))));
    Fs2(idx) = abs(WD/(sin(theta2(idx))));
    Fs3(idx) = abs(WC/(sin(theta3(idx))));
    Fs4(idx) = abs(WB/(sin(theta4(idx))));
    Favg(idx) = mean([Fs1(idx) Fs2(idx) Fs3(idx) Fs4(idx)]);

end
Ftot = (Fs1+Fs2+Fs3+Fs4);
Ftot(end)
figure
semilogy(x,Fs1,'b-')
hold on
semilogy(x,Fs2,'ro')
semilogy(x,Fs3,'g-')
semilogy(x,Fs4,'mo')
semilogy(x,Favg,'k--')
semilogy(x,Ftot,'k-')
xlabel('Lift Angle [degrees]')
ylabel('Force Applied [N]')
grid on
grid minor
% [(Fs1+Fs2+Fs3+Fs4)/Mass;rad2deg(theta1);rad2deg(theta2);rad2deg(theta3);rad2deg(theta4)]'
