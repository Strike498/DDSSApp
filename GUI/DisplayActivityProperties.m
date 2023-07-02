function DisplayActivityProperties(~,ValueChangedData,app)

uiActivityPropertiesTable = findobj(app,'UserData','uiActivityPropertiesTable');
activity = ValueChangedData.Value;
table = struct2table(get(activity),'AsArray',true);
table = splitvars(table);
table = rows2vars(table);

uiActivityPropertiesTable.Data = table(:,2);
uiActivityPropertiesTable.RowName = table.OriginalVariableNames;
uiActivityPropertiesTable.ColumnName = [];

uiActivityGraphAxes = findobj(app,'UserData','uiActivityGraphAxes');
H = uiActivityGraphAxes.Children;
highlight(H,2:length(H.NodeLabel)-1,'MarkerSize',4,'NodeColor','#0072BD','NodeLabelColor','#0072BD');
idx = find(ismember(H.NodeLabel,activity.Name));
highlight(H,idx,'MarkerSize',6,'NodeColor','r','NodeLabelColor','r');

end