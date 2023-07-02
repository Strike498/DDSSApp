function DisplayScenarios(Source,~,app)
% Fetch Axes and Graphic Obj handles
uiUnitVisuals = findobj(app,'UserData','uiUnitVisuals');
uiModuleGroupVisualsAxes = findobj(app,'UserData','uiModuleGroupVisualsAxes');
hold(uiModuleGroupVisualsAxes,'on');

Targets = Source.Value.Target;
oldpatches = uiUnitVisuals.Children(1:2:end);
oldsurfaces = uiUnitVisuals.Children(2:2:end);
% Delete old lift lines and reassemble topside
delete(findobj(uiModuleGroupVisualsAxes.Children,'Type','line'));
uiModuleGroupVisualsAxes = ColorAllFaces(uiModuleGroupVisualsAxes,[0.5 0.5 0.5]);
patches = uiModuleGroupVisualsAxes.Children(1:2:end);
surfaces = uiModuleGroupVisualsAxes.Children(2:2:end);
for n = 1:length(patches)
patches(n).ZData = oldpatches(n).ZData;
surfaces(n).ZData = oldsurfaces(n).ZData;

end
% Update Module Group colours and add lift lines to visualisation
for i = 1:length(Targets)
    idx = ismember(convertCharsToStrings({surfaces.DisplayName}),[Targets(i).Members.Name]);
    Targets(i).GraphicObj = patches(idx);
    set(patches(idx),'FaceColor',Targets(i).Color);
    set(surfaces(idx),'FaceColor',Targets(i).Color);
    midx(i) = min(min([surfaces(idx).XData]))+(max(max([surfaces(idx).XData])) - min(min([surfaces(idx).XData])))/2;
    midy(i) = min(min([surfaces(idx).YData]))+(max(max([surfaces(idx).YData])) - min(min([surfaces(idx).YData])))/2;
    bottom(i) = min(min([surfaces(idx).ZData]));
end

% [~,I] = sort(bottom);
[O,I] = sort([Targets.MaxOrder],'descend');

avgH = max([20,mean([Targets.Height])]);
OrderedHeights = [Targets(I).Height];
for i = 1:length(Targets)
    idx = ismember(convertCharsToStrings({surfaces.DisplayName}),[Targets(i).Members.Name]);
    cuboids = [patches(idx),surfaces(idx)];
    offset = 0.25*find(O==Targets(i).MaxOrder)*avgH+sum(OrderedHeights(1:find(O==Targets(i).MaxOrder)-1))-(bottom(i)-min(bottom));
    for j = 1:size(cuboids,1)
        Connection.TranslateCuboid(cuboids(j,:),[0 0 offset]); 
    end
    plot3(uiModuleGroupVisualsAxes,[midx(i);midx(i)],[midy(i);midy(i)],[bottom(i);min(min([surfaces(idx).ZData]))],...
        'LineStyle','--','LineWidth',2,'Color',Targets(i).Color);
    P(i) = Targets(i).GraphicObj(1);
end

legend(P(flip(I)),[Targets(flip(I)).Name],'Location','northwest');

% Fetch Activity Graph Handles and update lists to selected scenario
uiActivityGraphAxes = findobj(app,'UserData','uiActivityGraphAxes');
uiActivitiesList = findobj(app,'UserData','uiActivitiesList');
set(uiActivitiesList,'Items',[Source.Value.Activities.Name]);
set(uiActivitiesList,'ItemsData',[Source.Value.Activities]);
set(uiActivitiesList,'Value',uiActivitiesList.ItemsData(1));
A.Value = uiActivitiesList.ItemsData(1);

% Create graph of activities with source and target dummy nodes
numNodes = length(Source.Value.Activities)+2;
G = digraph();

idx = [Source.Value.Activities.Type]=="Separate";
list = 1:numNodes-2;
G = addedge(G,1,list(idx)+1);
G = addedge(G,list+1,numNodes);

% Create hash table for activity ID's
keySet = [Source.Value.Activities.ID];
valueSet = list+1;
M = containers.Map(keySet,valueSet);

% Add poset lines
for i = 1:size(Source.Value.Posets,1)
    G = addedge(G,M([Source.Value.Posets(i,1).ID]),M([Source.Value.Posets(i,2).ID]));
end

G = transreduction(G);
Source.Value.PosetGraph = G.Edges{:,:};

% Update graph visuals
H = plot(uiActivityGraphAxes,G,'layout','Layered','Direction','Right','Source',1,'Sink',numNodes);
labelnode(H,[1 numNodes],{'Source','Target'});
labelnode(H,2:numNodes-1,[Source.Value.Activities.Name]);
highlight(H,[1 numNodes],'MarkerSize',6,'NodeColor','k','NodeLabelColor','k');
for i = 1:size(G.Edges{:,:},1)
    highlight(H,G.Edges.EndNodes(i,1),G.Edges.EndNodes(i,2),'EdgeColor','g');    
end

DisplayActivityProperties([],A,app);

end