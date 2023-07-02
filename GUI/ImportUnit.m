function ImportUnit(~,~,app)
app.Visible = 'off';
% file = uigetfile; 
% run(file);

%Demo Bypass to Speed up Testing
run('Miller.m')
%------------------------------
app.UserData.Units = Units;
app.UserData.Connections = Connections;
app.UserData.Vessels = Vessels;
app.UserData.Sites = Sites;
app.UserData.Ports = Ports;

uiUnitTree = findobj(app,'UserData','uiUnitTree');

treenode = matlab.ui.container.TreeNode.empty;
names = string.empty;
for i = 1:size(Units,2)
    if ~ismember(Units{i}.Name,names)
        treenode(end+1) = uitreenode(uiUnitTree,'Text',Units{i}.Name,'NodeData',Units{i});
        names(end+1) = Units{i}.Name;
        [treenode, names] = AddChildUnitNodes(Units{i},treenode,names);
    end
end
expand(uiUnitTree,'all')

uiUnitVisuals = findobj(app,'UserData','uiUnitVisuals');
uiUnitVisualsAxes = findobj(app,'UserData','uiUnitVisualsAxes');
uiModuleGroupVisualsAxes = findobj(app,'UserData','uiModuleGroupVisualsAxes');

app.UserData.Connections.AssignDepths;
app.UserData.Connections.AssignConnections;
app.UserData.Connections.PlotAllCuboids(uiUnitVisuals,app.UserData);
app.UserData.Connections.AlignFaces(app.UserData);


for i = 1:length(Units)
    if isa(Units{i},'Module')
        Units{i}.Origin = Connection.FindOrigin(Units{i}.GraphicObj);
    end
end
CentreGeometry(app.UserData);
for i = 1:length(Units)
    if isa(Units{i},'Module')
        Units{i}.Origin = Connection.FindOrigin(Units{i}.GraphicObj);
    end
end

copyobj(uiUnitVisuals.Children,uiUnitVisualsAxes);
axis(uiUnitVisualsAxes,'off')
axis(uiUnitVisualsAxes,'vis3d')
axis(uiUnitVisualsAxes,'equal')
view(uiUnitVisualsAxes,45,45)

uiUnitVisualsAxes = ColorAllFaces(uiUnitVisualsAxes,[1 1 1]);

copyobj(uiUnitVisuals.Children,uiModuleGroupVisualsAxes);
axis(uiModuleGroupVisualsAxes,'off')
axis(uiModuleGroupVisualsAxes,'vis3d')
axis(uiModuleGroupVisualsAxes,'equal')
view(uiModuleGroupVisualsAxes,45,45)

uiModuleGroupVisualsAxes = ColorAllFaces(uiModuleGroupVisualsAxes,[0.5 0.5 0.5]);

uiUnitTree.SelectedNodes = treenode(1);
DisplayUnitProperties(uiUnitTree,[],app);


uiConnectionList = findobj(app,'UserData','uiConnectionList');
uiConnectionList.Items = [Connections(:).Name];
uiConnectionList.ItemsData = Connections;
setup.Value = Connections(1);

DisplayConnectionProperties([],setup,app);

DisplayUnitConnections(app)


uiSiteTree = findobj(app,'UserData','uiSiteTree');
PlatformsNode = uitreenode(uiSiteTree,'Text',"Platforms");
PortsNode = uitreenode(uiSiteTree,'Text',"Ports");
treenode = matlab.ui.container.TreeNode.empty;
for i = 1:size(Sites,2)
    switch Sites(i).Type
        case "Platform"
            treenode(end+1) = uitreenode(PlatformsNode,'Text',Sites(i).Name,'NodeData',Sites(i));
        case "Port"
            treenode(end+1) = uitreenode(PortsNode,'Text',Sites(i).Name,'NodeData',Sites(i));
    end
end
expand(uiSiteTree,'all')
uiSiteTree.SelectedNodes = uiSiteTree.Children(1).Children(1);
DisplaySiteProperties([],uiSiteTree,app)
DisplaySites(app)


uiVesselList = findobj(app,'UserData','uiVesselList');
uiVesselList.Items = [Vessels(:).Name];
uiVesselList.ItemsData = Vessels;
uiVesselList.Value = uiVesselList.ItemsData(1);

setup.Value = Vessels(1);
DisplayVesselProperties([],setup,app)

app.Visible = 'on';

end