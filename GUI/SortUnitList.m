function SortUnitList(~,Event,app)
uiUnitTree = findobj(app,'UserData','uiUnitTree');
Obj = uiUnitTree;

SortTreeChildren([Obj.Children],Event.Value,app)

end