function RemoveVessel(src,event,app)
uiVesselAssignmentList = findobj(app,'UserData','uiVesselAssignmentList');
vessel = uiVesselAssignmentList.Value;
if ~isempty(vessel)
    [~,idx] = ismember(vessel,uiVesselAssignmentList.ItemsData);
    uiVesselAssignmentList.ItemsData(idx) = [];
    uiVesselAssignmentList.Items(idx) = [];
end
uiActivityTree = findobj(app,'UserData','uiActivityTree');
uiActivityTree.SelectedNodes.NodeData = {uiVesselAssignmentList.Items,uiVesselAssignmentList.ItemsData};

uiSelectScenarioDrop = findobj(app,'UserData','uiSelectScenarioDrop');
idx = uiSelectScenarioDrop.ItemsData == uiSelectScenarioDrop.Value;
uiSelectScenarioDrop.ItemsData(idx).Sequence = copy(uiActivityTree);

end