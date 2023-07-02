classdef Site < handle & matlab.mixin.SetGet
    %Site
    %   Detailed explanation goes here
    
    properties
        Project
        ID int32
        Name 
        Type categorical
        Latitude
        Longitude
        WaterDepth
        Selected logical = false
    end
    
    methods
        function obj = Site(varargin)
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
