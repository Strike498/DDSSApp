classdef Activity < handle & matlab.mixin.SetGet
    %Activity
    %   Detailed explanation goes here
    
    properties
        Project
        ID int32
        Name
        Type categorical
        Duration
        Predecessors
        ResourceRequirement int32
        Timeline int32
        Site
        Destination
        
        %Separate
        Connection
        SeparateMethod categorical
        NumCuts
        CutThickness
        
        %Lift
        LiftTarget
        LiftMethod
        RiggingType
        MinSlingAngle
        ResourceOptions
        
        %Mobilise/ Demobilise
        StartSite
        EndSite
        ResourceAssignment
        Distance
        
        %Outcome
        Cost double
        Time
        FuelConsumption
        CO2
        NOx
        SOx
        PM
        CH4
    end
    
    methods
        function obj = Activity(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
                obj.ID = obj.Project.NID+1;
                obj.Project.NID =  obj.Project.NID+1;
                obj.Project.Objects{obj.ID} = obj;
                if ismember(obj.Type,categorical("Separate"))
                    obj.NumCuts = randi(50);
                    obj.CutThickness = rand(1,obj.NumCuts).*0.25;
                    
                elseif ismember(obj.Type,categorical("Lift"))
                    obj.RiggingType = categorical("Quad Sling Direct Load");
                    obj.MinSlingAngle = 60;
                    
                elseif ismember(obj.Type,categorical("Mobilise")) || ismember(obj.Type,categorical("Demobilise"))
                    obj.Distance = CalculateDistance([obj.StartSite.Latitude obj.StartSite.Longitude],[obj.EndSite.Latitude obj.EndSite.Longitude]);
                end
                obj.Name = strcat("Activity ",string(length(obj.Project.Activities)+1));
            end
        end
        function obj = CalculateTime(obj)
            if ismember(obj.Type,categorical("Separate"))
                CutRate = 0.25;
                obj.Time = (sum(obj.CutThickness)/CutRate);%/60 hr
                
            elseif ismember(obj.Type,categorical("Lift"))
                
                obj.Time = 0.00135319*obj.LiftTarget.Mass; %hr
                
            elseif ismember(obj.Type,categorical("Mobilise"))
                obj.Time = obj.ResourceAssignment.MobilisationTime + obj.Distance/(obj.ResourceAssignment.TransitSpeed*1.852);%hr
                
            elseif ismember(obj.Type,categorical("Demobilise"))
                obj.Time = obj.ResourceAssignment.DemobilisationTime + obj.Distance/(obj.ResourceAssignment.TransitSpeed*1.852); %hr
            end
        end
        function obj = CalculateCost(obj)
            if ismember(obj.Type,categorical("Separate"))
                obj.Cost = obj.Time*obj.ResourceAssignment.TimeCharterRate/24;
                
            elseif ismember(obj.Type,categorical("Lift"))
                obj.Cost = obj.Time*obj.ResourceAssignment.TimeCharterRate/24;
                
            elseif ismember(obj.Type,categorical("Mobilise"))
                obj.Cost = obj.Time*obj.ResourceAssignment.TimeCharterRate/24;
                
            elseif ismember(obj.Type,categorical("Demobilise"))
                obj.Cost = obj.Time*obj.ResourceAssignment.TimeCharterRate/24;
            end
        end
        function obj = CalculateEmissions(obj)
            if ismember(obj.Type,categorical("Separate"))
                obj.FuelConsumption = obj.Time*obj.ResourceAssignment.FuelConsumptionDP; %Litres
                
            elseif ismember(obj.Type,categorical("Lift"))
                obj.FuelConsumption = obj.Time*obj.ResourceAssignment.FuelConsumptionDP;
                
            elseif ismember(obj.Type,categorical("Mobilise"))
                obj.FuelConsumption = obj.ResourceAssignment.MobilisationTime*obj.ResourceAssignment.FuelConsumptionMoored+...
                    (obj.Time-obj.ResourceAssignment.MobilisationTime)*obj.ResourceAssignment.FuelConsumptionTransit;
                
            elseif ismember(obj.Type,categorical("Demobilise"))
                obj.FuelConsumption = obj.ResourceAssignment.DemobilisationTime*obj.ResourceAssignment.FuelConsumptionMoored+...
                    (obj.Time-obj.ResourceAssignment.DemobilisationTime)*obj.ResourceAssignment.FuelConsumptionTransit;
                
            end
            obj.CO2 = obj.FuelConsumption*obj.ResourceAssignment.CO2_EF; %kg
            obj.NOx = obj.FuelConsumption*obj.ResourceAssignment.NOx_EF;
            obj.SOx = obj.FuelConsumption*obj.ResourceAssignment.SOx_EF;
            obj.PM = obj.FuelConsumption*obj.ResourceAssignment.PM_EF;
            obj.CH4 = obj.FuelConsumption*obj.ResourceAssignment.CH4_EF;
        end
        
    end
end

