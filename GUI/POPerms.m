function [Out,NPOPerm] = POPerms(Poset)
n = max(Poset,[],'All');
Available = 1:n;
Sequence = uint32(zeros(1,n));
Candidates = setdiff(Available,Poset(:,2));
Selection = Candidates(1);
Available = setdiff(Available,Selection);
Poset = Poset(Poset(:,1)~=Selection,:);
Out = FindAllEnds(Available,Candidates,Poset,0,Sequence);
NPOPerm = size(Out,1);
end
