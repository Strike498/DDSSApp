function n = Perm2n(p)
N = length(p);
f = zeros(1,N);
count = 1;
while numel(p)>0
i = find(min(p)==p);
f(count) = i-1;
p(i) = [];
count = count+1;
end

n = sum(factorial(N-1:-1:0).*f)+1;
end