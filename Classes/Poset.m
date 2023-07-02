classdef Poset < handle & matlab.mixin.SetGet
    %Poset
    %   Detailed explanation goes here
    
    properties
        Value
        Iter = 1
    end
    
    methods
        function obj = Poset(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
                obj.ID = obj.Project.NID+1;
                obj.Project.NID =  obj.Project.NID+1;
                obj.Project.Objects{obj.ID} = obj;
            end
        end
        function obj = CalculatePosets(C,startIdx,endIdx,currIdx,CA,CB,OutS,obj)
            updIdx = startIdx-currIdx>0;
            startIdx = startIdx(updIdx);
            endIdx = endIdx(updIdx);
            CB = [CB currIdx];
            for j = 1:length(startIdx)
                check = find(CA(startIdx(j):endIdx(j)))+startIdx(j)-1;
                oldCA = CA;
                for k = check
                    CA = [CA(1:k-1) and(CA(k:end),C(k,k:end))];
                    CalculatePosets(C,startIdx,endIdx,k,CA,CB,OutS,obj);
                    CA = oldCA;
                end
            end
            if isempty(startIdx) && size(CB,2)==OutS
                obj.Value(obj.Iter,:) = CB;
                obj.Iter = obj.Iter+1;
            end
        end
    end
end

