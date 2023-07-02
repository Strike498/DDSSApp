function FlipOrder(Source,~,app)
uiUnitListSortDrop = findobj(app,'UserData','uiUnitListSortDrop');
    if strcmp(Source.Text,'|A-Z')
        Source.Text = '|Z-A';
    else
        Source.Text = '|A-Z';
    end
    SortUnitList([],uiUnitListSortDrop,app)
end