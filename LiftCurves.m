clear; clc; close all;
min_lift_rad = 34;
max_lift_rad = 110;
max_load_cap = 7000;
min_load_cap = 500;
max_rad_max_load = 40;
min_lift_height = 38;
max_lift_height = 110;

min_lift_rad2 = 39;
max_lift_rad2 = 130;
max_load_cap2 = 2500;
min_load_cap2 = 400;
max_rad_max_load2 = 70;
min_lift_height2 = 41;
max_lift_height2 = 130;

min_lift_rad3 = 43;
max_lift_rad3 = 140;
max_load_cap3 = 900;
min_load_cap3 = 300;
max_rad_max_load3 = 115;
min_lift_height3 = 46;
max_lift_height3 = 140;

min_lift_rad4 = 48;
max_lift_rad4 = 150;
max_load_cap4 = 100;
min_load_cap4 = 100;
max_rad_max_load4 = 150;
min_lift_height4 = 43;
max_lift_height4 = 148;


x = min_lift_rad:1:max_lift_rad;
h = sqrt(max_lift_rad^2+min_lift_height^2);
y = sqrt(h^2-x.^2);

plot(x,y,'b--')
hold on
x_2 = min_lift_rad2:1:max_lift_rad2;
h_2 = sqrt(max_lift_rad2^2+min_lift_height2^2);
y_2 = sqrt(h_2^2-x_2.^2);
plot(x_2,y_2,'r--')

x_3 = min_lift_rad3:1:max_lift_rad3;
h_3 = sqrt(max_lift_rad3^2+min_lift_height3^2);
y_3 = sqrt(h_3^2-x_3.^2);
plot(x_3,y_3,'g--')

x_4 = min_lift_rad4:1:max_lift_rad4;
h_4 = sqrt(max_lift_rad4^2+min_lift_height4^2);
y_4 = sqrt(h_4^2-x_4.^2);
plot(x_4,y_4,'m--')

xlim([34 150])
ylim([0 160])
grid on
grid minor

z = ((sin(1/(min_load_cap))-sin(1/max_load_cap))/(max_lift_rad-max_rad_max_load)).*x + (sin(1/max_load_cap) - max_rad_max_load*(sin(1/min_load_cap)-sin(1/max_load_cap))/(max_lift_rad-max_rad_max_load));
y2 = 1./(asin(z));
z3 = ((sin(1/min_load_cap)-sin(1/max_load_cap))/((max_lift_rad-max_rad_max_load)^2)).*((x-max_rad_max_load).^2)+sin(1/max_load_cap);
y3 = 1./(asin(z3));

y2(x<=max_rad_max_load) = max_load_cap;
y3(x<=max_rad_max_load) = max_load_cap;
y4 = y2+(1+log(2)).*((y3-y2)/2);

z_2 = ((sin(1/(min_load_cap2))-sin(1/max_load_cap2))/(max_lift_rad2-max_rad_max_load2)).*x_2 + (sin(1/max_load_cap2) - max_rad_max_load2*(sin(1/min_load_cap2)-sin(1/max_load_cap2))/(max_lift_rad2-max_rad_max_load2));
y2_2 = 1./(asin(z_2));
z3_2 = ((sin(1/min_load_cap2)-sin(1/max_load_cap2))/((max_lift_rad2-max_rad_max_load2)^2)).*((x_2-max_rad_max_load2).^2)+sin(1/max_load_cap2);
y3_2 = 1./(asin(z3_2));

y2_2(x_2<=max_rad_max_load2) = max_load_cap2;
y3_2(x_2<=max_rad_max_load2) = max_load_cap2;
y4_2 = y2_2+(1+log(2)).*((y3_2-y2_2)/2);

z3_3 = ((sin(1/min_load_cap3)-sin(1/max_load_cap3))/((max_lift_rad3-max_rad_max_load3)^2)).*((x_3-max_rad_max_load3).^2)+sin(1/max_load_cap3);
y3_3 = 1./(asin(z3_3));
y3_3(x_3<=max_rad_max_load3) = max_load_cap3;

z3_4 = ((sin(1/min_load_cap4)-sin(1/max_load_cap4))/((max_lift_rad4-max_rad_max_load4)^2)).*((x_4-max_rad_max_load4).^2)+sin(1/max_load_cap4);
y3_4 = 1./(asin(z3_4));
y3_4(x_4<=max_rad_max_load4) = max_load_cap4;

xlabel('Lifting Radius from Centre Line of Crane [m]')
ylabel('Height Above Upperdeck [m]')
yyaxis right
ylabel('Load Capacity [t]')

    
% plot(x,y2)
 hold on
plot(x,y3,'b-')
% plot(x,y4)
ylim([0 8000])

% plot(x_2,y2_2)
plot(x_2,y3_2,'r-')
% plot(x_2,y4_2)

plot(x_3,y3_3,'g-')

plot(x_4,y3_4,'m-')

legend({'Main Hook Radius',...
    '1st Aux Hook Radius',...
    '2nd Aux Hook Radius',...
    'Whip Hook Radius',...
    'Main Hook Load Capacity',...
    '1st Aux Hook Load Capacity',...
    '2nd Aux Hook Load Capacity',...
    'Whip Hook Load Capacity'})
    
    
