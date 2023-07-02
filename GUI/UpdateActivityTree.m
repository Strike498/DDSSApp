function UpdateActivityTree(src,~,app)

uiActivityTree = findobj(app,'UserData','uiActivityTree');
children = uiActivityTree.Children;
children.delete;
uiVesselAssignmentList = findobj(app,'UserData','uiVesselAssignmentList');
if ~isempty(uiVesselAssignmentList.Items)
    uiVesselAssignmentList.Items = {};
    uiVesselAssignmentList.ItemsData = [];
end

activities = [src.Value.Activities];
cats = unique([activities.Type]);
treenode = matlab.ui.container.TreeNode.empty(0,size(activities,2)+size(cats,2));
iter = 1;
for i = 1:size(cats,2)
    treenode(iter) = uitreenode(uiActivityTree,'Text',string(cats(i)));
    children = activities([activities.Type] == cats(i));
    for j = 1:size(children,2)
        ctn = uitreenode(treenode(iter),'Text',children(j).Name);
        if ~isempty(src.Value.Sequence)
            ctn.NodeData = src.Value.Sequence.Children(i).Children(j).NodeData;
        end
    end
    treenode(iter).NodeData = treenode(iter).Children(1);
    iter = iter + 1;
end

expand(uiActivityTree,'all')

src.Value.Sequence = copy(uiActivityTree);

e.SelectedNodes = treenode(1).Children(1);
SelectChild(uiActivityTree,e,app);
uiActivityTree.SelectedNodes = treenode(1).Children(1);
drawnow;
uiScenarioGraphAxes = findobj(app,'UserData','uiScenarioGraphAxes');

numNodes = length(src.Value.Activities)+2;
G = digraph();

idx = [src.Value.Activities.Type]=="Separate";
list = 1:numNodes-2;
G = addedge(G,1,list(idx)+1);
G = addedge(G,list+1,numNodes);

% Create hash table for activity ID's
keySet = [src.Value.Activities.ID];
valueSet = list+1;
M = containers.Map(keySet,valueSet);

% Add poset lines
for i = 1:size(src.Value.Posets,1)
    G = addedge(G,M([src.Value.Posets(i,1).ID]),M([src.Value.Posets(i,2).ID]));
end

G = transreduction(G);
src.Value.PosetGraph = G.Edges{:,:};

% Update graph visuals
H = plot(uiScenarioGraphAxes,G,'layout','Layered','Direction','Right','Source',1,'Sink',numNodes);
labelnode(H,[1 numNodes],{'Source','Target'});
labelnode(H,2:numNodes-1,[src.Value.Activities.Name]);
highlight(H,[1 numNodes],'MarkerSize',6,'NodeColor','k','NodeLabelColor','k');
for i = 1:size(G.Edges{:,:},1)
    highlight(H,G.Edges.EndNodes(i,1),G.Edges.EndNodes(i,2),'EdgeColor','g');    
end

DisplayEval(src.Value,app);

end