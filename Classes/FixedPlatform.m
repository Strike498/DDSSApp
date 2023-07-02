classdef FixedPlatform < Unit
    % Fixed Platform Offshore Structure
    %   Detailed explanation goes here
    
    properties
        Project
        ID int32
        Name string
        Type categorical
        Status categorical
        Mass double
        Length double
        Width double
        Height double
        Accommodation categorical
        CrewCapacity int32
        CraneCapacity double
        FreeDeckArea double
        Helideck logical
        Children 
        Timeline int32
        Activity int32
        Site
        Connection
        FirstModule categorical = categorical("Bottom")
        Parent
    end
    
    methods
        function obj = FixedPlatform(varargin)
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

