function CalculateScenarios(~,~,app)

uiScenariosList = findobj(app,'UserData','uiScenariosList');
uiModuleGroupsList = findobj(app,'UserData','uiModuleGroupsList');

Projects = app.UserData;

% Projects.Connections.CreateSeparateActivities(Projects);
% Projects.Connections.FindGroups(Projects);

%Bypass scenario calculation:
% load('DemoB2.mat')
% load('DemoPartialBrent.mat')
% Projects.NID = Demo.NID;
% Projects.Objects = Demo.Objects;
% Projects.ModuleGroups = Demo.ModuleGroups;
% Projects.Activities = Demo.Activities;
% Projects.Scenarios = Demo.Scenarios;
% Projects.Campaigns = Demo.Campaigns;
% Projects.transportMap = Demo.transportMap;
% Projects.campaignMap = Demo.campaignMap;

load('DemoMiller.mat')
Projects.NID = NID;
Projects.Objects = Objects;
Projects.ModuleGroups = ModuleGroups;
Projects.Activities = Activities;
Projects.Scenarios = Scenarios;

uiScenariosList.Items = [Projects.Scenarios.Name];
uiScenariosList.ItemsData = Projects.Scenarios;
uiScenariosList.Value = uiScenariosList.ItemsData(1);

uiModuleGroupsList.Items = [Projects.ModuleGroups.Name];
uiModuleGroupsList.ItemsData = Projects.ModuleGroups;
uiModuleGroupsList.Value = uiModuleGroupsList.ItemsData(1);

DisplayScenarios(uiScenariosList,[],app);
DisplayModuleGroups(uiModuleGroupsList,[],app);

uiSelectScenarioDrop = findobj(app,'UserData','uiSelectScenarioDrop');
uiSelectScenarioDrop.Items = uiScenariosList.Items;
uiSelectScenarioDrop.ItemsData = Projects.Scenarios;

uiModuleGroupFilter = findobj(app,'UserData','uiModuleGroupFilter');
modules = [Projects.Units{cellfun(@(x) isa(x,'Module')&&x.Include==true,Projects.Units)}];
uiModuleGroupFilter.ItemsData = {[],Projects.Units{cellfun(@(x) isa(x,'Module')&&x.Include==true,Projects.Units)}};
uiModuleGroupFilter.Items = ["- Filter -",modules.Name];

UpdateActivityTree(uiSelectScenarioDrop,[],app);

end