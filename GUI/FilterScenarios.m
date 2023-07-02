function FilterScenarios(Source,~,app)
Projects = app.UserData;
uiScenariosList = findobj(app,'UserData','uiScenariosList');
if isempty(Source.Items) %Remove Filters
    uiScenariosList.Items = [Projects.Scenarios.Name];
    uiScenariosList.ItemsData = Projects.Scenarios;
else
    ids = sort([Source.ItemsData.ID]);
    ys = cellfun(@(y) sort([y.ID]),{Projects.Scenarios(:).Target},'UniformOutput',false);
    yv = cellfun(@(y) all(ismember(ids,y)),ys);
    idx = find(yv);
    if isempty(idx)
        uialert(app,'No Scenarios Containing Module Group Selection','Invalid Selection');
        RemoveGroup([],[],app)
    else
        uiScenariosList.Items = [Projects.Scenarios(idx).Name];
        uiScenariosList.ItemsData = Projects.Scenarios(idx);
    end
end

uiScenariosList.Value = uiScenariosList.ItemsData(1);
DisplayScenarios(uiScenariosList,[],app);

end