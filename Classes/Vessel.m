classdef Vessel < handle & matlab.mixin.SetGet
    %Vessel
    %   Detailed explanation goes here
    
    properties
        Project
        ID int32
        Name string
        Type categorical
        IMONumber int32
        YearBuilt double
        DeadweightTonnage double
        DisplacementTonnage double
        GrossTonnage double
        NetTonnage double
        LengthOverall double
        Beam double
        Depth double
        OperatingDepth double
        TransitDraft double
        TransitSpeed double
        CraneCapacity double
        HoistRate double
        SlewRate double
        OnHooksCapability
        DeckLoad double
        FreeDeckArea double
        CrewCapacity double
        MinCrew double
        DynamicPositioningClass categorical
        MinDowntime double
        MinVoyageDistance double
        MinRentalPeriod double
        TimeCharterRate double
        VoyageCharterRate double
        BareboatCharterRate double
        MobilisationCost double
        MobilisationTime double
        DemobilisationCost double
        DemobilisationTime double 
        Resource int32
        Timeline int32
        Site
        StartSite
        Operator int32
        FuelConsumptionTransit
        FuelConsumptionDP
        FuelConsumptionMoored
        FuelType categorical
        CuttingRate
        NumSimultaneousCuts
        
        CO2_EF
        NOx_EF
        SOx_EF
        PM_EF
        CH4_EF
        
        min_lift_rad
        max_lift_rad = 110;
        max_load_cap = 7000;
        min_load_cap = 500;
        max_rad_max_load = 40;
        min_lift_height = 38;
        max_lift_height = 110;
        
        Packages
    end
    
    methods
        function obj = Vessel(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
                obj.ID = obj.Project.NID+1;
                obj.Project.NID =  obj.Project.NID+1;
                obj.Project.Objects{obj.ID} = obj;
                obj.MobilisationTime = rand*48+5;
                obj.DemobilisationTime = rand*48+5;
                obj.CuttingRate = rand(1)*0.25;
                obj.NumSimultaneousCuts = obj.MinCrew;
                %obj.FuelConsumptionDP = 10*obj.GrossTonnage/10000;
                switch obj.FuelType
                    case "Marine Fuel Oil"
                        obj.CO2_EF = 3.06194; %kg/litre
                        obj.NOx_EF = 0.0760;
                        obj.SOx_EF = 0.0469;
                        obj.PM_EF = 0.0071;
                        obj.CH4_EF = 4.9164e-05;
                    case "Marine Gas Oil"
                        obj.CO2_EF = 2.73782; %kg/litre
                        obj.NOx_EF = 0.0469;
                        obj.SOx_EF = 0.0018;
                        obj.PM_EF = 8.1127e-04;
                        obj.CH4_EF = 4.2699e-05;
                    case "Diesel"
                        obj.CO2_EF = 2.66134; %kg/litre
                        obj.NOx_EF = 0.0368;
                        obj.SOx_EF = 0.008;
                        obj.PM_EF = 0.0013;
                        obj.CH4_EF = 1.9344e-04;
                    case "Liquefied Natural Gas"
                        obj.CO2_EF = 1.15583; %kg/litre
                        obj.NOx_EF = 0.0037;
                        obj.SOx_EF = 1.3575e-05;
                        obj.PM_EF = 4.9774e-05;
                        obj.CH4_EF = 0.0037;
                end

            end
        end
        function CreateResourceAssignments(Vessels,Projects)
            for i = 1:length(Vessels)
                n = nchoosek(1:length(Vessels),i);
                for j = 1:size(n,1)
                    Projects.ResourceAssignments(end+1) = ResourceAssignment('Project',Projects,...
                        'Resources',Vessels(n(j,:)));
                end
            end
        end
    end
end

