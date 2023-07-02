function F = FindFactoradic(n)
search = true;
i = 0;
N = n;
R = [];
while search
    i = i+1;
    R(i) = mod(N,i);
    N = floor(N/i);
    if N == 0
        F = flip(R);
        search = false;
    end
end
end