function DisplaySites(app)
Projects = app.UserData;
uiSiteMap = findobj(app,'UserData','uiSiteMap');
uiSiteTree = findobj(app,'UserData','uiSiteTree');
Sites = Projects.Sites;
delete(get(uiSiteMap,'children'))
for i = 1:length(Sites)
    if Sites(i).Selected
        color1 = 'y';
        color2 = 'y';
    else
        color1 = 'r';
        color2 = 'b';
    end
    switch Sites(i).Type
        case "Platform"
            geoplot(uiSiteMap,Sites(i).Latitude,Sites(i).Longitude,'^r','MarkerFaceColor',color1)
        case "Port"
            geoplot(uiSiteMap,Sites(i).Latitude,Sites(i).Longitude,'ob','MarkerFaceColor',color2)
    end
end



end