function OptScenarios(~,~,app)
rng("shuffle")
Projects = app.UserData;
uiSelectScenarioDrop = findobj(app,'UserData','uiSelectScenarioDrop');
uiOptGraphAxes = findobj(app,'UserData','uiOptGraphAxes');
cla(uiOptGraphAxes)
uiOptTable = findobj(app,'UserData','uiOptTable');
n = 1:length(uiSelectScenarioDrop.ItemsData);
NModGps = zeros(1,length(uiSelectScenarioDrop.ItemsData));
for i = 1:length(uiSelectScenarioDrop.ItemsData)
    NModGps(i) = length(Projects.Scenarios(i).Target);
end
i = 0;
for m = 1:max(NModGps)
    for p = 1:length(find(NModGps==m))%min([10 length(find(NModGps==m))])
        i = i+1;
        ntemp = n(NModGps==m);
        j = ntemp(randi(length(ntemp)));
        ntemp = ntemp(ntemp~=j);
        uiSelectScenarioDrop.Value = uiSelectScenarioDrop.ItemsData(j);
        UpdateActivityTree(uiSelectScenarioDrop,[],app);
        %GACampaigns([],[],app);
        %RandomSearch2([],[],app);
        GreedySearch([],[],app);

        campList(i) = Projects.Scenarios(j).Campaigns(1);
        campCost(i) = campList(i).Cost;
        campTime(i) = campList(i).Time;
        campOF(i) = campList(i).Cost*campList(i).Time;
        campScen(i) = j;
        campNumModGps(i) = size(Projects.Scenarios(j).Target,2);
        campNumVessels(i) = size(campList(i).Gap,2);
        %plot(uiOptGraphAxes,i,campOF(i),'ro');
    end
end
[campOF,idx] = sort(campOF);
campList = campList(idx);
campCost = campCost(idx);
campTime = campTime(idx);
campScen = campScen(idx);
campTable = table(campScen',[campList.CID]',campCost',campTime',campOF',campNumModGps',campNumVessels','VariableNames',{'Scenario_ID','Campaign_ID','Cost','Time','Objective_Function','Num_Mod_Groups','Num_Vessels'});
uiOptTable.Data = campTable;

end