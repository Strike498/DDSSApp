function ClearCampaigns(~,~,app)
uiSelectScenarioDrop = findobj(app,'UserData','uiSelectScenarioDrop');
scenario = uiSelectScenarioDrop.Value;
scenario.Campaigns = Campaign.empty;
DisplayEval(scenario,app);

end