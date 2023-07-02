classdef Project < handle & matlab.mixin.SetGet
    %   Detailed explanation goes here
    
    properties
        NID int32 = 0
        SaveLocation
        Objects
        Name string
        Location
        Units
        Connections Connection
        ModuleGroups ModuleGroup
        Vessels Vessel
        Ports Port
        Activities Activity
        Scenarios Scenario
        Sites Site
        Campaigns Campaign
        ResourceAssignments ResourceAssignment
        GraphicChain = []
        transportMap
        campaignMap
        GeoMap
    end
    
    methods
        function obj = Project(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
            end
        end
    end
end