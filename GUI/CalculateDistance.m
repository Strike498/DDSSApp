function D = CalculateDistance(start,finish)
load('Europe.mat')
% tic
ds = zeros(length(Vlat),1);
df = zeros(length(Vlat),1);

for i = 1:length(Vlat)
        ds(i,1) = abs(Vlat(i)-start(1));
        ds(i,2) = abs(Vlon(i)-start(2));
        df(i,1) = abs(Vlat(i)-finish(1));
        df(i,2) = abs(Vlon(i)-finish(2));
end
[~, dinds] = min(sum(ds,2));
[~, dindf] = min(sum(df,2));

% for i = 1:length(Vlat)
%         ds(i) = pi/360*2*6371.009*acosd(sind(start(1))*sind(Vlat(i))+cosd(start(1))*cosd(Vlat(i))*cosd(abs(Vlon(i)-start(2))));
%         df(i) = pi/360*2*6371.009*acosd(sind(finish(1))*sind(Vlat(i))+cosd(finish(1))*cosd(Vlat(i))*cosd(abs(Vlon(i)-finish(2))));
% end
% [~, dinds] = min(ds);
% [~, dindf] = min(df);

Ids = find(yqi==Vlat(dinds)&xqi==Vlon(dinds));
Idf = find(yqi==Vlat(dindf)&xqi==Vlon(dindf));

[path,D] = shortestpath(G,Ids,Idf);

Ds = pi/360*2*6371.009*acosd(sind(start(1))*sind(Vlat(dinds))+cosd(start(1))*cosd(Vlat(dinds))*cosd(abs(start(2)-Vlon(dinds))));
Df = pi/360*2*6371.009*acosd(sind(finish(1))*sind(Vlat(dindf))+cosd(finish(1))*cosd(Vlat(dindf))*cosd(abs(Vlon(dindf)-finish(2))));
% atand(sqrt((cosd(Vlat(dinds))*sind(abs(start(2)-Vlon(dinds))))^2 + (cosd(start(1))*sind(Vlat(dinds)) - sind(start(1))*cosd(Vlat(dinds))*cosd(abs(start(2)-Vlon(dinds))))^2 )/(sind(start(1))*sind(Vlat(dinds))+cosd(start(1))*cosd(Vlat(dinds))*cosd(abs(start(2)-Vlon(dinds)))))
D = D+Ds+Df;
% toc
end