function DisplayConnectionProperties(~,ValueChangedData,app)

uiConnectionPropertiesTable = findobj(app,'UserData','uiConnectionPropertiesTable');
connection = ValueChangedData.Value;
table = struct2table(get(connection),'AsArray',true);
table = splitvars(table);
table = rows2vars(table);
uiConnectionPropertiesTable.Data = table(:,2);
uiConnectionPropertiesTable.RowName = table.OriginalVariableNames;
uiConnectionPropertiesTable.ColumnName = [];

DisplayUnitConnections(app)


end