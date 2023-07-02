classdef SysSettings < matlab.System
    %   Detailed explanation goes here
    
    properties
        NID int32 = 0
    end
    
    methods
        function obj = SysSettings(varargin)
            setProperties(obj,nargin,varargin{:});
        end
        
    end
end