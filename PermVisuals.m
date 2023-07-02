[POPList,NPOPerm] = POPerms(Projects.Scenarios(1, 20).PosetGraph);

p = uint32(perms(1:10));
p = p(p(:,1) == 1,:);
p = p(p(:,10) == 10,:);

PF1 = FindPFList(p);
x1 = 1:size(PF1,2);
PF2 = FindPFList(POPList);
x2 = 1:size(PF2,2);

PF1 = sort(PF1);
PF2 = sort(PF2);
hit = ismember(PF1,PF2);
x2 = find(hit);

for i = 1:size(PF2,2)
    x2(i) = find(PF1==PF2(i));
end


semilogy(x1,PF1,'bo')
hold on
semilogy(x2,PF2,'go')
grid on

loglog(x1,PF1,'bo')
hold on
loglog(x2,PF2,'ro')
grid on

plot(x1,PF1,'bo')
hold on
plot(x2,PF2,'gx')
grid on
