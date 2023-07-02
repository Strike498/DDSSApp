classdef Port < handle & matlab.mixin.SetGet
    % Port
    %   Detailed explanation goes here
    
    properties
        Project
        ID int32
        Name string
        Type categorical
        AvailableBerths
        MooredVessels
        TotalQuayside
        MaxLOA
        MaxBeam
        MaxDraft
        MinChannelWidth
        MaxCraneCapacity
        Timeline
        Site
    end
    
    methods
        function obj = Port(varargin)
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
