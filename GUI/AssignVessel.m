function AssignVessel(src,event,app)

uiVesselList = findobj(app,'UserData','uiVesselList');
vessel = uiVesselList.Value;

uiVesselAssignmentList = findobj(app,'UserData','uiVesselAssignmentList');
if ~any(ismember(uiVesselAssignmentList.ItemsData,vessel))
    if isempty(uiVesselAssignmentList.Items)
        uiVesselAssignmentList.Items = vessel.Name;
    else
        uiVesselAssignmentList.Items = [uiVesselAssignmentList.Items{:},vessel.Name];
    end
    uiVesselAssignmentList.ItemsData = [uiVesselAssignmentList.ItemsData,vessel];
    uiVesselAssignmentList.Value = vessel;
end

uiActivityTree = findobj(app,'UserData','uiActivityTree');
uiActivityTree.SelectedNodes.NodeData = {uiVesselAssignmentList.Items,uiVesselAssignmentList.ItemsData};


uiSelectScenarioDrop = findobj(app,'UserData','uiSelectScenarioDrop');
idx = uiSelectScenarioDrop.ItemsData == uiSelectScenarioDrop.Value;
uiSelectScenarioDrop.ItemsData(idx).Sequence = copy(uiActivityTree);


ind = strcmp(uiActivityTree.SelectedNodes.Text,[uiSelectScenarioDrop.ItemsData(idx).Activities.Name]);
uiSelectScenarioDrop.ItemsData(idx).ResourceAssignment(ind,:) = uiVesselAssignmentList.ItemsData;

end