function CalculatePoset(C,startIdx,endIdx,currIdx,CA,CB,OutS,iter,poset)  
    updIdx = startIdx-currIdx>0;
    startIdx = startIdx(updIdx);
    endIdx = endIdx(updIdx);
    CB = [CB currIdx];
    for j = 1:length(startIdx)
        check = find(CA(startIdx(j):endIdx(j)))+startIdx(j)-1;
        oldCA = CA;
        for k = check
            CA = [CA(1:k-1) and(CA(k:end),C(k,k:end))];
            CalculatePoset(C,startIdx,endIdx,k,CA,CB,OutS,iter,poset);
            CA = oldCA;
        end
    end
    if isempty(startIdx) && size(CB,2)==OutS
        CBA(iter,:) = CB
        iter = iter+1;
    end
end