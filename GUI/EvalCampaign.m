function Out = EvalCampaign(poset,pop_act,pop_ves,scenario,app)
Projects = app.UserData;
if isempty(Projects.transportMap)
    Projects.transportMap = containers.Map();
end
transportMap = Projects.transportMap;

POP = RandPOPerm(poset,pop_act);
cats = [scenario.Activities.Type];
orderCats = cats(POP(2:end-1)-1);
activities = scenario.Activities(POP(2:end-1)-1);

for i = 1:length(activities)
    if isempty(activities(i).ResourceOptions)
        orderVessels(i) = Projects.Vessels(ceil(pop_ves(i)*numel(Projects.Vessels)));
    else
        idx = ceil(pop_ves(i)*numel(activities(i).ResourceOptions));
        orderVessels(i) = Projects.Vessels(activities(i).ResourceOptions(idx));
    end
end

campAct = Activity.empty;
orderVesselsF = Vessel.empty;
activeVessels = Vessel.empty;
inactiveVessels = unique(orderVessels,'stable');

for i = 1:length(activities)
    if ismember(orderVessels(i),activeVessels)
        campAct = [campAct, activities(i)];
        orderVesselsF = [orderVesselsF, orderVessels(i)];
    else
        %Mobilise
        check = isKey(transportMap,char(strjoin([{orderVessels(i).Site.Name},{activities(i).Site.Name},orderVessels(i).Name(:)'])));
        if check
            currAct = transportMap(char(strjoin([{orderVessels(i).Site.Name},{activities(i).Site.Name},orderVessels(i).Name(:)'])));
        else
            Projects.Activities(end+1) = Activity('Project',Projects,...
                'Type',"Mobilise",...
                'StartSite',orderVessels(i).Site,...
                'EndSite',activities(i).Site,...
                'ResourceAssignment',orderVessels(i));%Deploy
            transportMap(char(strjoin([{orderVessels(i).Site.Name},{activities(i).Site.Name},orderVessels(i).Name(:)']))) = Projects.Activities(end);
            currAct = Projects.Activities(end);
        end
        campAct = [campAct, currAct, activities(i)];
        orderVesselsF = [orderVesselsF, orderVessels(i), orderVessels(i)];
        activeVessels = [activeVessels, orderVessels(i)];
        inactiveVessels = setdiff(inactiveVessels,activeVessels);
    end
    if orderCats(i) == "Lift"
        box = [[orderVessels(i).FreeDeckArea]./[orderVessels(i).Beam]; orderVessels(i).Beam]';
        liftID = find((orderCats=="Lift").*(orderVessels == orderVessels(i)));
        liftID = liftID(liftID>=i);
        if numel(liftID)>2
            liftID = liftID(1:2);
        end
        liftgroup = activities(liftID);
        packages = [orderVessels(i).Packages, [liftgroup.LiftTarget]];
        packages = [[packages.Length];[packages.Width]]';
        [best, ~] = RectangularPacking(box,packages);
        if best > 1 || numel(liftID) == 1
            %Demobilise
            check = isKey(transportMap,char(strjoin([{activities(i).Site.Name},{activities(i).Destination.Name},orderVessels(i).Name(:)'])));
            if check
                currAct = transportMap(char(strjoin([{activities(i).Site.Name},{activities(i).Destination.Name},orderVessels(i).Name(:)'])));
            else
                Projects.Activities(end+1) = Activity('Project',Projects,...
                    'Type',"Demobilise",...
                    'StartSite',activities(i).Site,...
                    'EndSite',activities(i).Destination,...
                    'ResourceAssignment',orderVessels(i));%Deploy
                transportMap(char(strjoin([{activities(i).Site.Name},{activities(i).Destination.Name},orderVessels(i).Name(:)']))) = Projects.Activities(end);
                currAct = Projects.Activities(end);
            end
            campAct = [campAct, currAct];
            orderVesselsF = [orderVesselsF, orderVessels(i)];
            inactiveVessels = [inactiveVessels, orderVessels(i)];
            activeVessels = setdiff(activeVessels,inactiveVessels);
            orderVessels(i).Packages = ModuleGroup.empty;
        else
            orderVessels(i).Packages = [orderVessels(i).Packages, activities(i).LiftTarget];
        end
    else
        ID = find(orderVessels == orderVessels(i))';
        ID = ID(ID>=i);
        if numel(ID) == 1
            %Final Demobilise
            check = isKey(transportMap,char(strjoin([{activities(i).Site.Name},{orderVessels(i).Site.Name},orderVessels(i).Name(:)'])));
            if check
                currAct = transportMap(char(strjoin([{activities(i).Site.Name},{orderVessels(i).Site.Name},orderVessels(i).Name(:)'])));
            else
                Projects.Activities(end+1) = Activity('Project',Projects,...
                    'Type',"Demobilise",...
                    'StartSite',activities(i).Site,...
                    'EndSite',orderVessels(i).Site,...
                    'ResourceAssignment',orderVessels(i));
                transportMap(char(strjoin([{activities(i).Site.Name},{orderVessels(i).Site.Name},orderVessels(i).Name(:)']))) = Projects.Activities(end);
                currAct = Projects.Activities(end);
            end
            campAct = [campAct, currAct];
            orderVesselsF = [orderVesselsF, orderVessels(i)];
            inactivetemp = [inactiveVessels, orderVessels(i)];
            inactiveVessels = inactivetemp;
            activeVessels = setdiff(activeVessels,inactiveVessels);
        end
    end
end

%Create Campaign


for i = 1:length(campAct)
    campAct(i).ResourceAssignment = orderVesselsF(i);
    campAct(i) = campAct(i).CalculateTime;
    campAct(i) = campAct(i).CalculateCost;
end

Projects.Campaigns(end+1) = Campaign('Project',Projects,...
    'Activities',campAct,...
    'Time',sum([campAct.Time]),...
    'Cost',sum([campAct.Cost]),...
    'ResourceAssignment',orderVesselsF);

scenario.Campaigns = [scenario.Campaigns Projects.Campaigns(end)];

Out = sum([campAct.Time])*sum([campAct.Cost]);

end