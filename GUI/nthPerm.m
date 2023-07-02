function p = nthPerm(list,n)
p = zeros(1,length(list))
F = zeros(1,length(list))
f = FindFactoradic(n-1)
F(end-length(f)+1:end) = f
pool = list
for i = 1:length(F)
    p(i) = pool(F(i)+1)
    pool(F(i)+1)=[]
end

end