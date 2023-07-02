function out = NodeGen(store)
id = size(store,2)+1;
imax = max(store);
list = store(2:end);
L = repmat(list',1,size(list,2));
M = L(reshape(~eye(size(L,1)),1,[]));
store = [store M];
ids = id;
idf = size(store,2);

for j = imax-1:-1:1
    plist = reshape(store(ids:idf),[],factorial(imax)/factorial(j))';
    for n = 1:size(plist,1)
        list = plist(n,:);
        L = repmat(list',1,size(list,2));
        M = L(reshape(~eye(size(L,1)),1,[]));
        store = [store M];
    end
    ids = idf+1;
    idf = size(store,2);
end

out = store;
end