function Out = FindAllEnds(Available,Candidates,Poset,iter,Sequence)
iter = iter+1;
Out = [];
if ~isempty(Available)
    for i = 1:length(Candidates)
        S = Candidates(i);
        A = setdiff(Available,S);
        P = Poset(Poset(:,1)~=S,:);
        C = setdiff(A,P(:,2));
        Seq = Sequence;
        Seq(iter) = S;
        O = FindAllEnds(A,C,P,iter,Seq);
        Out = [Out; O];
    end
else
    Out = Sequence;
end
end