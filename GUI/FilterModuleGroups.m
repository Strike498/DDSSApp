function FilterModuleGroups(Source,~,app)
Projects = app.UserData;
uiModuleGroupsList = findobj(app,'UserData','uiModuleGroupsList');

if isempty(Source.Value) %Remove Filters
    uiModuleGroupsList.Items = [Projects.ModuleGroups.Name];
    uiModuleGroupsList.ItemsData = Projects.ModuleGroups;
else
    idx = cellfun(@(x) any(x == Source.Value.ID), cellfun(@(y) [y.ID],{Projects.ModuleGroups(:).Members},'UniformOutput',false));
    uiModuleGroupsList.Items = [Projects.ModuleGroups(idx).Name];
    uiModuleGroupsList.ItemsData = Projects.ModuleGroups(idx);
end

end