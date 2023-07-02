classdef Scenario < handle & matlab.mixin.SetGet
    %Scenario
    %   Detailed explanation goes here
    
    properties
        Project
        ID int32
        Name
        Type categorical
        Activities Activity
        Posets Activity
        PosetGraph
        Timeline int32
        Target ModuleGroup
        Sequence
        ResourceAssignment Vessel
        Campaigns Campaign
    end
    
    methods
        function obj = Scenario(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
                obj.ID = obj.Project.NID+1;
                obj.Project.NID =  obj.Project.NID+1;
                obj.Project.Objects{obj.ID} = obj;
            end
        end
    end
end
