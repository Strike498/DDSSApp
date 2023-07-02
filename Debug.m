clear; clc; close all;
load('Debug.mat')
campAct = campActF;

for i = 1:length(campAct)
    campAct(i).ResourceAssignment = orderVesselsF(i);
end

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
            pvid = campAct(j).ResourceAssignment == vessels;
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
disp('hi')