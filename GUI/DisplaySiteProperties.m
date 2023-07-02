function DisplaySiteProperties(~,ValueChangedData,app)

uiSitePropertiesTable = findobj(app,'UserData','uiSitePropertiesTable');
site = ValueChangedData.SelectedNodes.NodeData;
[app.UserData.Sites(:).Selected] = deal(false);
site.Selected = true;
table = struct2table(get(site),'AsArray',true);
table = splitvars(table);
table = rows2vars(table);

uiSitePropertiesTable.Data = table(:,2);
uiSitePropertiesTable.RowName = table.OriginalVariableNames;
uiSitePropertiesTable.ColumnName = [];
DisplaySites(app)
end