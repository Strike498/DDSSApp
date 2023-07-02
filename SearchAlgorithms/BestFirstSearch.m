function BestFirstSearch(~,~,app)
d = uiprogressdlg(app,'Title','Please Wait',...
    'Message','Optimising Campaigns...');
Projects = app.UserData;

uiSelectScenarioDrop = findobj(app,'UserData','uiSelectScenarioDrop');
scenario = uiSelectScenarioDrop.Value;

Poset = uint32(scenario.PosetGraph);
n = max(Poset,[],'All');
Available = uint32(1:n);
Sequence = uint32(zeros(1,n));

Selection = setdiff(Available,Poset(:,2));
Sequence(1) = Selection;
Available = setdiff(Available,Selection);
Poset = Poset(Poset(:,1)~=Selection,:);

vsites = 1:numel(Projects.Ports);
dsites = 1:numel(Projects.Ports);
V_S = uint32(zeros(1,n-2));
D_S = uint32(zeros(1,n-2));

store = [];
storeSeq = [];
storePoset = {};
storeAvail = {};
storeVes = {};
storevs = [];
storeds = [];
i = 2;
iter = 1;
while i < n
    d.Value = i/n;
    Candidates = setdiff(Available,Poset(:,2));
    for j = 1:numel(Candidates)
        Selection = Candidates(j);
        Sequence(i) = Selection;
        activities = scenario.Activities(Sequence(2:i)-1);
        if isempty(activities(end).ResourceOptions)
            VesselList = Projects.Vessels;
        else
            VesselList = Projects.Vessels(activities(end).ResourceOptions);
        end
        for k = 1:numel(VesselList)
            for vs = vsites
                for ds = dsites
                    V_S(i-1) = vs;
                    D_S(i-1) = ds;
                    orderVessels(i-1) = VesselList(k);
                    for q = 1:i-1
                        orderVessels(q).Site = Projects.Ports(V_S(q)).Site;
                        activities(q).Destination = Projects.Ports(D_S(q)).Site;
                    end
                    out = QuickEvalCampaign(activities,orderVessels,scenario,0,app);
                    A = setdiff(Available,Selection);
                    P = Poset(Poset(:,1)~=Selection,:);
                    C = setdiff(A,P(:,2));
                    store = [store;j,k,out/(i^2),i,numel(C)];
                    storeSeq = [storeSeq; Sequence];
                    storePoset = [storePoset;{P}];
                    storeAvail = [storeAvail;{A}];
                    storeVes = [storeVes;{orderVessels}];
                    storevs = [storevs;V_S];
                    storeds = [storeds;D_S];
                    iter = iter+1;
                end
            end
        end
    end
    [store,idx] = sortrows(store,3);
    storeSeq = storeSeq(idx,:);
    storePoset = storePoset(idx,:);
    storeAvail = storeAvail(idx,:);
    storeVes = storeVes(idx,:);
    storevs = storevs(idx,:);
    storeds = storeds(idx,:);
    
    Available = storeAvail{1,:};
    Poset = storePoset{1,:};
    Sequence = storeSeq(1,:);
    orderVessels = storeVes{1,:};
    V_S = storevs(1,:);
    D_S = storeds(1,:);
    
    i = store(1,4)+1;
    store = store(2:end,:);
    storeSeq = storeSeq(2:end,:);
    storePoset = storePoset(2:end,:);
    storeAvail = storeAvail(2:end,:);
    storeVes = storeVes(2:end,:);
    storevs = storevs(2:end,:);
    storeds = storeds(2:end,:);
end

for i = 1:numel(V_S)
    orderVessels(i).Site = Projects.Ports(V_S(i)).Site;
    activities(i).Destination = Projects.Ports(D_S(i)).Site;
end
Sequence(end) = setdiff(Available,Poset(:,2));
QuickEvalCampaign(activities,orderVessels,scenario,1,app);

% plot(uiGAGraphAxes,1,out,'x')
% hold(uiGAGraphAxes,'on')

DisplayEval(scenario,app);

close(d)
end