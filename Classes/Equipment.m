classdef Equipment < handle & matlab.mixin.SetGet
    %Equipment
    %   Detailed explanation goes here
    
    properties
        Project
        ID int32
        Name string
        Type categorical
        
    end
    
    methods
        function obj = Equipment(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
                obj.ID = obj.Project.NID+1;
                obj.Project.NID =  obj.Project.NID+1;
                obj.Project.Objects{obj.ID} = obj;
                switch obj.Type
                    case "Abrasive Water Jet"
                        obj.Mass = 50;
                        obj.Length = 11;
                        obj.Width = 11;
                        obj.Height = 3;
                    case "Oxygen Acetylene Torch"
                        
                end
            end
        end
    end
end
