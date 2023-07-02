function SortTreeChildren(Children,SortType,app)
LC = length(Children);
if LC > 1
    switch SortType
        case 'Sort By: Default'
            Var = int32.empty(LC,0);
            for i = 1:length(Children)
                Var(i) = Children(i).NodeData.ID;
            end
        case 'Sort By: Name'
            Var = string.empty(LC,0);
            for i = 1:length(Children)
                Var(i) = string(Children(i).NodeData.Name);
            end
        case 'Sort By: Mass'
            Var = double.empty(LC,0);
            for i = 1:length(Children)
                Var(i) = Children(i).NodeData.Mass;
            end
    end
    uiUnitFlipOrderButton = findobj(app,'UserData','uiUnitFlipOrderButton');
    if strcmp(uiUnitFlipOrderButton.Text,'|A-Z')
        SortOpt = 'ascend';
    else
        SortOpt = 'descend';
    end
    [~,idx] = sort(Var,SortOpt);
    for i = 2:LC
        move(Children(idx(i)),Children(idx(i-1)))
    end
end
for i = 1:LC
    if ~isempty(Children(i).Children)
        SortTreeChildren([Children(i).Children],SortType,app)
    end
end
end