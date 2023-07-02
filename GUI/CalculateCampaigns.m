function CalculateCampaigns(~,~,app)
d = uiprogressdlg(app,'Title','Please Wait',...
    'Message','Calculating Campaigns...');
Projects = app.UserData;
uiSelectScenarioDrop = findobj(app,'UserData','uiSelectScenarioDrop');
scenario = uiSelectScenarioDrop.Value;

%[POPList,NPOPerm] = POPerms(scenario.PosetGraph);
NPOPerm = 1;
n = max(scenario.PosetGraph,[],'All');
pop_act = rand(1,n);
POPList = RandPOPerm(scenario.PosetGraph,pop_act(1,:));

SActivities = scenario.Activities;
Lidx = find([SActivities.Type]==categorical("Lift"));

%Lperms = permn(1:length(Projects.Ports),length(Lidx));
% Lperms = [ceil(rand(500,length(Lidx)).*length(Projects.Ports));ones(1,length(Lidx)).*(1:length(Projects.Ports))'];
Lperms = ones(1,length(Lidx)).*(1:length(Projects.Ports))';

campList = Campaign.empty(0,NPOPerm);
out = zeros(1,NPOPerm*length(Lperms));
count = 1; 
for i = 1:NPOPerm
    d.Value = i/NPOPerm;
    for j = 1:size(Lperms,1)
        kc = 1;
        for k = Lidx
            SActivities(k).Destination = Projects.Ports(Lperms(j,kc)).Site;
            kc = kc + 1;
        end
        activities = SActivities(POPList(i,2:end-1)-1);
        orderVessels = scenario.ResourceAssignment(POPList(i,2:end-1)-1)';
        
        QuickEvalCampaign(activities,orderVessels,scenario,1,app);
        campList(count) = scenario.Campaigns(end);
        out(count) = campList(count).Time*campList(count).Cost;
        count = count + 1; 
    end
end
% plot(uiGAGraphAxes,1:NPOPerm,out,'ro')
% hold(uiGAGraphAxes,'on')

DisplayEval(scenario,app);

close(d)
end