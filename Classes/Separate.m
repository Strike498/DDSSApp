classdef Separate < Activity
    %Separate Activity
    %   Detailed explanation goes here
    
    properties
        Connection
        Method categorical = "Hot Cutting"
        NumCuts
        Thickness
        
    end
    
    methods
        function obj = Separate(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
                obj.ID = obj.SysID.NID+1;
                obj.SysID.NID =  obj.SysID.NID+1;
            end
        end
    end
end