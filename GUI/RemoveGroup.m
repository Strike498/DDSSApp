function RemoveGroup(~,~,app)

uiModuleGroupsList = findobj(app,'UserData','uiModuleGroupsList');
uiSelectedGroupsList = findobj(app,'UserData','uiSelectedGroupsList');

if any(strcmp(uiSelectedGroupsList.Items,uiModuleGroupsList.Value.Name))
    idx = strcmp(uiSelectedGroupsList.Items,uiModuleGroupsList.Value.Name);
    
    uiSelectedGroupsList.Items = uiSelectedGroupsList.Items(~idx);
    uiSelectedGroupsList.ItemsData = uiSelectedGroupsList.ItemsData(~idx);
else
    uialert(app,'Module Group Not Selected','Invalid Selection');
end

FilterScenarios(uiSelectedGroupsList,[],app)

end