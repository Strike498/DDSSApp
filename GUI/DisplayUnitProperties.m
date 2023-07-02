function DisplayUnitProperties(Source,~,app)

uiUnitPropertiesTable = findobj(app,'UserData','uiUnitPropertiesTable');
unit = Source.SelectedNodes.NodeData;
table = struct2table(get(unit),'AsArray',true);
table = splitvars(table);
table = rows2vars(table);
uiUnitPropertiesTable.Data = table(:,2);
uiUnitPropertiesTable.RowName = table.OriginalVariableNames;
uiUnitPropertiesTable.ColumnName = [];

modules = [app.UserData.Units{cellfun(@(x) isa(x,'Module'),app.UserData.Units)}];
for i = 1:length(modules)
    modules(i).GraphicObj(1).EdgeColor = 'k';
    modules(i).GraphicObj(1).LineWidth = 0.5;
    modules(i).GraphicObj(2).EdgeColor = 'k';
    modules(i).GraphicObj(2).LineWidth = 0.5;
end

if isa(unit,'Module')
    unit.GraphicObj(1).EdgeColor = 'r';
    unit.GraphicObj(1).LineWidth = 2;
    unit.GraphicObj(2).EdgeColor = 'r';
    unit.GraphicObj(2).LineWidth = 2;
end

end