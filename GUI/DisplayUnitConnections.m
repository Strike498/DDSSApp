function DisplayUnitConnections(app)

uiConnectionsGraph = findobj(app,'UserData','uiConnectionsGraph');
uiConnectionList = findobj(app,'UserData','uiConnectionList');

modules = [app.UserData.Units{cellfun(@(x) isa(x,'Module'),app.UserData.Units)}]';
excludeCons = [modules(~[modules.Include]).Connection];

Parent = modules(1).Parent{:};
Parent = Parent.Parent{:};
if Parent.FirstModule == "Bottom"
    targets = [app.UserData.Connections.Source]';
    sources = [app.UserData.Connections.Target]';
    AL = 'asap';
else
    sources = [app.UserData.Connections.Source]';
    targets = [app.UserData.Connections.Target]';
    AL = 'alap';
end

connIDs = [sources.Name;targets.Name]';
g = graph(string(connIDs(:,1)),string(connIDs(:,2)));

a(1:2:numel(connIDs)) = sources;
a(2:2:numel(connIDs)) = targets;
a = unique(a,'stable');
col = zeros(length(a),3);
for i = 1:length(a)
    col(i,:) = a(i).GraphicObj(1).FaceColor;
end
%[~, I] = max([a(:).Depth]);
diG = digraph(string(connIDs(:,1)),string(connIDs(:,2)));
order = toposort(diG,'order','stable');
basenode = order(end);

h = plot(uiConnectionsGraph,g,'Layout','layered','assignlayers',AL,'Direction','up','Sources',basenode,'LineStyle','-');
uiConnectionsGraph.Children.NodeColor = col;
highlight(h,uiConnectionList.Value.Source.Name,uiConnectionList.Value.Target.Name,'NodeLabelColor','r','EdgeColor','r','LineWidth',3);
highlight(h,excludeCons.GetSourceName,excludeCons.GetTargetName,'LineStyle','--');


end