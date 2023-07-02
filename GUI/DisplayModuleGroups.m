function DisplayModuleGroups(Source,~,app)

uiUnitVisualsAxes = findobj(app,'UserData','uiUnitVisualsAxes');
delete(findobj(uiUnitVisualsAxes.Children,'Type','line'));

patches = uiUnitVisualsAxes.Children(1:2:end);
surfaces = uiUnitVisualsAxes.Children(2:2:end);
set(patches,'FaceColor', [1 1 1]);
set(patches,'FaceAlpha', 0.5);
set(surfaces,'FaceColor', [1 1 1]);
set(surfaces,'FaceAlpha', 0.5);
Targets = Source.Value.Members;
hold(uiUnitVisualsAxes,'on')


for i = 1:length(Targets)
    idx = ismember(convertCharsToStrings({surfaces.DisplayName}),[Targets(i).Name]);
    set(patches(idx),'FaceColor', Source.Value.Color);
    set(surfaces(idx),'FaceColor', Source.Value.Color);
%     plot3(uiUnitVisualsAxes,Targets(i).Origin(1),Targets(i).Origin(2),Targets(i).Origin(3),...
%         'o','Color','k','MarkerFaceColor','k');
%     plot3(uiUnitVisualsAxes,[Targets(i).Origin(1);Targets(i).Origin(1)],[Targets(i).Origin(2);Targets(i).Origin(2)],[Targets(i).Origin(3);Targets(i).Origin(3)-Targets(i).Mass/100],...
%     'LineStyle','-','LineWidth',2,'Color',Targets(i).Color);
%     plot3(uiUnitVisualsAxes,Targets(i).Origin(1),Targets(i).Origin(2),Targets(i).Origin(3)-Targets(i).Mass/100,...
%     'Color',Targets(i).Color,'Marker','v');
end
plot3(uiUnitVisualsAxes,Source.Value.CoG(1),Source.Value.CoG(2),Source.Value.CoG(3),...
    'o','Color','r','MarkerFaceColor','r');
plot3(uiUnitVisualsAxes,Source.Value.LiftPoints(:,1),Source.Value.LiftPoints(:,2),Source.Value.LiftPoints(:,3),...
    'o','Color','k','MarkerFaceColor','k');


uiModuleGroupPropertiesTable = findobj(app,'UserData','uiModuleGroupPropertiesTable');
uiModuleGroupMembersList = findobj(app,'UserData','uiModuleGroupMembersList');

table = struct2table(get(Source.Value),'AsArray',true);
table = splitvars(table);
table = rows2vars(table);
uiModuleGroupPropertiesTable.Data = table(:,2);
uiModuleGroupPropertiesTable.RowName = table.OriginalVariableNames;
uiModuleGroupPropertiesTable.ColumnName = [];

uiModuleGroupMembersList.Items = [Source.Value.Members.Name];
uiModuleGroupMembersList.ItemsData = Source.Value.Members;
uiModuleGroupMembersList.Value = uiModuleGroupMembersList.ItemsData(1);

end
