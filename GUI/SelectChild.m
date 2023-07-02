function SelectChild(src,event,app)
if isa(event.SelectedNodes.NodeData,'matlab.ui.container.TreeNode')
    src.SelectedNodes = event.SelectedNodes.NodeData; %.children for multiselect
elseif ~isempty(event.SelectedNodes.NodeData)
    uiVesselAssignmentList = findobj(app,'UserData','uiVesselAssignmentList');
    uiVesselAssignmentList.Items = event.SelectedNodes.NodeData{1};
    uiVesselAssignmentList.ItemsData = event.SelectedNodes.NodeData{2};
else
    uiVesselAssignmentList = findobj(app,'UserData','uiVesselAssignmentList');
    uiVesselAssignmentList.Items = {};
    uiVesselAssignmentList.ItemsData = [];
end

end