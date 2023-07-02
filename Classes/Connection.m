classdef Connection < handle & matlab.mixin.SetGet
    %   Connection Class Definition
    
    properties
        Project
        ID int32
        Name string
        Type categorical
        Source
        Target
        SFace
        TFace
        Offset
    end
    
    methods
        function obj = Connection(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
                obj.ID = obj.Project.NID+1;
                obj.Project.NID =  obj.Project.NID+1;
                obj.Project.Objects{obj.ID} = obj;
            end
        end
        function out = GetSourceIDs(Connections)
            out = zeros(size(Connections));
            for i = 1:length(Connections)
                out(i) = Connections(i).Source.ID;
            end
        end
        function out = GetTargetIDs(Connections)
            out = zeros(size(Connections));
            for i = 1:length(Connections)
                out(i) = Connections(i).Target.ID;
            end
        end
        function out = GetSourceName(Connections)
            out = string(zeros(size(Connections)));
            for i = 1:length(Connections)
                out(i) = Connections(i).Source.Name;
            end
        end
        function out = GetTargetName(Connections)
            out = string(zeros(size(Connections)));
            for i = 1:length(Connections)
                out(i) = Connections(i).Target.Name;
            end
        end
        
        function FindGroups(Connections,Projects)
%             f = waitbar(0,'Calculating Scenarios...');
            d = uiprogressdlg(Projects.SaveLocation,'Title','Please Wait',...
                'Message','Calculating Scenarios...');
            roots = findobj(Connections,'Type',"Root");
            modules = [Projects.Units{cellfun(@(x) isa(x,'Module'),Projects.Units)}]';
            excludeMods = modules(~[modules.Include]);
            Parent = modules(1).Parent{:};
            Parent = Parent.Parent{:};
            if Parent.FirstModule == "Bottom"
                connIDs = [roots.GetTargetIDs,roots.GetSourceIDs];
            else
                connIDs = [roots.GetSourceIDs,roots.GetTargetIDs];
            end
            diG = digraph(string(connIDs(:,1)),string(connIDs(:,2)));
            order = toposort(diG,'order','stable');
            basenode = order(end);
            boxes = [[Projects.Vessels.FreeDeckArea]./[Projects.Vessels.Beam]; Projects.Vessels.Beam]';
            capacities = [Projects.Vessels.CraneCapacity];

            xlist = string.empty;
            for i = 1:length(excludeMods)
                xnodes = shortestpath(diG,string(excludeMods(i).ID),diG.Nodes.Name{basenode});
                xlist = [xlist xnodes];
            end
            xlist = unique(xlist);
            
            G_closeness = distances(diG,diG.Nodes.Name,diG.Nodes.Name{basenode});
            for i = 1:size(G_closeness,1)
                imod = findobj(modules,'ID',str2double(diG.Nodes.Name{i}));
                if ~isempty(imod)
                    imod.Closeness = G_closeness(i);
                    imod.Order = find(order==i);
                    imod.Neighbours = nearest(diG,i,size(connIDs,1));
                end
            end
            modules = modules(~ismember([modules.ID],str2double(xlist)));
            roots = unique(findobj([modules.Connection],'Type',"Root"),'stable');
            structs = unique(findobj([modules.Connection],'Type',"Structural"));
            if Parent.FirstModule == "Bottom"
                connIDs = [roots.GetTargetIDs,roots.GetSourceIDs];
            else
                connIDs = [roots.GetSourceIDs,roots.GetTargetIDs];
            end
            %connIDs = connIDs(~sum(ismember(connIDs,[excludeMods.ID]),2),:);
            G = graph(string(connIDs(:,1)),string(connIDs(:,2)));
            MGMap = containers.Map();
            
            n = size(connIDs,1);
            for i = 0:n
%                 waitbar(i/n,f,'Calculating Scenarios...');
                d.Value = i/n;
%                 Demo = Projects;
%                 save('DemoB2.mat','Demo');
                cuts = nchoosek(1:n,i);
                numCuts = size(cuts,1);
                for j = 1:numCuts
                    g = G;
                    if ~isempty(cuts)
                        idx = findedge(g,string(connIDs(cuts(j,:),1)),string(connIDs(cuts(j,:),2)));
                        g = rmedge(g,idx);
                    end
                    a = g.conncomp;
                    numModGp = size(unique(a),2);
                    sets = ModuleGroup.empty;
                    for k = 1:numModGp
                        modID = str2double(g.Nodes.Name(a==k));
                        hobj = [Projects.Objects{modID}];
                        cutMod = [hobj.Depth]==max([hobj.Depth]);
                        if Parent.FirstModule == "Bottom"
                            rootSourceIdx = roots.GetTargetIDs;
                            structSourceIdx = structs.GetTargetIDs;
                            structTargetIdx = structs.GetSourceIDs;
                        else
                            rootSourceIdx = roots.GetSourceIDs;
                            structSourceIdx = structs.GetSourceIDs;
                            structTargetIdx = structs.GetTargetIDs;
                        end
                        rootCon = roots(rootSourceIdx == hobj(cutMod).ID);
                        structCon = structs(xor(ismember(structSourceIdx,[hobj.ID]),ismember(structTargetIdx,[hobj.ID])))';
                        check = isKey(MGMap,char(strjoin(string(sort(modID)'))));
                        
                        if check
                            moduleGroup = MGMap(char(strjoin(string(sort(modID)'))));
                            sets(end+1) = moduleGroup;
                        elseif ~any(ismember([hobj.ID],str2double(xlist)))
                            Projects.ModuleGroups(end+1) = ModuleGroup('Project',Projects,'Members',hobj,'Connection',[structCon,rootCon]);
                            moduleGroup = Projects.ModuleGroups(end);
                            test1 = sum(boxes - [moduleGroup.Length moduleGroup.Width]>0,2)>1;
                            test2 = sum(boxes - [moduleGroup.Width moduleGroup.Length]>0,2)>1;
                            test = find(or(test1,test2));
                            testc = find(capacities>=moduleGroup.Mass);
                            test = test(ismember(test,testc'));

                            Projects.Activities(end+1) = Activity('Project',Projects,...
                                'Type',"Lift",...
                                'LiftMethod',"Crane Lift",...
                                'LiftTarget',moduleGroup,...
                                'Site',moduleGroup.Site,...
                                'ResourceOptions',test,...
                                'Destination',moduleGroup.Destination);
                            moduleGroup.Activities = [moduleGroup.Activities Projects.Activities(end)];
                            MGMap(char(strjoin(string(sort(modID)')))) = moduleGroup;
                            sets(end+1) = moduleGroup;
                        end
                        clear hobj
                    end
                    if ~isempty(sets) && all(ismember(modules,unique([sets.Members])))
                        [~, I] = sort([sets.MaxOrder]);
                        sets = sets(I);
                        sepAct = Projects.Activities(ismember([Projects.Activities.Connection],[sets.Connection]));
                        liftAct = [Projects.Activities.Type];
                        liftAct = Projects.Activities(liftAct=="Lift");
                        liftAct = liftAct(ismember([liftAct.LiftTarget],sets));
                        
                        Projects.Scenarios(end+1) = Scenario('Project',Projects,...
                            'Name',strcat("Scenario ", string(length(Projects.Scenarios)+1)),...
                            'Type',categorical("Separate&Lift"),...
                            'Target',sets,...
                            'Activities',[sepAct liftAct]);
                        
                        lA = liftAct;
                        sAStore = [];
                        if any(isempty([liftAct.Predecessors]))
                            for x = 1:size(sets,2)
                                sA = Projects.Activities(ismember([Projects.Activities.Connection],[sets(x).Connection]));
                                sA = sA(~ismember(sA,sAStore));
                                sAStore = [sAStore sA];
                                lAf = lA(ismember([lA.LiftTarget],sets(x)));
                                lAf.Predecessors = sA;
                                for y = 1:size(sA,2)
                                    Projects.Scenarios(end).Posets = [Projects.Scenarios(end).Posets; sA(y) lAf];
                                end
                            end
                        else
                            for x = 1:size(sets,2)
                                sA = Projects.Activities(ismember([Projects.Activities.Connection],[sets(x).Connection]));
                                lAf = lA(ismember([lA.LiftTarget],sets(x)));
                                for y = 1:size(sA,2)
                                    Projects.Scenarios(end).Posets = [Projects.Scenarios(end).Posets; sA(y) lAf];
                                end
                            end
                        end
                        %                     if length(Projects.Scenarios) == 99
                        %                         keyboard
                        %                     end
                        
                        mds = [liftAct.LiftTarget];
                        md = [mds.MaxCloseness];
                        sz = size(md,2);
                        if sz>1
                            cm = [nchoosek(1:sz,2); flip(nchoosek(1:sz,2),2)];
                            for x = 1:size(cm,1)
                                if mds(cm(x,1)).MaxOrder<mds(cm(x,2)).MaxOrder
                                    allN = diG.Nodes.Name(mds(cm(x,1)).AllNeighbours);
                                    allN = cellfun(@str2double,allN)';
                                    allM = double([mds(cm(x,2)).Members.ID]);
                                    if any(ismember(allN,allM))
                                        Projects.Scenarios(end).Posets = [Projects.Scenarios(end).Posets;[repmat(liftAct(cm(x,1)),size(liftAct(cm(x,2)).Predecessors,2),1) liftAct(cm(x,2)).Predecessors']];
                                        %Projects.Scenarios(end).Posets = [Projects.Scenarios(end).Posets;liftAct(cm(x,:))];
                                    end
                                end
                            end
                        end
                        Projects.Scenarios(end).Posets = unique(Projects.Scenarios(end).Posets,'rows','stable');
                        for x = 1:size(liftAct,2)
                            liftAct(x).Predecessors = [];
                        end
                    end
                end
            end
            clear sets
            close(d)
        end
        function AssignDepths(Connections)
            rootIdx = ismember([Connections.Type],{'Root'});
            roots = Connections(rootIdx);
            Projects = Connections(1, 1).Project;
            modules = [Projects.Units{cellfun(@(x) isa(x,'Module'),Projects.Units)}]';
            Parent = modules(1).Parent{:};
            Parent = Parent.Parent{:};
            if Parent.FirstModule == "Bottom"
                targets = [roots.Source]';
                sources = [roots.Target]';
            else
                sources = [roots.Source]';
                targets = [roots.Target]';
            end
            modules = unique([sources targets]);
            connIDs = [sources.ID;targets.ID]';
            g = digraph(string(connIDs(:,1)),string(connIDs(:,2)));
            imp = toposort(g);
            modID = str2double(g.Nodes.Name(imp));
            for i = 1:size(modID,1)
                hobj = findobj(modules,'ID',modID(i));
                hobj.Depth = i;
            end
        end
        function CreateSeparateActivities(Connections,Projects)
            for i = 1:length(Connections)
                Projects.Activities(end+1) = Activity('Project',Projects,...
                    'Type',"Separate",...
                    'Connection',Connections(i),...
                    'Site',Connections(i).Source.Site,...
                    'Destination',Connections(i).Source.Site);
            end
        end
        function AssignConnections(Connections)
            for i = 1:length(Connections)
                if isempty(Connections(i).Source.Connection)
                    Connections(i).Source.Connection = Connections(i);
                else
                    Connections(i).Source.Connection = [Connections(i).Source.Connection,Connections(i)];
                end
                if isempty(Connections(i).Target.Connection)
                    Connections(i).Target.Connection = Connections(i);
                else
                    Connections(i).Target.Connection = [Connections(i).Target.Connection,Connections(i)];
                end
            end
        end
        function AlignFaces(Connections,Projects)
            for n = 1:length(Connections)
                Connection = Connections(n);
                if Connection.Type == "Dummy"
                    continue
                end
                switch Connection.SFace
                    case 1
                        x = - Connection.Source.Length/2 + Connection.Target.Length/2;
                        y = - Connection.Source.Width/2  - Connection.Target.Width/2;
                        z = - Connection.Source.Height/2 + Connection.Target.Height/2;
                    case 2
                        x = + Connection.Source.Length/2 + Connection.Target.Length/2;
                        y = - Connection.Source.Width/2  - Connection.Target.Width/2;
                        z = - Connection.Source.Height/2 + Connection.Target.Height/2;
                    case 3
                        x = - Connection.Source.Length/2 + Connection.Target.Length/2;
                        y = - Connection.Source.Width/2  + Connection.Target.Width/2;
                        z = + Connection.Source.Height/2 + Connection.Target.Height/2;
                    case 4
                        x = + Connection.Source.Length/2 - Connection.Target.Length/2;
                        y = + Connection.Source.Width/2  + Connection.Target.Width/2;
                        z = - Connection.Source.Height/2 + Connection.Target.Height/2;
                    case 5
                        x = - Connection.Source.Length/2 - Connection.Target.Length/2;
                        y = + Connection.Source.Width/2  - Connection.Target.Width/2;
                        z = - Connection.Source.Height/2 + Connection.Target.Height/2;
                    case 6
                        x = - Connection.Source.Length/2 + Connection.Target.Length/2;
                        y = + Connection.Source.Width/2  - Connection.Target.Width/2;
                        z = - Connection.Source.Height/2 - Connection.Target.Height/2;
                end
                Connection.Source.Origin = Connection.FindOrigin(Connection.Source.GraphicObj);
                Connection.Target.Origin = Connection.FindOrigin(Connection.Target.GraphicObj);
                totalOffset = [x,y,z]-(Connection.Target.Origin-Connection.Source.Origin)+Connection.Offset;
                Connection.Target.GraphicObj = Connection.TranslateCuboid(Connection.Target.GraphicObj,totalOffset);
                sourceFound = false;
                targetFound = false;
                if isempty(Projects.GraphicChain)
                    Projects.GraphicChain = {Connection.Source,Connection.Target};
                else
                    for i = 1:length(Projects.GraphicChain)
                        if ismember(Connection.Target,Projects.GraphicChain{i})
                            targetFound = true;
                            group = setdiff(Projects.GraphicChain{i},Connection.Target);
                            for j = 1:length(group)
                                group(j).GraphicObj = Connection.TranslateCuboid(group(j).GraphicObj,totalOffset);
                                group(j).Origin = Connection.FindOrigin(group(j).GraphicObj);
                            end
                            for k = 1:length(Projects.GraphicChain)
                                if ismember(Connection.Source,Projects.GraphicChain{k}) && i~=k
                                    sourceFound = true;
                                    Projects.GraphicChain{i} = unique([Projects.GraphicChain{i},Projects.GraphicChain{k}]);
                                    Projects.GraphicChain{k} = [];
                                    break
                                end
                            end
                            if ~sourceFound
                                Projects.GraphicChain{i} = [Projects.GraphicChain{i},Connection.Source];
                            end
                            break
                        end
                    end
                    if ~targetFound
                        for k = 1:length(Projects.GraphicChain)
                            if ismember(Connection.Source,Projects.GraphicChain{k})
                                sourceFound = true;
                                Projects.GraphicChain{k} = [Projects.GraphicChain{k},Connection.Target];
                                break
                            end
                        end
                        if ~sourceFound
                            Projects.GraphicChain(length(Projects.GraphicChain)+1) = {Connection.Source,Connection.Target};
                        end
                    end
                end
            end
        end
    end
    methods(Static)
        function PlotAllCuboids(ax,Projects)
            hold(ax,'on')
            Units = Projects.Units;
            for i = 1:length(Units)
                if isa(Units{i},'Module')
                    switch Units{i}.GraphicShape
                        case "Cuboid"
                            Units{i}.GraphicObj = Connection.PlotCuboid(ax,Units{i}.Length,...
                                Units{i}.Width,...
                                Units{i}.Height,...
                                [0,0,0],Units{i}.Color);
                            label(i) = Units{i}.Name;
                            Units{i}.Color = Units{i}.GraphicObj(1).FaceColor;
                        case "Jacket"
                            Units{i}.GraphicObj = Connection.PlotJacket(ax,Units{i}.Length,...
                                Units{i}.Width,...
                                Units{i}.Height,...
                                [0,0,0],Units{i}.Color);
                            label(i) = Units{i}.Name;
                    end
                end
            end
            label = rmmissing(label);
            legend(ax.Children(end:-2:2),label,'Location','northeast')
            
            
            axis(ax,'off')
            axis(ax,'vis3d')
            axis(ax,'equal')
            view(ax,45,45)
        end
        function origin = FindOrigin(cuboid)
            
            x = min(cuboid(1).XData,[],'all')+(max(cuboid(1).XData,[],'all') - min(cuboid(1).XData,[],'all'))/2;
            y = min(cuboid(1).YData,[],'all')+(max(cuboid(1).YData,[],'all') - min(cuboid(1).YData,[],'all'))/2;
            z = min(cuboid(1).ZData,[],'all')+(max(cuboid(1).ZData,[],'all') - min(cuboid(1).ZData,[],'all'))/2;
            
            origin = [x,y,z];
        end
        function out = PlotCuboid(ax,L,W,H,offset,col)
            a = -pi : pi/2 : pi;                                % Define Corners
            ph = pi/4;                                          % Define Angular Orientation (‘Phase’)
            x = (L/2)*[cos(a+ph); cos(a+ph)]/cos(ph);
            y = (W/2)*[sin(a+ph); sin(a+ph)]/sin(ph);
            z = (H/2)*[-ones(size(a)); ones(size(a))];
            x = x+offset(1);
            y = y+offset(2);
            z = z+offset(3);
            if isempty(col)
                col = rand(1,3);
            end
            out(1) = surf(ax,x, y, z,'FaceColor',col,'EdgeColor','k');
            out(2) = patch(ax,x',y',z',col);
        end
        function out = PlotJacket(ax,L,W,H,offset,col)
            visuals = ax;
            fidelity = 10;
            lwidth = 1;
            hwidth = 0.5;
            cwidth = 0.5;
            nlegs = 4;
            nlegsx = 4;
            nlegsy = 3;
            hbracez = [H/10 H*2/5 H*7/10 H];
            twist = 0;
            prismtype = 'symmetric'; % {'symmetric', 'rectangular'}
            config = ["k" "x" "-k" ""]; % {'z' 'k' 'x'}
            lt = 31*2^(1/2);
            lb = W*2^(1/2);
            lt2 = L*2^(1/2);
            lb2 = L*2^(1/2);
            zt = H;
            zb = 0;
            vlt = 2;
            vlb = 0;
            
            faceangle = linspace(0, 2*pi, nlegs+1);
            rb = lb/(2*sin(pi/nlegs));
            xb = double(rb*cos(faceangle));
            yb = double(rb*sin(faceangle));
            zb = zb.*ones(1,size(xb,2));
            
            rt = lt/(2*sin(pi/nlegs));
            xt = double(rt*cos(faceangle));
            yt = double(rt*sin(faceangle));
            zt = zt.*ones(1,size(xt,2));
            
            [xt, yt] = rotateP([xt;yt],twist,[0;0]);
            
            point0 = [xb;yb;zb];
            point1 = [xt;yt;zt];
            vec = (point1 - point0)./(zt(1));
            xm = [point0(1,:) + hbracez'.*vec(1,:)];
            ym = [point0(2,:) + hbracez'.*vec(2,:)];
            zm = [point0(3,:) + hbracez'.*vec(3,:)];
            
            if vlt > 0
                xm(end,:) = xt;
                ym(end,:) = yt;
            end
            if vlb > 0
                xm(1,:) = xb;
                ym(1,:) = yb;
            end
            
            
            for i = 1:nlegs
                legs{i} = PrismP2P(visuals,fidelity,lwidth,[xb(i) yb(i) zb(i)],[xt(i) yt(i) zt(i)]); %Legs
                if vlt > 0
                    vlegst{i} = PrismP2P(visuals,fidelity,lwidth,[xt(i) yt(i) zt(i)],[xt(i) yt(i) zt(i)+vlt]); %VT Legs
                end
                if vlb > 0
                    vlegsn{i} = PrismP2P(visuals,fidelity,lwidth,[xb(i) yb(i) zb(i)],[xb(i) yb(i) zb(i)-vlb]); %VB Legs
                end
                
                for j = 1:size(hbracez,2) % Horizontal Braces
                    hbraces{j,i} = PrismP2P(visuals,fidelity,hwidth,[xm(j,i) ym(j,i) zm(j,i)],[xm(j,i+1) ym(j,i+1) zm(j,i+1)]);
                end
                
                for j = 1:size(hbracez,2)-1 % Cross Braces 1
                    switch config(j)
                        case "z"
                            zbraces1{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j,i) ym(j,i) zm(j,i)],[xm(j+1,i+1) ym(j+1,i+1) zm(j+1,i+1)]);
                        case "-z"
                            zbraces2{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j+1,i) ym(j+1,i) zm(j+1,i)],[xm(j,i+1) ym(j,i+1) zm(j,i+1)]);
                        case "x"
                            xbraces1{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j,i) ym(j,i) zm(j,i)],[xm(j+1,i+1) ym(j+1,i+1) zm(j+1,i+1)]);
                            xbraces2{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j+1,i) ym(j+1,i) zm(j+1,i)],[xm(j,i+1) ym(j,i+1) zm(j,i+1)]);
                        case "k"
                            kbraces1{j,i} = PrismP2P(visuals,fidelity,cwidth,[(xm(j,i)+xm(j,i+1))/2 (ym(j,i)+ym(j,i+1))/2 zm(j,i)],[xm(j+1,i) ym(j+1,i) zm(j+1,i)]);
                            kbraces2{j,i} = PrismP2P(visuals,fidelity,cwidth,[(xm(j,i)+xm(j,i+1))/2 (ym(j,i)+ym(j,i+1))/2 zm(j,i)],[xm(j+1,i+1) ym(j+1,i+1) zm(j+1,i+1)]);
                        case "-k"
                            kbraces1{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j,i) ym(j,i) zm(j,i)],[(xm(j+1,i)+xm(j+1,i+1))/2 (ym(j+1,i)+ym(j+1,i+1))/2 zm(j+1,i)]);
                            kbraces2{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j,i+1) ym(j,i+1) zm(j,i+1)],[(xm(j+1,i)+xm(j+1,i+1))/2 (ym(j+1,i)+ym(j+1,i+1))/2 zm(j+1,i)]);
                    end
                end
            end
            
            %             if isempty(col)
            %                 col = rand(1,3);
            %             end
            %             out(1) = surf(ax,x, y, z,'FaceColor',col,'EdgeColor','k');
            %             out(2) = patch(ax,x',y',z',col);
            out(:,1) = visuals.Children(2:2:end);
            out(:,2) = visuals.Children(1:2:end);
        end
        
        function out = TranslateCuboid(cuboid,offset)
            for i = 1:size(cuboid,1)
                cuboid(i,1).XData = cuboid(i,1).XData + offset(1);
                cuboid(i,1).YData = cuboid(i,1).YData + offset(2);
                cuboid(i,1).ZData = cuboid(i,1).ZData + offset(3);
                cuboid(i,2).XData = cuboid(i,2).XData + offset(1);
                cuboid(i,2).YData = cuboid(i,2).YData + offset(2);
                cuboid(i,2).ZData = cuboid(i,2).ZData + offset(3);
            end

            out = cuboid;
        end
    end
end