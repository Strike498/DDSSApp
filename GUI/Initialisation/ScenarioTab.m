function ScenarioTab(app,uiTabGp)

uiScenarioTab = uitab(uiTabGp,...
    'Title','Scenarios');

uiScenarioGrid = uigridlayout(uiScenarioTab,[24 20]);

uiDecomStagesAxes = uiaxes(uiScenarioGrid,'UserData','uiDecomStagesAxes');
set(uiDecomStagesAxes,'XTick',[],'YTick',[],'BackgroundColor',[0.941 0.941 0.941],'Box','on')
uiDecomStagesAxes.Layout.Row = [1 4];
uiDecomStagesAxes.Layout.Column = [1 20];
disableDefaultInteractivity(uiDecomStagesAxes)
uiDecomStagesAxes.Toolbar.Visible = 'off';
axis(uiDecomStagesAxes,'off')

%% Move this to Function
S = {'Facility Shutdown','Well Plug & Abandonment','Cleaning & Isolation','Topside Preparation','Topside Removal','Substructure Preparation','Substructure Removal','Onshore Disposal','Site Remediation'};
T = {'Well Plug & Abandonment','Cleaning & Isolation','Topside Preparation','Topside Removal','Substructure Preparation','Substructure Removal','Onshore Disposal','Site Remediation','Monitoring'};

G = digraph(S,T);
h = plot(uiDecomStagesAxes,G,'Layout','layered',...
    'Direction','right',...
    'PickableParts','none',...
    'MarkerSize',6,...
    'Marker','diamond',...
    'NodeFontSize',12,...
    'LineWidth',2);
highlight(h,shortestpath(G,1,5),'EdgeColor','#77AC30','NodeColor','#77AC30');
highlight(h,shortestpath(G,5,10),'EdgeColor','#A2142F','NodeColor','#A2142F');
highlight(h,5,'NodeColor','#EDB120','NodeLabelColor','#EDB120');
%% 

uiDecomStagesLabel = uilabel(uiScenarioGrid,...
    'Text','Decommissioning Stages',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiDecomStagesLabel.Layout.Row  = 1;
uiDecomStagesLabel.Layout.Column  = [1 20];

uiModuleGroupsListLabel = uilabel(uiScenarioGrid,...
    'Text','Module Groups List',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiModuleGroupsListLabel.Layout.Column  = [1 3];

uiModuleGroupLabel = uilabel(uiScenarioGrid,...
    'Text','Module Group',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiModuleGroupLabel.Layout.Column  = [4 10];

uiScenariosListLabel = uilabel(uiScenarioGrid,...
    'Text','Scenarios List',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiScenariosListLabel.Layout.Column  = [12 14];

uiScenarioVisualsLabel = uilabel(uiScenarioGrid,...
    'Text','Scenario Visualisation',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiScenarioVisualsLabel.Layout.Column  = [15 20];

uiModuleGroupsList = uilistbox(uiScenarioGrid,'UserData','uiModuleGroupsList',...
    'Items',{},...
    'ValueChangedFcn',{@DisplayModuleGroups,app});
uiModuleGroupsList.Layout.Row = [5 9];
uiModuleGroupsList.Layout.Column = [1 3];

uiModuleGroupFilter = uidropdown(uiScenarioGrid,'UserData','uiModuleGroupFilter',...
    'ValueChangedFcn',{@FilterModuleGroups,app});
uiModuleGroupFilter.Layout.Row = 10;
uiModuleGroupFilter.Layout.Column = [1 3];

uiAddGroupButton = uibutton(uiScenarioGrid,...
    'Text','+',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@AddGroup,app});
uiAddGroupButton.Layout.Row = 5;
uiAddGroupButton.Layout.Column = 4;

uiRemoveGroupButton = uibutton(uiScenarioGrid,...
    'Text','-',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@RemoveGroup,app});
uiRemoveGroupButton.Layout.Row = 6;
uiRemoveGroupButton.Layout.Column = 4;

uiUnitVisualsAxes = uiaxes(uiScenarioGrid,'UserData','uiUnitVisualsAxes');
set(uiUnitVisualsAxes,'XTick',[],'YTick',[],'BackgroundColor',[0.941 0.941 0.941],'Box','on')
uiUnitVisualsAxes.Layout.Row = [5 10];
uiUnitVisualsAxes.Layout.Column = [5 11];

uiScenariosList = uilistbox(uiScenarioGrid,'UserData','uiScenariosList',...
    'Items',{},...
    'ValueChangedFcn',{@DisplayScenarios,app});
uiScenariosList.Layout.Row = [5 15];
uiScenariosList.Layout.Column = [12 14];

uiModuleGroupVisualsAxes = uiaxes(uiScenarioGrid,'UserData','uiModuleGroupVisualsAxes');
set(uiModuleGroupVisualsAxes,'XTick',[],'YTick',[],'Color',[0.941 0.941 0.941],'Box','on')
uiModuleGroupVisualsAxes.Layout.Row = [5 15];
uiModuleGroupVisualsAxes.Layout.Column = [15 20];

uiModuleGroupPropertiesLabel = uilabel(uiScenarioGrid,...
    'Text','Module Group Properties',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiModuleGroupPropertiesLabel.Layout.Row  = 11;
uiModuleGroupPropertiesLabel.Layout.Column  = [4 8];

uiSelectedGroupsLabel = uilabel(uiScenarioGrid,...
    'Text','Selected Groups',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiSelectedGroupsLabel.Layout.Row  = 11;
uiSelectedGroupsLabel.Layout.Column  = [1 3];

uiModuleGroupMembersLabel = uilabel(uiScenarioGrid,...
    'Text','Members',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiModuleGroupMembersLabel.Layout.Row  = 11;
uiModuleGroupMembersLabel.Layout.Column  = [9 11];

uiSelectedGroupsList = uilistbox(uiScenarioGrid,'UserData','uiSelectedGroupsList',...
    'Items',{},...
    'ValueChangedFcn',{@DisplayModuleGroups,app});
uiSelectedGroupsList.Layout.Row = [12 15];
uiSelectedGroupsList.Layout.Column = [1 3];

uiModuleGroupPropertiesTable = uitable(uiScenarioGrid,'UserData','uiModuleGroupPropertiesTable');
uiModuleGroupPropertiesTable.Layout.Row = [12 15];
uiModuleGroupPropertiesTable.Layout.Column = [4 8];

uiModuleGroupMembersList = uilistbox(uiScenarioGrid,'UserData','uiModuleGroupMembersList',...
    'Items',{});
uiModuleGroupMembersList.Layout.Row = [12 15];
uiModuleGroupMembersList.Layout.Column = [9 11];

uiCalculateScenariosButton = uibutton(uiScenarioGrid,...
    'Text','Calculate Scenarios',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@CalculateScenarios,app});
uiCalculateScenariosButton.Layout.Row = 15;
uiCalculateScenariosButton.Layout.Column = [15 16];

uiActivityGraphLabel = uilabel(uiScenarioGrid,...
    'Text','Activity Graph',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiActivityGraphLabel.Layout.Row  = 16;
uiActivityGraphLabel.Layout.Column  = [4 8];

uiActivitiesLabel = uilabel(uiScenarioGrid,...
    'Text','Activities',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiActivitiesLabel.Layout.Row  = 16;
uiActivitiesLabel.Layout.Column  = [12 14];

uiActivitiesLabel = uilabel(uiScenarioGrid,...
    'Text','Activity Properties',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiActivitiesLabel.Layout.Row  = 16;
uiActivitiesLabel.Layout.Column  = [15 20];

uiActivityGraphAxes = uiaxes(uiScenarioGrid,'UserData','uiActivityGraphAxes');
set(uiActivityGraphAxes,'XTick',[],'YTick',[],'Box','on')
uiActivityGraphAxes.Layout.Row = [17 22];
uiActivityGraphAxes.Layout.Column = [1 11];

uiActivitiesList = uilistbox(uiScenarioGrid,'UserData','uiActivitiesList',...
    'Items',{},...
    'ValueChangedFcn',{@DisplayActivityProperties,app});
uiActivitiesList.Layout.Row = [17 22];
uiActivitiesList.Layout.Column = [12 14];

uiActivityPropertiesTable = uitable(uiScenarioGrid,'UserData','uiActivityPropertiesTable');
uiActivityPropertiesTable.Layout.Row = [17 22];
uiActivityPropertiesTable.Layout.Column = [15 20];


end