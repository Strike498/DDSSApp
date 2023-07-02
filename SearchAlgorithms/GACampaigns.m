function GACampaigns(~,~,app)
d = uiprogressdlg(app,'Title','Please Wait',...
        'Message','Optimising Campaigns...');
Projects = app.UserData;

uiSelectScenarioDrop = findobj(app,'UserData','uiSelectScenarioDrop');
scenario = uiSelectScenarioDrop.Value;

npop = 100;
ngen = 10;
crossrate = 0.8;
mchance = 0.02;

fitness = zeros(1,npop);
bestfit = zeros(1,ngen);
meanfit = zeros(1,ngen);

%Initial Pop
n = max(scenario.PosetGraph,[],'All');
pop_act = rand(npop,n);
pop_ves = rand(npop,length(scenario.Activities));
pop_site = rand(npop+1,length(scenario.Activities));
pop_des = rand(npop+1,length(scenario.Activities));

%Evaluate
for j = 1:npop
    d.Value = 0.5*j/npop;
    POP = RandPOPerm(scenario.PosetGraph,pop_act(j,:));
    activities = scenario.Activities(POP(2:end-1)-1);
    orderVessels = Vessel.empty;
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
    fitness(j) = QuickEvalCampaign(activities,orderVessels,scenario,0,app);
end

[fitness,idx] = sort(fitness);

pop_act = pop_act(idx,:);
pop_ves = pop_ves(idx,:);
pop_site = pop_site(idx,:);
pop_des = pop_des(idx,:);
for j = 1:ngen
d.Value = 0.5+0.5*j/ngen;
select_prob = cumsum((1./fitness)./sum(1./fitness));

roll = rand(2,round(crossrate*npop));
% c_act = rand(size(roll,2),size(pop_act,2));
% c_ves = rand(size(roll,2),size(pop_ves,2));
c_act = zeros(size(roll,2),size(pop_act,2));
c_ves = zeros(size(roll,2),size(pop_ves,2));
c_site = zeros(size(roll,2),size(pop_site,2));
c_des = zeros(size(roll,2),size(pop_des,2));
parent_1 = zeros(1,size(roll,2));
parent_2 = parent_1;
for i = 1:size(roll,2)
[~,parent_1(i)] = min(abs(select_prob-roll(1,i)));
[~,parent_2(i)] = min(abs(select_prob-roll(2,i)));

gene_cut = randi([2 size(pop_act,2)-1]);
c_act(i,1:gene_cut) = pop_act(parent_1(i),1:gene_cut);
c_act(i,gene_cut+1:size(pop_act,2)) = pop_act(parent_2(i),gene_cut+1:end);

gene_cut = randi([1 size(pop_ves,2)-1]);
c_ves(i,1:gene_cut) = pop_ves(parent_1(i),1:gene_cut);
c_ves(i,gene_cut+1:size(pop_ves,2)) = pop_ves(parent_2(i),gene_cut+1:end);

gene_cut = randi([1 size(pop_site,2)-1]);
c_site(i,1:gene_cut) = pop_site(parent_1(i),1:gene_cut);
c_site(i,gene_cut+1:size(pop_site,2)) = pop_site(parent_2(i),gene_cut+1:end);

gene_cut = randi([1 size(pop_des,2)-1]);
c_des(i,1:gene_cut) = pop_des(parent_1(i),1:gene_cut);
c_des(i,gene_cut+1:size(pop_des,2)) = pop_des(parent_2(i),gene_cut+1:end);

mroll = rand;
if mroll<mchance
    type = randi([0 1],1,4);
    if type(1)
        c_act(i,randi([1 size(c_act,2)])) = rand;
    end
    if type(2)
        c_ves(i,randi([1 size(c_ves,2)])) = rand;
    end
    if type(3)
        c_site(i,randi([1 size(c_site,2)])) = rand;
    end
    if type(4)
        c_des(i,randi([1 size(c_ves,2)])) = rand;
    end
end
POP = RandPOPerm(scenario.PosetGraph,c_act(i,:));
activities = scenario.Activities(POP(2:end-1)-1);
orderVessels = Vessel.empty;
for k = 1:length(activities)
    if isempty(activities(k).ResourceOptions)
        orderVessels(k) = Projects.Vessels(ceil(c_ves(1,k)*numel(Projects.Vessels)));
    else
        idx = ceil(c_ves(1,k)*numel(activities(k).ResourceOptions));
        orderVessels(k) = Projects.Vessels(activities(k).ResourceOptions(idx));
    end
    orderVessels(k).Site = Projects.Ports(ceil(c_site(1,k)*numel(Projects.Ports))).Site;
    activities(k).Destination = Projects.Ports(ceil(c_des(1,k)*numel(Projects.Ports))).Site;
end
fitness(npop+1) = QuickEvalCampaign(activities,orderVessels,scenario,0,app);
end
[fitness,idx] = sort(fitness);
pop_act = [pop_act;c_act];
pop_ves = [pop_ves;c_ves];
pop_site = [pop_site;c_site];
pop_des = [pop_des;c_des];
pop_act = pop_act(idx,:);
pop_ves = pop_ves(idx,:);
pop_site = pop_site(idx,:);
pop_des = pop_des(idx,:);

pop_act = pop_act(1:npop,:);
pop_ves = pop_ves(1:npop,:);
pop_site = pop_site(1:npop,:);
pop_des = pop_des(1:npop,:);
fitness = fitness(1:npop);

bestfit(j) = fitness(1);
meanfit(j) = mean(fitness);

end

% plot(uiGAGraphAxes,1:j,bestfit(1:j),'-')
% hold(uiGAGraphAxes,'on')
% plot(uiGAGraphAxes,1:j,meanfit(1:j),'--')
% grid(uiGAGraphAxes,'on')

% figure
% plot(1:j,bestfit(1:j),'-')
% hold on
% plot(1:j,meanfit(1:j),'-')

POP = RandPOPerm(scenario.PosetGraph,pop_act(1,:));
activities = scenario.Activities(POP(2:end-1)-1);
orderVessels = Vessel.empty;
for k = 1:length(activities)
    if isempty(activities(k).ResourceOptions)
        orderVessels(k) = Projects.Vessels(ceil(pop_ves(1,k)*numel(Projects.Vessels)));
    else
        idx = ceil(pop_ves(1,k)*numel(activities(k).ResourceOptions));
        orderVessels(k) = Projects.Vessels(activities(k).ResourceOptions(idx));
    end
    orderVessels(k).Site = Projects.Ports(ceil(pop_site(1,k)*numel(Projects.Ports))).Site;
    activities(k).Destination = Projects.Ports(ceil(pop_des(1,k)*numel(Projects.Ports))).Site;
end

QuickEvalCampaign(activities,orderVessels,scenario,1,app);
DisplayEval(scenario,app);

close(d)


end