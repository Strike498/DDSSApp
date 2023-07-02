function DisplayVesselProperties(~,ValueChangedData,app)

uiVesselPropertiesTable = findobj(app,'UserData','uiVesselPropertiesTable');
vessel = ValueChangedData.Value;
table = struct2table(get(vessel),'AsArray',true);
table = splitvars(table);
table = rows2vars(table);

uiVesselPropertiesTable.Data = table(:,2);
uiVesselPropertiesTable.RowName = table.OriginalVariableNames;
uiVesselPropertiesTable.ColumnName = [];

end