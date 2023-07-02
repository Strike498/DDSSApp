function EvaluationTab(app,uiTabGp)

uiEvaluationTab = uitab(uiTabGp,...
    'Title','Evaluation');

uiEvaluationGrid = uigridlayout(uiEvaluationTab,[22 20]);

uiSelectScenarioLabel = uilabel(uiEvaluationGrid,...
    'Text','Select Scenario',...
    'FontSize',16,...
    'HorizontalAlignment','center');
uiSelectScenarioLabel.Layout.Row  = 1;
uiSelectScenarioLabel.Layout.Column  = [1 5];

uiVesselListLabel = uilabel(uiEvaluationGrid,...
    'Text','Vessel List',...
    'FontSize',16,...
    'HorizontalAlignment','center');
uiVesselListLabel.Layout.Row  = 1;
uiVesselListLabel.Layout.Column  = [6 8];

uiVesselPropertiesLabel = uilabel(uiEvaluationGrid,...
    'Text','Vessel Properties',...
    'FontSize',16,...
    'HorizontalAlignment','center');
uiVesselPropertiesLabel.Layout.Row  = 1;
uiVesselPropertiesLabel.Layout.Column  = [9 13];

uiActivityAssignmentLabel = uilabel(uiEvaluationGrid,...
    'Text','Activity Assignment',...
    'FontSize',16,...
    'HorizontalAlignment','center');
uiActivityAssignmentLabel.Layout.Row  = 1;
uiActivityAssignmentLabel.Layout.Column  = [15 20];

uiSelectScenarioDrop = uidropdown(uiEvaluationGrid,'UserData','uiSelectScenarioDrop',...
    'ValueChangedFcn',{@UpdateActivityTree,app});
uiSelectScenarioDrop.Layout.Row  = 2;
uiSelectScenarioDrop.Layout.Column  = [1 5];

uiVesselList = uilistbox(uiEvaluationGrid,'UserData','uiVesselList',...
    'Items',{},...
    'ValueChangedFcn',{@DisplayVesselProperties,app});
uiVesselList.Layout.Row  = [2 7];
uiVesselList.Layout.Column  = [6 8];

uiVesselPropertiesTable = uitable(uiEvaluationGrid,'UserData','uiVesselPropertiesTable');
uiVesselPropertiesTable.Layout.Row = [2 7];
uiVesselPropertiesTable.Layout.Column = [9 13];

uiActivitiesPanel = uipanel(uiEvaluationGrid,'UserData','uiActivitiesPanel',...
    'Title','Activity');
uiActivitiesPanel.Layout.Row = [2 7];
uiActivitiesPanel.Layout.Column = [15 17];
uiActivityPanelGrid = uigridlayout(uiActivitiesPanel,[1 1],'Padding',[0 0 0 0]);
uiActivityTree = uitree(uiActivityPanelGrid,'UserData','uiActivityTree',...
    'SelectionChangedFcn',{@SelectChild,app});

uiAssignedVesselPanel = uipanel(uiEvaluationGrid,'UserData','uiAssignedVesselPanel',...
    'Title','Assigned Vessels');
uiAssignedVesselPanel.Layout.Row = [2 7];
uiAssignedVesselPanel.Layout.Column = [18 20];
uiVesselPanelGrid = uigridlayout(uiAssignedVesselPanel,[1 1],'Padding',[0 0 0 0]);
uiVesselAssignmentList = uilistbox(uiVesselPanelGrid,'UserData','uiVesselAssignmentList',...
    'Items',{});

uiScenarioGraphAxes = uiaxes(uiEvaluationGrid,'UserData','uiScenarioGraphAxes');
set(uiScenarioGraphAxes,'XTick',[],'YTick',[],'Box','on')
uiScenarioGraphAxes.Layout.Row = [3 7];
uiScenarioGraphAxes.Layout.Column = [1 5];

uiAssignVesselButton = uibutton(uiEvaluationGrid,...
    'Text','>',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@AssignVessel,app});
uiAssignVesselButton.Layout.Row = 4;
uiAssignVesselButton.Layout.Column = 14;

uiRemoveVesselButton = uibutton(uiEvaluationGrid,...
    'Text','<',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@RemoveVessel,app});
uiRemoveVesselButton.Layout.Row = 5;
uiRemoveVesselButton.Layout.Column = 14;

uiClearCampaignsButton = uibutton(uiEvaluationGrid,...
    'Text','Clear Campaigns',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@ClearCampaigns,app});
uiClearCampaignsButton.Layout.Row = 8;
uiClearCampaignsButton.Layout.Column = [9 10];

uiGreedySearchButton = uibutton(uiEvaluationGrid,...
    'Text','Greedy Search',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@GreedySearch,app});
uiGreedySearchButton.Layout.Row = 8;
uiGreedySearchButton.Layout.Column = [11 12];

uiRandomSearchButton = uibutton(uiEvaluationGrid,...
    'Text','Random Search',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@RandomSearch,app});
uiRandomSearchButton.Layout.Row = 8;
uiRandomSearchButton.Layout.Column = [13 14];

uiBestFirstSearchButton = uibutton(uiEvaluationGrid,...
    'Text','Best First Search',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@BestFirstSearch,app});
uiBestFirstSearchButton.Layout.Row = 8;
uiBestFirstSearchButton.Layout.Column = [15 16];

uiGACampaignsButton = uibutton(uiEvaluationGrid,...
    'Text','GA Campaigns',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@GACampaigns,app});
uiGACampaignsButton.Layout.Row = 8;
uiGACampaignsButton.Layout.Column = [17 18];

uiCalculateCampaignsButton = uibutton(uiEvaluationGrid,...
    'Text','Calculate Campaigns',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@CalculateCampaigns,app});
uiCalculateCampaignsButton.Layout.Row = 8;
uiCalculateCampaignsButton.Layout.Column = [19 20];

uiCampaignListLabel = uilabel(uiEvaluationGrid,...
    'Text','Campaign List',...
    'FontSize',16,...
    'HorizontalAlignment','center');
uiCampaignListLabel.Layout.Row  = 8;
uiCampaignListLabel.Layout.Column  = [1 2];

uiCampaignDetailsLabel = uilabel(uiEvaluationGrid,...
    'Text','Campaign Details',...
    'FontSize',16,...
    'HorizontalAlignment','center');
uiCampaignDetailsLabel.Layout.Row  = 8;
uiCampaignDetailsLabel.Layout.Column  = [3 8];

uiCampaignList = uilistbox(uiEvaluationGrid,'UserData','uiCampaignList',...
    'Items',{},...
    'ValueChangedFcn',{@DisplayCampaigns,app});
uiCampaignList.Layout.Row  = [9 13];
uiCampaignList.Layout.Column  = [1 2];

uiCampaignDetailsTable = uitable(uiEvaluationGrid,'UserData','uiCampaignDetailsTable');
uiCampaignDetailsTable.Layout.Row = [9 13];
uiCampaignDetailsTable.Layout.Column = [3 12];

uiEvalResultsTabGroup = uitabgroup(uiEvaluationGrid);
uiEvalResultsTabGroup.Layout.Row = [14 22];
uiEvalResultsTabGroup.Layout.Column = [1 20];

uiEvalCampBarsTab = uitab(uiEvalResultsTabGroup,...
    'Title','Outcome Metrics');
uiEvalCBGrid = uigridlayout(uiEvalCampBarsTab,[1 1]);
uiEvalScheduleTab = uitab(uiEvalResultsTabGroup,...
    'Title','Schedule');
uiEvalSGrid = uigridlayout(uiEvalScheduleTab,[1 1]);

uiEvalGraphAxesPanel = uipanel(uiEvalCBGrid);
uiEGAPGrid = uigridlayout(uiEvalGraphAxesPanel,[2 4],'Padding',[0 0 0 0]);
uiEvalGAxes1 = uiaxes(uiEGAPGrid,'UserData','uiEvalGAxes1');
uiEvalGAxes2 = uiaxes(uiEGAPGrid,'UserData','uiEvalGAxes2');
uiEvalGAxes3 = uiaxes(uiEGAPGrid,'UserData','uiEvalGAxes3');
uiEvalGAxes4 = uiaxes(uiEGAPGrid,'UserData','uiEvalGAxes4');
uiEvalGAxes5 = uiaxes(uiEGAPGrid,'UserData','uiEvalGAxes5');
uiEvalGAxes6 = uiaxes(uiEGAPGrid,'UserData','uiEvalGAxes6');
uiEvalGAxes7 = uiaxes(uiEGAPGrid,'UserData','uiEvalGAxes7');
uiEvalGAxes8 = uiaxes(uiEGAPGrid,'UserData','uiEvalGAxes8');

% yyaxis(uiEvalGraphAxes,'left')
% ylabel(uiEvalGraphAxes,'Campaign Cost [£]')
% yyaxis(uiEvalGraphAxes,'right')

ylabel(uiEvalGAxes1,'Campaign Time [Hrs]')
xlabel(uiEvalGAxes1,'Campaign ID')
ylabel(uiEvalGAxes2,'Campaign Cost [£]')
xlabel(uiEvalGAxes2,'Campaign ID')
ylabel(uiEvalGAxes3,'CO2 Emissions [kg]')
xlabel(uiEvalGAxes3,'Campaign ID')
ylabel(uiEvalGAxes4,'NOx Emissions [kg]')
xlabel(uiEvalGAxes4,'Campaign ID')
ylabel(uiEvalGAxes5,'SOx Emissions [kg]')
xlabel(uiEvalGAxes5,'Campaign ID')
ylabel(uiEvalGAxes6,'PM Emissions [kg]')
xlabel(uiEvalGAxes6,'Campaign ID')
ylabel(uiEvalGAxes7,'CH4 Emissions [kg]')
xlabel(uiEvalGAxes7,'Campaign ID')
ylabel(uiEvalGAxes8,'Fuel Consumption [Litres]')
xlabel(uiEvalGAxes8,'Campaign ID')

uiEvalActAxes1 = uiaxes(uiEvaluationGrid,'UserData','uiEvalActAxes1');
set(uiEvalActAxes1,'Box','on')
grid(uiEvalActAxes1,'on')
uiEvalActAxes1.Layout.Row = [9 13];
uiEvalActAxes1.Layout.Column = [13 20];
ylabel(uiEvalActAxes1,'Outcome Metric (Combined)')
xlabel(uiEvalActAxes1,'Activity Index')

% uiEvalActAxes2 = uiaxes(uiEvaluationGrid,'UserData','uiEvalActAxes2');
% set(uiEvalActAxes2,'Box','on')
% uiEvalActAxes2.Layout.Row = [11 12];
% uiEvalActAxes2.Layout.Column = [13 20];
% ylabel(uiEvalActAxes2,'Cumulative Affine Criteria')
% xlabel(uiEvalActAxes2,'Activity Index')


uiEvalActAxes3 = uiaxes(uiEvalSGrid,'UserData','uiEvalActAxes3');
set(uiEvalActAxes3,'Box','on')
grid(uiEvalActAxes3,'on')
ylabel(uiEvalActAxes3,'Vessel')
xlabel(uiEvalActAxes3,'Time Period [days]')

end