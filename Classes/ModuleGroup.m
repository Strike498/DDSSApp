classdef ModuleGroup < Unit
    %Module Group
    %   Detailed explanation goes here
    
    properties
        Project
        ID int32
        Name
        Members
        Timeline int32
        Site
        Connection
        Scenario
        Length
        Width
        Height
        Mass
        MaxDepth
        MaxCloseness
        MaxOrder
        AllNeighbours
        Activities
        Color
        GraphicObj
        Destination
        CoG
        Origin
        LiftPoints
    end
    
    methods
        function obj = ModuleGroup(varargin)
            if nargin > 0
                for i = 1:2:nargin
                    set(obj,varargin{i},varargin{i+1})
                end
                obj.ID = obj.Project.NID+1;
                obj.Project.NID =  obj.Project.NID+1;
                obj.Project.Objects{obj.ID} = obj;
                obj = FindSize(obj);
                obj = FindMass(obj);
                obj = FindMaxDepth(obj);
                obj.Color = rand(1,3);
                obj.Name = strcat("Module Group ",string(length(obj.Project.ModuleGroups)+1));
                obj.Destination = obj.Members(1).Destination;
                obj.Site = obj.Members(1).Site;
                obj = FindCoG(obj);
            end
        end
        function CreateLiftActivities(ModuleGroups,Projects)
            boxes = [[Projects.Vessels.FreeDeckArea]./[Projects.Vessels.Beam]; Projects.Vessels.Beam]';
            
            for i = 1:length(ModuleGroups)
                if length(Projects.Activities)==57
                    keyboard
                end
                test1 = sum(boxes - [ModuleGroups.Length ModuleGroups.Width]>0,2)>1;
                test2 = sum(boxes - [ModuleGroups.Width ModuleGroups.Length]>0,2)>1;
                test = find(or(test1,test2));
                Projects.Activities(end+1) = Activity('Project',Projects,...
                    'Type',"Lift",...
                    'LiftMethod',"Crane Lift",...
                    'ResourceOptions',test,...
                    'LiftTarget',ModuleGroups(i));
                ModuleGroups(i).Activities = Projects.Activities(end);
            end
        end
        function [check,moduleGroup] = FindModuleGroups(list,source)
            %             test = findobj(list,'Members',source);
            if isempty(list)
                check = 0;
                moduleGroup = [];
            else
                test = zeros(1,length(list));
                sourceIdx = [source.ID];
                for i = 1:length(list)
                    listMem = list(i).Members;
                    listIdx = [listMem.ID];
                    if length(listIdx) == length(sourceIdx)
                        test(i) = all(listIdx == sourceIdx);
                    end
                end
                %                 for i = 1:length(list)
                %                     if length(list(i).Members) == length(source)
                %                         test(i) = all(ismember(list(i).Members,source));
                %                     end
                %                 end
                if any(test)
                    check = 1;
                    moduleGroup = list(logical(test));
                else
                    check = 0;
                    moduleGroup = [];
                end
            end
        end
        function obj = FindSize(obj)
            graphics = [obj.Members.GraphicObj];
            graphics = graphics(2:2:end);
            lengthData = reshape([graphics.XData],[1,numel([graphics.XData])]);
            widthData = reshape([graphics.YData],[1,numel([graphics.YData])]);
            heightData = reshape([graphics.ZData],[1,numel([graphics.ZData])]);
            obj.Length = max(lengthData)-min(lengthData);
            obj.Width = max(widthData)-min(widthData);
            obj.Height = max(heightData)-min(heightData);
        end
        function obj = FindMass(obj)
            obj.Mass = sum([obj.Members.Mass]);
        end
        function ColorMembers(obj,color)
            for i = 1:length(obj.Members)
                obj.Members(i).GraphicObj(1).FaceColor = color;
                obj.Members(i).GraphicObj(2).FaceColor = color;
            end
        end
        function AssignColors(obj)
            colors = hsv(length(obj));
            for i = 1:length(obj)
                obj(i).Color = colors(i,:);
            end
        end
        function obj = FindMaxDepth(obj)
            obj.MaxDepth = max([obj.Members.Depth]);
            [obj.MaxCloseness,~] = max([obj.Members.Closeness]);
            [obj.MaxOrder,I] = max([obj.Members.Order]);
            obj.AllNeighbours = [obj.Members(I).Neighbours];
            
        end
        function obj = FindCoG(obj)
            members = obj.Members;
            masses = [members.Mass];
            origins = reshape([members.Origin],3,length(members))';
            Gx = sum(origins(:,1)'.*masses)/sum(masses);
            Gy = sum(origins(:,2)'.*masses)/sum(masses);
            Gz = sum(origins(:,3)'.*masses)/sum(masses);
            obj.CoG = [Gx,Gy,Gz];
            obj.Origin = mean(origins,1);
            
            LWH = [[members.Length]' [members.Width]' [members.Height]'];
            %             figure
            %             plot(Gx,Gy,'ro')
            %             hold on
            for i = 1:size(members,2)
                LTop(i) = origins(i,1)+LWH(i,1)/2;
                LBot(i) = origins(i,1)-LWH(i,1)/2;
                WTop(i) = origins(i,2)+LWH(i,2)/2;
                WBot(i) = origins(i,2)-LWH(i,2)/2;
                HTop(i) = origins(i,3)+LWH(i,3)/2;
                HBot(i) = origins(i,3)-LWH(i,3)/2;
                LenCo(i,:) = [LTop(i) LBot(i) LBot(i) LTop(i) LTop(i)];
                WidCo(i,:) = [WTop(i) WTop(i) WBot(i) WBot(i) WTop(i)];
                %                 plot(LenCo(i,:),WidCo(i,:),'k')
                %                 plot(origins(i,1),origins(i,2),'ko')
            end
            %             axis equal
            
            [~,idx] = sort(HTop,'descend');
            Rx = [max(LTop) min(LBot)];
            Ry = [max(WTop) min(WBot)];
            Nx = floor(min(abs(Rx-Gx)));
            Ny = floor(min(abs(Ry-Gy)));
            Dis = min([Nx Ny]);
            for i = Dis:-1:1
                coordx = [Gx+i Gx-i Gx-i Gx+i];
                coordy = [Gy+i Gy+i Gy-i Gy-i];
                hit = false(1,4);
                store = zeros(1,4);
                coordz = zeros(1,4);
                for j = idx
                    for k = 1:4
                        h = inpolygon(coordx(k),coordy(k),LenCo(j,:),WidCo(j,:));
                        if h && hit(k)~= true
                            hit(k) = h;
                            store(k) = j;
                            coordz(k) = HTop(j);
                        end
                    end
                end
                if all(hit) && max(coordz)-min(coordz)<1
                    obj.LiftPoints = [coordx;coordy;coordz]';
                    break
                end
                %                 if i == 1
                %                     lenTop = obj.Origin(1)+obj.Length/2;
                %                     lenBot = obj.Origin(1)-obj.Length/2;
                %                     widTop = obj.Origin(2)+obj.Width/2;
                %                     widBot = obj.Origin(2)-obj.Width/2;
                %                     minLen = min(abs([lenTop lenBot]-obj.CoG(1)));
                %                     minWid = min(abs([widTop widBot]-obj.CoG(2)));
                %                     minSq = min([minLen,minWid]);
                %                     obj.LiftPoints =   [Gx+minSq,Gy+minSq,Gz+obj.Height/2;...
                %                         Gx-minSq,Gy+minSq,Gz+obj.Height/2;...
                %                         Gx-minSq,Gy-minSq,Gz+obj.Height/2;...
                %                         Gx+minSq,Gy-minSq,Gz+obj.Height/2];
                %                 end
            end
            bestArea = 0;
            bestZrange = obj.Height;
%             if obj.ID == 94
%                 disp('94')
%             end
            if i == 1
                for i = Nx:-0.5:1
                    for n = Ny:-0.5:1
                        coordx = [Gx+i Gx-i Gx-i Gx+i];
                        coordy = [Gy+n Gy+n Gy-n Gy-n];
                        hit = false(1,4);
                        store = zeros(1,4);
                        coordz = zeros(1,4);
                        for j = idx
                            for k = 1:4
                                h = inpolygon(coordx(k),coordy(k),LenCo(j,:),WidCo(j,:));
                                if h && hit(k)~= true
                                    hit(k) = h;
                                    store(k) = j;
                                    coordz(k) = HTop(j);
                                end
                            end
                        end
                        if all(hit) && (max(coordz)-min(coordz))<bestZrange
%                             if (max(coordx)-min(coordx))*(max(coordy)-min(coordy))>bestArea
                                best = [coordx;coordy;coordz]';
                                bestArea = (max(coordx)-min(coordx))*(max(coordy)-min(coordy));
                                bestZrange = (max(coordz)-min(coordz));
                                %                             obj.LiftPoints = [coordx;coordy;coordz]';
                                %                             break
%                             end
                        end
                    end
                end
                obj.LiftPoints = best;
            end
            
            %             plot(coordx,coordy,'mo')
        end
    end
end

