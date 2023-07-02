function out = RandPOPerm(Poset,Gene)
n = max(Poset,[],'All');
Available = 1:n;
Sequence = uint32(zeros(1,n));

% Gene = rand(1,n);

for i = 1:n
Candidates = setdiff(Available,Poset(:,2));
GeneSelect = ceil(Gene(i)*numel(Candidates));
Selection = Candidates(GeneSelect);
Sequence(i) = Selection;
Available = setdiff(Available,Selection);
Poset = Poset(Poset(:,1)~=Selection,:);
end
out = Sequence;

end