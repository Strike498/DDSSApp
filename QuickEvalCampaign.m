function Out = QuickEvalCampaign(activities,orderVessels,scenario,saveflag,app)
Projects = app.UserData;
if isempty(Projects.transportMap)
    Projects.transportMap = containers.Map();
end
transportMap = Projects.transportMap;
if isempty(Projects.campaignMap)
    Projects.campaignMap = containers.Map();
end
campaignMap = Projects.campaignMap;

orderCats = [activities.Type];

campAct = Activity.empty;
orderVesselsF = Vessel.empty;
activeVessels = Vessel.empty;
inactiveVessels = unique(orderVessels,'stable');
for i = 1:length(inactiveVessels)
    inactiveVessels(i).Site = inactiveVessels(i).StartSite; 
end

for i = 1:length(activities)
    if ismember(orderVessels(i),activeVessels)
        campAct = [campAct, activities(i)];
        orderVesselsF = [orderVesselsF, orderVessels(i)];
    else
        %Mobilise
        orderVesselsF = [orderVesselsF, orderVessels(i), orderVessels(i)];
        activeVessels = [activeVessels, orderVessels(i)];
        inactiveVessels = setdiff(inactiveVessels,activeVessels);
        check = isKey(transportMap,char(strjoin([{orderVessels(i).Site.Name},{activities(i).Site.Name},orderVessels(i).Name(:)'])));
        if check
            currAct = transportMap(char(strjoin([{orderVessels(i).Site.Name},{activities(i).Site.Name},orderVessels(i).Name(:)'])));
        else
            Projects.Activities(end+1) = Activity('Project',Projects,...
                'Type',"Mobilise",...
                'StartSite',orderVesselsF(i).Site,...
                'EndSite',activities(i).Site,...
                'ResourceAssignment',orderVessels(i));%Deploy
            transportMap(char(strjoin([{orderVessels(i).Site.Name},{activities(i).Site.Name},orderVessels(i).Name(:)']))) = Projects.Activities(end);
            currAct = Projects.Activities(end);
        end
        campAct = [campAct, currAct, activities(i)];
        
        
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
            orderVesselsF(i).Site = activities(i).Destination;
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

for i = 1:length(campAct)
    campAct(i).ResourceAssignment = orderVesselsF(i);
    campAct(i) = campAct(i).CalculateTime;
    campAct(i) = campAct(i).CalculateCost;
    campAct(i) = campAct(i).CalculateEmissions;
end

campActF = Activity.empty;
orderVesselsF2 = Vessel.empty;
activeVessels = Vessel.empty;
inactiveVessels = unique(orderVesselsF,'stable');
orderCatsF = [campAct.Type];

for i = 1:length(campAct)
    if orderCatsF(i) == "Mobilise"
        campActF = [campActF, campAct(i)];
        orderVesselsF2 = [orderVesselsF2, orderVesselsF(i)];
        activeVessels = [activeVessels, orderVesselsF(i)];
        inactiveVessels = setdiff(inactiveVessels,activeVessels);
        continue
    elseif orderCatsF(i) == "Demobilise"
        campActF = [campActF, campAct(i)];
        orderVesselsF2 = [orderVesselsF2, orderVesselsF(i)];
        inactiveVessels = [inactiveVessels, orderVesselsF(i)];
        activeVessels = setdiff(activeVessels,inactiveVessels);
        continue
    elseif ismember(orderVesselsF(i),activeVessels)
        ID = find(orderVesselsF == orderVesselsF(i));
        ID = ID(ID>=i);
        if sum([campAct(ID(1)+1:ID(2)-1).Time])>orderVesselsF(i).MinRentalPeriod*24
            check = isKey(transportMap,char(strjoin([{campAct(i).Site.Name},{orderVesselsF(i).Site.Name},orderVesselsF(i).Name(:)'])));
            if check
                currAct = transportMap(char(strjoin([{campAct(i).Site.Name},{orderVesselsF(i).Site.Name},orderVesselsF(i).Name(:)'])));
            else
                Projects.Activities(end+1) = Activity('Project',Projects,...
                    'Type',"Demobilise",...
                    'StartSite',campAct(i).Site,...
                    'EndSite',orderVesselsF(i).Site,...
                    'ResourceAssignment',orderVesselsF(i));
                transportMap(char(strjoin([{campAct(i).Site.Name},{orderVesselsF(i).Site.Name},orderVesselsF(i).Name(:)']))) = Projects.Activities(end);
                currAct = Projects.Activities(end);
                currAct = currAct.CalculateTime;
                currAct = currAct.CalculateCost;
                currAct = currAct.CalculateEmissions;
            end
            campActF = [campActF, campAct(i), currAct];
            orderVesselsF2 = [orderVesselsF2, orderVesselsF(i), orderVesselsF(i)];
            inactiveVessels = [inactiveVessels, orderVesselsF(i)];
            activeVessels = setdiff(activeVessels,inactiveVessels);
        else
            campActF = [campActF, campAct(i)];
            orderVesselsF2 = [orderVesselsF2, orderVesselsF(i)];
        end
    else
        check = isKey(transportMap,char(strjoin([{orderVesselsF(i).Site.Name},{campAct(i).Site.Name},orderVesselsF(i).Name(:)'])));
        if check
            currAct = transportMap(char(strjoin([{orderVesselsF(i).Site.Name},{campAct(i).Site.Name},orderVesselsF(i).Name(:)'])));
        else
            Projects.Activities(end+1) = Activity('Project',Projects,...
                'Type',"Mobilise",...
                'StartSite',orderVesselsF(i).Site,...
                'EndSite',campAct(i).Site,...
                'ResourceAssignment',orderVesselsF(i));
            transportMap(char(strjoin([{orderVesselsF(i).Site.Name},{campAct(i).Site.Name},orderVesselsF(i).Name(:)']))) = Projects.Activities(end);
            currAct = Projects.Activities(end);
            currAct = currAct.CalculateTime;
            currAct = currAct.CalculateCost;
            currAct = currAct.CalculateEmissions;
        end
        campActF = [campActF, currAct, campAct(i)];
        orderVesselsF2 = [orderVesselsF2, orderVesselsF(i), orderVesselsF(i)];
        activeVessels = [activeVessels, orderVesselsF(i)];
        inactiveVessels = setdiff(inactiveVessels,activeVessels);
    end
end

campAct = campActF;
orderVesselsF = orderVesselsF2;

for i = 1:length(campAct)
    campAct(i).ResourceAssignment = orderVesselsF(i);
end
% if length(Projects.Campaigns)==4
%     keyboard
% end

vessels = unique(orderVesselsF,'stable');
gantt = zeros(length(vessels),ceil(sum(ceil([campAct.Time]))/24)+length(campAct));
ganttfz = zeros(length(vessels),1);
[~,Locb] = ismember(scenario.Activities,campAct);
poset = scenario.PosetGraph;
poset = poset(poset(:,1)>1,:);
poset = poset(poset(:,2)<length(scenario.Activities)+2,:)-1;
poset = Locb(poset);
for i = 1:length(campAct)
    
    vid = campAct(i).ResourceAssignment == vessels;
    pred = poset(poset(:,2)==i,1);
    
    if isempty(pred)
        if ganttfz(vid',1) == 0 && sum(ganttfz)>0
            start = max(ganttfz)-ceil(campAct(i).Time/24);
            if start <= 0
                start = 1;
            end
        else
            start = find(max(cumsum(gantt(vid,:)>0))==cumsum(gantt(vid,:)>0),1)+1;
        end
        %na = find(sum(gantt,1)>0,1,'last')-ceil(campAct(i).Time/24)+1;
        %start = max([nz na]);
        if start == 2
            start = 1;
        end
    else
        k = 1;
        incr = 0;
        for j = pred'
            search = true;
            while search == true
                step = ganttfz(vid,1)+incr;
                if any(gantt(:,step:end) == j,'all')
                    incr = incr+1;
                else
                    search = false;
                end
            end
            c(k) = step;
            k = k+1;
        end
        start = max(c);
    end
    finish = start+ceil(campAct(i).Time/24)-1;
    while sum(gantt(vid,start:finish))>0
        start = start+1;
        finish = finish+1;
    end
    gantt(vid,start:finish) = i;
    ganttfz(vid',1) = finish+1;
    clear c
end

% slack_list = setdiff(1:length(campAct),unique(poset(:,2)));
% for i = 1:length(slack_list)
%     [row,col] = find(gantt==slack_list(i));
%     start = min(col);
%     finish = max(col);
%     rmid = round(find(gantt(row(1),:)>0,1)+(find(gantt(row(1),:)>0,1,'last')-find(gantt(row(1),:)>0,1))/2);
%     amid = round(start+(finish-start)/2);
%     if amid < rmid
%         
%     end
% end
fidx = find(sum(gantt,1)>0,1,'last');
gantt = gantt(:,1:fidx);
Resource_Usage = gantt';
Resource_Rental = Resource_Usage.*0;
for r = 1:length(vessels)
    b_ind = find(diff([false,Resource_Usage(:,r)'>0,false])~=0); %Find all important indexes
    Resource_Rental(b_ind(1):b_ind(end)-1,r) = 1; %Set Rent on from start to end of activities
    d_gap = Resource_Usage(1:b_ind(end)-1,r)==0; %Find gaps in the resource usage
    d_ind = find(diff([false,d_gap'>0,false])~=0); %Find index of gaps
    for i = 1:2:length(d_ind) %for each gap
        if d_ind(i+1)-d_ind(i)>= vessels(r).MinDowntime %if length of gap is greater than or equal to vessel min downtime
             if ~isempty(find(b_ind==d_ind(i),1)) && b_ind(find(b_ind==d_ind(i+1),1)+1)-b_ind(find(b_ind==d_ind(i+1),1))>= vessels(r).MinRentalPeriod
                 E_d = max(b_ind(find(b_ind==d_ind(i),1)-1)+vessels(r).MinRentalPeriod,b_ind(find(b_ind==d_ind(i),1)));
                 Resource_Rental(E_d:d_ind(i+1)-1,r)=0; %add gap                
             end
        end
    end
    b_ind = find(diff([false,Resource_Rental(:,r)'>0,false])~=0); %Find all important indexes
    if b_ind(end)-b_ind(end-1)<vessels(r).MinRentalPeriod %if rental period is less than min
        E_b = b_ind(end-1)+vessels(r).MinRentalPeriod-1; 
        S_b = max(1,b_ind(end-1)-vessels(r).MinRentalPeriod-1)+vessels(r).MinRentalPeriod-1;
        if median(1:fidx)<median(b_ind(end-1):E_b)
            Resource_Rental(max(1,b_ind(end-1)-vessels(r).MinRentalPeriod-1):S_b,r)=1; %add shifted back rental
        else
            Resource_Rental(b_ind(end-1):E_b,r)=1; %add shifted forward rental
        end
    end
end

[gap, gap_act] = GanttData(gantt',length(vessels),(0:length(campAct)));
[rgap,rgap_act] = GanttData(Resource_Rental,length(vessels),(0:1));

if size(gap,2)==1
    
end



%Create Campaign
if saveflag 
    check = isKey(campaignMap,char(strjoin([campAct.Name,orderVesselsF.Name])));
    if check
        currCamp = campaignMap(char(strjoin([campAct.Name,orderVesselsF.Name])));
        if ~ismember(currCamp,scenario.Campaigns)
            scenario.Campaigns = [scenario.Campaigns currCamp];
        end
    else
        currCamp = Campaign('Project',Projects,...
            'Activities',campAct,...
            'Time',fidx,...
            'WorkTime',sum([campAct.Time]),...
            'Cost',sum([campAct.Cost]),...
            'CO2',sum([campAct.CO2]),...
            'NOx',sum([campAct.NOx]),...
            'SOx',sum([campAct.SOx]),...
            'PM',sum([campAct.PM]),...
            'CH4',sum([campAct.CH4]),...
            'Gap',gap,...
            'Gap_Act',gap_act,...
            'RGap',rgap,...
            'RGap_Act',rgap_act,...
            'FuelConsumption',sum([campAct.FuelConsumption]),...
            'ResourceAssignment',orderVesselsF);
        Projects.Campaigns(end+1) = currCamp;
        scenario.Campaigns = [scenario.Campaigns currCamp];
        campaignMap(char(strjoin([campAct.Name,orderVesselsF.Name]))) = currCamp;
    end
end

Out = fidx*sum([campAct.Cost])*sum([campAct.CO2])*sum([campAct.NOx])*sum([campAct.SOx])*sum([campAct.PM])*sum([campAct.CH4]);

end