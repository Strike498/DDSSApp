function DisplayCampaigns(Source,~,app)
uiCampaignDetailsTable = findobj(app,'UserData','uiCampaignDetailsTable');
uiSelectScenarioDrop = findobj(app,'UserData','uiSelectScenarioDrop');
scenario = uiSelectScenarioDrop.Value;
campaigns = scenario.Campaigns;


campAct = Source.Value.Activities;
orderVessels = Source.Value.ResourceAssignment;
for i = 1:length(campAct)
    if ~isempty(campAct(i).StartSite)
        startSite(i) = string(campAct(i).StartSite.Name);
        endSite(i) = string(campAct(i).EndSite.Name);
    else
        startSite(i) = "";
        endSite(i) = "";
    end
    if ~isempty(campAct(i).Distance)
        campDist(i) = string(campAct(i).Distance);
    else
        campDist(i) = "";
    end
    if ~isempty(campAct(i).Time)
        campTime(i) = string(campAct(i).Time);
    else
        campTime(i) = "";
    end
end
campTable = table(categorical([campAct.Name]'),categorical([orderVessels.Name]'),[campAct.Type]',startSite',endSite',campDist',campTime',[campAct.Cost]',[campAct.CO2]',[campAct.NOx]',[campAct.SOx]',[campAct.PM]',[campAct.CH4]',[campAct.FuelConsumption]',[orderVessels.FuelType]','VariableNames',{'ActivityName','VesselName','ActivityType','StartSite','EndSite','Distance','Time','Cost','CO2','NOx','SOx','PM','CH4','FuelConsumption','FuelType'});
uiCampaignDetailsTable.Data = campTable;
% rT = max([campAct.Time])/max([campaigns.Time]);
% T = rT.*([campAct.Time]-min([campAct.Time])).*(1/(max([campAct.Time])-min([campAct.Time])));
% rC = max([campAct.Cost])/max([campaigns.Cost]);
% C = rC.*([campAct.Cost]-min([campAct.Cost])).*(1/(max([campAct.Cost])-min([campAct.Cost])));
% rCO2 = max([campAct.CO2])/max([campaigns.CO2]);
% CO2 = rCO2.*([campAct.CO2]-min([campAct.CO2])).*(1/(max([campAct.CO2])-min([campAct.CO2])));
% rNOx = max([campAct.NOx])/max([campaigns.NOx]);
% NOx = rNOx.*([campAct.NOx]-min([campAct.NOx])).*(1/(max([campAct.NOx])-min([campAct.NOx])));
% rSOx = max([campAct.SOx])/max([campaigns.SOx]);
% SOx = rSOx.*([campAct.SOx]-min([campAct.SOx])).*(1/(max([campAct.SOx])-min([campAct.SOx])));
% rPM = max([campAct.PM])/max([campaigns.PM]);
% PM = rPM.*([campAct.PM]-min([campAct.PM])).*(1/(max([campAct.PM])-min([campAct.PM])));
% rCH4 = max([campAct.CH4])/max([campaigns.CH4]);
% CH4 = rCH4.*([campAct.CH4]-min([campAct.CH4])).*(1/(max([campAct.CH4])-min([campAct.CH4])));

uiEvalActAxes1 = findobj(app,'UserData','uiEvalActAxes1');
semilogy(uiEvalActAxes1,cumsum([campAct.Time]),'--')
hold(uiEvalActAxes1,'on')
semilogy(uiEvalActAxes1,cumsum([campAct.Cost]),'--')
semilogy(uiEvalActAxes1,cumsum([campAct.CO2]),'--')
semilogy(uiEvalActAxes1,cumsum([campAct.NOx]),'--')
semilogy(uiEvalActAxes1,cumsum([campAct.SOx]),'--')
semilogy(uiEvalActAxes1,cumsum([campAct.PM]),'--')
semilogy(uiEvalActAxes1,cumsum([campAct.CH4]),'--')
legend(uiEvalActAxes1,{'Time','Cost','CO2','NOx','SOx','PM','CH4'},'Location','northwest')
hold(uiEvalActAxes1,'off')
ylim(uiEvalActAxes1,[0 1]);

%Cumulative Graph
% uiEvalActAxes2 = findobj(app,'UserData','uiEvalActAxes2');
% grid(uiEvalActAxes2,'on')
% semilogy(uiEvalActAxes1,[0 rT*T/max(T)],'-')
% hold(uiEvalActAxes1,'on')
% semilogy(uiEvalActAxes1,[0 rC*C/max(C)],'-')
% semilogy(uiEvalActAxes1,[0 rCO2*CO2/max(CO2)],'-')
% semilogy(uiEvalActAxes1,[0 rNOx*NOx/max(NOx)],'-')
% semilogy(uiEvalActAxes1,[0 rSOx*SOx/max(SOx)],'-')
% semilogy(uiEvalActAxes1,[0 rPM*PM/max(PM)],'-')
% semilogy(uiEvalActAxes1,[0 rCH4*CH4/max(CH4)],'-')
% legend(uiEvalActAxes1,{'Time','Cost','CO2','NOx','SOx','PM','CH4'},'Location','northwest')
% ylim(uiEvalActAxes1,[0 1]);
% hold(uiEvalActAxes1,'off')

% figure();
% subplot(4,2,1)
% plot(0:length(campAct),cumsum([0 campAct.Time]),'-','Color',"#0072BD")
% xlabel('Activity Index')
% ylabel('Cumulative Time (Hrs)')
% title('Cumulative')
% subplot(4,2,2)
% plot(0:length(campAct),cumsum([0 campAct.Cost]),'-','Color',"#D95319")
% xlabel('Activity Index')
% ylabel('Cumulative Cost (£)')
% subplot(4,2,3)
% plot(0:length(campAct),cumsum([0 campAct.CO2]),'-','Color',"#EDB120")
% xlabel('Activity Index')
% ylabel('Cumulative CO2 (kg)')
% subplot(4,2,4)
% plot(0:length(campAct),cumsum([0 campAct.NOx]),'-','Color',"#7E2F8E")
% xlabel('Activity Index')
% ylabel('Cumulative NOx (kg)')
% subplot(4,2,5)
% plot(0:length(campAct),cumsum([0 campAct.SOx]),'-','Color',"#77AC30")
% xlabel('Activity Index')
% ylabel('Cumulative SOx (kg)')
% subplot(4,2,6)
% plot(0:length(campAct),cumsum([0 campAct.PM]),'-','Color',"#4DBEEE")
% xlabel('Activity Index')
% ylabel('Cumulative PM (kg)')
% subplot(4,2,7)
% plot(0:length(campAct),cumsum([0 campAct.CH4]),'-','Color',"#A2142F")
% xlabel('Activity Index')
% ylabel('Cumulative CH4 (kg)')
% subplot(4,2,8)
% plot(0:length(campAct),cumsum([0 campAct.FuelConsumption]),'-k')
% xlabel('Activity Index')
% ylabel('Cumulative Fuel Consumption (kg)')
% 
% figure();
% subplot(4,2,1)
% plot(0:length(campAct),[0 campAct.Time],'--','Color',"#0072BD")
% xlabel('Activity Index')
% ylabel('Time (Hrs)')
% title('Per Activity')
% subplot(4,2,2)
% plot(0:length(campAct),[0 campAct.Cost],'--','Color',"#D95319")
% xlabel('Activity Index')
% ylabel('Cost (£)')
% subplot(4,2,3)
% plot(0:length(campAct),[0 campAct.CO2],'--','Color',"#EDB120")
% xlabel('Activity Index')
% ylabel('CO2 (kg)')
% subplot(4,2,4)
% plot(0:length(campAct),[0 campAct.NOx],'--','Color',"#7E2F8E")
% xlabel('Activity Index')
% ylabel('NOx (kg)')
% subplot(4,2,5)
% plot(0:length(campAct),[0 campAct.SOx],'--','Color',"#77AC30")
% xlabel('Activity Index')
% ylabel('SOx (kg)')
% subplot(4,2,6)
% plot(0:length(campAct),[0 campAct.PM],'--','Color',"#4DBEEE")
% xlabel('Activity Index')
% ylabel('PM (kg)')
% subplot(4,2,7)
% plot(0:length(campAct),[0 campAct.CH4],'--','Color',"#A2142F")
% xlabel('Activity Index')
% ylabel('CH4 (kg)')
% subplot(4,2,8)
% plot(0:length(campAct),[0 campAct.FuelConsumption],'--k')
% xlabel('Activity Index')
% ylabel('Fuel Consumption (kg)')



%Gantt Chart
uiEvalActAxes3 = findobj(app,'UserData','uiEvalActAxes3');
cla(uiEvalActAxes3);
vessels = unique(orderVessels,'stable');
H1 = barh(uiEvalActAxes3,1:length(vessels),Source.Value.RGap','stacked');
set(H1(Source.Value.RGap_Act==0),'Visible','off')
Bars1 = H1(Source.Value.RGap_Act~=0);
for i = 1:length(Bars1)
    set(Bars1(i),'FaceColor',[0.75 0.75 0.75])
end
hold(uiEvalActAxes3,'on')
if size(Source.Value.Gap,2)==1
    H2 = barh(uiEvalActAxes3,...
        [1:length(vessels);nan(1,length(vessels))],...
        [Source.Value.Gap nan(length(Source.Value.Gap),1)]',...
        'stacked');
else
    H2 = barh(uiEvalActAxes3,1:length(vessels),Source.Value.Gap','stacked');
end
set(H2(Source.Value.Gap_Act==0),'Visible','off')
Bars2 = H2(Source.Value.Gap_Act~=0);

cb = hsv(length(campAct));
[~,lb] = sort([campAct.ID]);
[x,y] = sort(Source.Value.Gap_Act(Source.Value.Gap_Act~=0));
for i = 1:length(Bars2)
    set(Bars2(i),'FaceColor',cb(lb(i),:))
end
uiEvalActAxes3.YTick=1:length(vessels);
uiEvalActAxes3.YTickLabel = cellstr([vessels.Name]);
lgd2 = legend(uiEvalActAxes3,[Bars1(1),Bars2(y)],['Rented Period',string(campTable.ActivityName(x))'],'Location','eastoutside','NumColumns',ceil(length(campAct)/20));

end