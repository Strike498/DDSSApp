function UnitTab(app,uiTabGp)
uiUnitTab = uitab(uiTabGp,...
    'Title','Units & Connections');

uiUnitGrid = uigridlayout(uiUnitTab,[20 20]);

uiUnitListLabel = uilabel(uiUnitGrid,...
    'Text','Unit List',...
    'FontSize',20,...
    'HorizontalAlignment','left');
uiUnitListLabel.Layout.Column  = [1 3];

uiUnitListSortDrop = uidropdown(uiUnitGrid,...
    'Items',{'Sort By: Default','Sort By: Name','Sort By: Mass'},...
    'Value','Sort By: Default',...
    'UserData','uiUnitListSortDrop',...
    'ValueChangedFcn',{@SortUnitList,app});
uiUnitListSortDrop.Layout.Column = [3 4];

uiUnitFlipOrderButton = uibutton(uiUnitGrid,...
    'Text','|A-Z',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'UserData','uiUnitFlipOrderButton',...
    'ButtonPushedFcn',{@FlipOrder,app});
uiUnitFlipOrderButton.Layout.Column = 5;

uiUnitPropertiesLabel = uilabel(uiUnitGrid,...
    'Text','Unit Properties',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiUnitPropertiesLabel.Layout.Column  = [6 10];

uiUnitVisualsLabel = uilabel(uiUnitGrid,...
    'Text','Unit Visualisation',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiUnitVisualsLabel.Layout.Column  = [11 20];

uiUnitTree = uitree(uiUnitGrid,'UserData','uiUnitTree',...
    'SelectionChangedFcn',{@DisplayUnitProperties,app});
uiUnitTree.Layout.Row = [2 9];
uiUnitTree.Layout.Column = [1 5];

uiUnitPropertiesTable = uitable(uiUnitGrid,'UserData','uiUnitPropertiesTable');
uiUnitPropertiesTable.Layout.Row = [2 9];
uiUnitPropertiesTable.Layout.Column = [6 10];

uiUnitVisuals = uiaxes(uiUnitGrid,'UserData','uiUnitVisuals');
set(uiUnitVisuals,'XTick',[],'YTick',[],'BackgroundColor',[0.94 0.94 0.94],'Box','on')
uiUnitVisuals.Layout.Row = [2 9];
uiUnitVisuals.Layout.Column = [11 20];

uiAddUnitButton = uibutton(uiUnitGrid,...
    'Text','Add Unit',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@AddUnit,app});
uiAddUnitButton.Layout.Row = 10;
uiAddUnitButton.Layout.Column = [1 2];

uiAddSubUnitButton = uibutton(uiUnitGrid,...
    'Text','Add Sub-Unit',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@AddSubUnit,app});
uiAddSubUnitButton.Layout.Column = [3 4];

uiRemoveUnitButton = uibutton(uiUnitGrid,...
    'Text','Remove Unit',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@RemoveUnit,app});
uiRemoveUnitButton.Layout.Column = [5 6];

uiImportUnitButton = uibutton(uiUnitGrid,...
    'Text','Import Units',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@ImportUnit,app});
uiImportUnitButton.Layout.Column = [7 8];


uiConnectionListLabel = uilabel(uiUnitGrid,...
    'Text','Connection List',...
    'FontSize',20,...
    'HorizontalAlignment','left');
uiConnectionListLabel.Layout.Row  = 11;
uiConnectionListLabel.Layout.Column  = [1 3];

uiConnectionListSortDrop = uidropdown(uiUnitGrid,...
    'Items',{'Sort By: Default','Sort By: Type'},...
    'Value','Sort By: Default');
uiConnectionListSortDrop.Layout.Column = [4 5];

uiConnectionPropertiesLabel = uilabel(uiUnitGrid,...
    'Text','Connection Properties',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiConnectionPropertiesLabel.Layout.Column  = [6 10];

uiConnectionsGraphLabel = uilabel(uiUnitGrid,...
    'Text','Connections Graph',...
    'FontSize',20,...
    'HorizontalAlignment','center');
uiConnectionsGraphLabel.Layout.Column  = [11 20];

uiConnectionList = uilistbox(uiUnitGrid,'UserData','uiConnectionList',...
    'ValueChangedFcn',{@DisplayConnectionProperties,app});
uiConnectionList.Layout.Row = [12 20];
uiConnectionList.Layout.Column = [1 5];

uiConnectionPropertiesTable = uitable(uiUnitGrid,'UserData','uiConnectionPropertiesTable');
uiConnectionPropertiesTable.Layout.Row = [12 20];
uiConnectionPropertiesTable.Layout.Column = [6 10];

uiConnectionsGraph = uiaxes(uiUnitGrid,'UserData','uiConnectionsGraph');
set(uiConnectionsGraph,'XTick',[],'YTick',[],'BackgroundColor',[1 1 1],'Box','on')
uiConnectionsGraph.Layout.Row = [12 20];
uiConnectionsGraph.Layout.Column = [11 20];

uiAddUnitPanel = uipanel(uiUnitGrid,'Title','Add Unit','Visible','off','UserData','uiAddUnitPanel');
uiAddUnitPanel.Layout.Row = [12 20];
uiAddUnitPanel.Layout.Column = [1 10];


end