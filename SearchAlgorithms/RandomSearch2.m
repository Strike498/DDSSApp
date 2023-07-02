function RandomSearch2(~,~,app)
d = uiprogressdlg(app,'Title','Please Wait',...
    'Message','Optimising Campaigns...');
Projects = app.UserData;

uiSelectScenarioDrop = findobj(app,'UserData','uiSelectScenarioDrop');
scenario = uiSelectScenarioDrop.Value;
%Initial Pop
n = max(scenario.PosetGraph,[],'All');
npop = 1;
stop_crit = n+5;
count = 0;
bestfit = zeros(1,stop_crit);


pop_act = rand(npop+1,n);
pop_ves = rand(npop+1,length(scenario.Activities));
pop_site = rand(npop+1,length(scenario.Activities));
pop_des = rand(npop+1,length(scenario.Activities));

%Evaluate
POP = RandPOPerm(scenario.PosetGraph,pop_act(1,:));
activities = scenario.Activities(POP(2:end-1)-1);

for i = 1:length(activities)
    if isempty(activities(i).ResourceOptions)
        orderVessels(i) = Projects.Vessels(ceil(pop_ves(1,i)*numel(Projects.Vessels)));
    else
        idx = ceil(pop_ves(1,i)*numel(activities(i).ResourceOptions));
        orderVessels(i) = Projects.Vessels(activities(i).ResourceOptions(idx));
    end
    orderVessels(i).Site = Projects.Ports(ceil(pop_site(1,i)*numel(Projects.Ports))).Site;
    activities(i).Destination = Projects.Ports(ceil(pop_des(1,i)*numel(Projects.Ports))).Site;
end

fitness(1) = QuickEvalCampaign(activities,orderVessels,scenario,0,app);
iter = 1;
while count < stop_crit
    d.Value = count/stop_crit;
    fitness_old = fitness(1);
    pop_act(2,:) = rand(1,size(pop_act,2));
    pop_ves(2,:) = rand(1,size(pop_ves,2));
    pop_site(2,:) = rand(1,length(scenario.Activities));
    pop_des(2,:) = rand(1,length(scenario.Activities));
    
    POP = RandPOPerm(scenario.PosetGraph,pop_act(1,:));
    activities = scenario.Activities(POP(2:end-1)-1);
    
    for i = 1:length(activities)
        if isempty(activities(i).ResourceOptions)
            orderVessels(i) = Projects.Vessels(ceil(pop_ves(1,i)*numel(Projects.Vessels)));
        else
            idx = ceil(pop_ves(1,i)*numel(activities(i).ResourceOptions));
            orderVessels(i) = Projects.Vessels(activities(i).ResourceOptions(idx));
        end
        orderVessels(i).Site =Projects.Ports(ceil(pop_site(1,i)*numel(Projects.Ports))).Site;
        activities(i).Destination = Projects.Ports(ceil(pop_des(1,i)*numel(Projects.Ports))).Site;
    end
    
    fitness(2) = QuickEvalCampaign(activities,orderVessels,scenario,0,app);
    [fitness,idx] = sort(fitness);
    
    pop_act = pop_act(idx,:);
    pop_ves = pop_ves(idx,:);
    
    pop_act = pop_act(1:npop,:);
    pop_ves = pop_ves(1:npop,:);
    fitness = fitness(1:npop);
    
    bestfit(iter) = fitness(1);
    
    if fitness(1) == fitness_old
        count = count+1;
    else
        count = 0;
    end
    iter = iter+1;
end
QuickEvalCampaign(activities,orderVessels,scenario,1,app);

DisplayEval(scenario,app);

close(d)
end