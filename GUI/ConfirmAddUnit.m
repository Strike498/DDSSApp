function ConfirmAddUnit(~,~,app)

uiUnitTree = findobj(app,'UserData','uiUnitTree');
unitTreeNode = uitreenode(uiUnitTree,'Text','Test','NodeData',[]);


end