function out = FindPFList(List)
for i = 1:size(List)
    k1 = double(List(i,1));
    for j = 2:size(List,2)
        PF(i) = CPF(k1,double(List(i,j)));
        k1 = PF(i);
    end
end
out = PF;
end