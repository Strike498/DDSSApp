function [treenode, names] = AddChildUnitNodes(Units,treenode,names)
n = size(treenode,2);
for j = 1:size(Units.Children,2)
    treenode(end+1) = uitreenode(treenode(n),'Text',Units.Children{j}.Name,'NodeData',Units.Children{j});
    names(end+1) = Units.Children{j}.Name;
    if ~isempty(Units.Children{j}.Children)
        [treenode, names] = AddChildUnitNodes(Units.Children{j},treenode,names);
    end
end
end