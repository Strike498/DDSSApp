classdef Module < Unit
    % Module
    %   Detailed explanation goes here
    
    properties
        Project
        ID int32
        Name string
        Type categorical
        Mass double
        Length double
        Width double
        Height double
        Closeness
        Order
        Neighbours
        Include logical = 1
        Color double
        Parent
        Timeline int32
        Activity int32
        Site
        Connection
        Depth
        Origin double = [0,0,0]
        GraphicObj
        GraphicShape categorical = categorical("Cuboid")
        Children
        Destination
    end
    
    methods
        function obj = Module(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
                obj.ID = obj.Project.NID+1;
                obj.Project.NID =  obj.Project.NID+1;
                obj.Project.Objects{obj.ID} = obj;
            end
        end
        
        function out = depthSort(obj)
            [~,idx] = sort([obj.Depth]);
            out = obj(idx);
        end
    end
end