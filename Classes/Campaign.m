classdef Campaign < handle & matlab.mixin.SetGet
    %Campaign
    %   Detailed explanation goes here
    
    properties
        Project
        ID int32
        CID int32
        Type categorical
        Activities Activity
        Posets Activity
        PosetGraph
        Timeline int32
        Target ModuleGroup
        Sequence
        ResourceAssignment Vessel
        Time
        WorkTime
        Cost
        CO2
        NOx
        SOx
        PM
        CH4
        Gap
        Gap_Act
        RGap
        RGap_Act
        FuelConsumption
    end
    
    methods
        function obj = Campaign(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
                obj.ID = obj.Project.NID+1;
                obj.CID = length(obj.Project.Campaigns)+1;
                obj.Project.NID =  obj.Project.NID+1;
                obj.Project.Objects{obj.ID} = obj;
            end
        end
    end
end