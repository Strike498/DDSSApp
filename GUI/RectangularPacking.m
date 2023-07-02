function [best,allocation] = RectangularPacking(box,packages)

N = size(packages,1);
flippedPackages = flip(packages,2);
options = logical([dec2bin(0:2^N-1)'-'0']');
pass = zeros(1,size(options,1));
nbox = pass;
boxid = ones(size(options,1),1);
for i = 1:size(options,1)
    newpackages = packages;
    newpackages(options(i,:),:) = flippedPackages(options(i,:),:);
    
    nboxes = 1;
    bins = box;
    packstatus = zeros(1,size(newpackages,1));
    packid = 1;
    while ~all(packstatus)
        search = 0;
        for j = 1:size(newpackages,1)
            for k = 1:size(bins,1)
                if newpackages(j,1)<=bins(k,1) && newpackages(j,2)<=bins(k,2) %Pack into box
                    topbin = [bins(k,1)-newpackages(j,1) bins(k,2)];
                    bottombin = [newpackages(j,1) bins(k,2)-newpackages(j,2)];
                    bins(k,:) = [];
                    bins = [bins;topbin;bottombin];
                    packstatus(j) = 1;
                    search = 1;
                    packid = packid+1;
                    break
                end
            end
            if j==size(newpackages,1) && any(~packstatus) && search == 1 %Create new box
                nboxes = nboxes+1;
                bins = [bins;box];
                boxid(i,1:size(boxid(i,boxid(i,:)>0),2)+1) = [boxid(i,boxid(i,:)>0),packid];
                newpackages = newpackages(~packstatus,:);
                packstatus = zeros(1,size(newpackages,1));
                
            elseif j==size(newpackages,1) && any(~packstatus) && search == 0 %All Packed
                packstatus = ones(1,size(newpackages,1));
            end
        end
    end
    pass(i) = search;
    nbox(i) = nboxes;
end

[best,idx] = min(nbox(logical(pass)));
allocation = boxid(logical(pass),:);
allocation = allocation(idx,:);

end