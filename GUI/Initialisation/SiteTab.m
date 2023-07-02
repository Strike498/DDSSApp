function SiteTab(app,uiTabGp)

uiSiteTab = uitab(uiTabGp,...
    'Title','Site Map');

uiSiteGrid = uigridlayout(uiSiteTab,[20 20]);

uiSiteListLabel = uilabel(uiSiteGrid,...
    'Text','Site List',...
    'FontSize',16,...
    'HorizontalAlignment','center');
uiSiteListLabel.Layout.Row  = 1;
uiSiteListLabel.Layout.Column  = [1 3];

uiSiteListSortDrop = uidropdown(uiSiteGrid,...
    'Items',{'Sort By: Default','Sort By: Name','Sort By: Latitude','Sort By: Longitude'},...
    'Value','Sort By: Default');
uiSiteListSortDrop.Layout.Column = [4 5];

uiSiteMapPanel = uipanel(uiSiteGrid);
uiSiteMapPanel.Layout.Row  = [1 15];
uiSiteMapPanel.Layout.Column  = [6 15];

uiSiteMap = geoaxes(uiSiteMapPanel,'UserData','uiSiteMap');
hold(uiSiteMap,'on')
%geobasemap(uiSiteMap,'colorterrain')
geolimits(uiSiteMap,[35 65],[-25 25])

uiSitePropertiesLabel = uilabel(uiSiteGrid,...
    'Text','Site Properties',...
    'FontSize',16,...
    'HorizontalAlignment','center');
uiSitePropertiesLabel.Layout.Row  = 1;
uiSitePropertiesLabel.Layout.Column  = [16 20];

uiSiteTree = uitree(uiSiteGrid,'UserData','uiSiteTree',...
    'SelectionChangedFcn',{@DisplaySiteProperties,app});
uiSiteTree.Layout.Row  = [2 15];
uiSiteTree.Layout.Column  = [1 5];

uiSitePropertiesTable = uitable(uiSiteGrid,'UserData','uiSitePropertiesTable');
uiSitePropertiesTable.Layout.Row = [2 15];
uiSitePropertiesTable.Layout.Column = [16 20];

end