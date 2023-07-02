function AddGroup(~,~,app)

uiModuleGroupsList = findobj(app,'UserData','uiModuleGroupsList');
uiSelectedGroupsList = findobj(app,'UserData','uiSelectedGroupsList');

if ~any(strcmp(uiSelectedGroupsList.Items,uiModuleGroupsList.Value.Name))
    uiSelectedGroupsList.Items = [uiSelectedGroupsList.Items, uiModuleGroupsList.Value.Name];
    uiSelectedGroupsList.ItemsData = [uiSelectedGroupsList.ItemsData, uiModuleGroupsList.Value];
else
    uialert(app,'Module Group Already Selected','Invalid Selection');
end

FilterScenarios(uiSelectedGroupsList,[],app)

end