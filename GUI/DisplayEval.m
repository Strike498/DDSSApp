function DisplayEval(scenario,app)
uiEvalGAxes1 = findobj(app,'UserData','uiEvalGAxes1');
uiEvalGAxes2 = findobj(app,'UserData','uiEvalGAxes2');
uiEvalGAxes3 = findobj(app,'UserData','uiEvalGAxes3');
uiEvalGAxes4 = findobj(app,'UserData','uiEvalGAxes4');
uiEvalGAxes5 = findobj(app,'UserData','uiEvalGAxes5');
uiEvalGAxes6 = findobj(app,'UserData','uiEvalGAxes6');
uiEvalGAxes7 = findobj(app,'UserData','uiEvalGAxes7');
uiEvalGAxes8 = findobj(app,'UserData','uiEvalGAxes8');

%uiEvalGraphAxes2 = findobj(app,'UserData','uiEvalGraphAxes2');
uiCampaignList = findobj(app,'UserData','uiCampaignList');
% yyaxis(uiEvalGAxes1,'left')
% cla(uiEvalGAxes1);
% yyaxis(uiEvalGAxes1,'right')
% cla(uiEvalGAxes1);

campList = scenario.Campaigns;
if isempty(campList)
    uiCampaignList.Items = "";
    uiCampaignList.ItemsData = [];
    uiCampaignDetailsTable = findobj(app,'UserData','uiCampaignDetailsTable');
    uiCampaignDetailsTable.Data = table.empty;
    uiEvalActAxes1 = findobj(app,'UserData','uiEvalActAxes1');
    cla(uiEvalActAxes1);
    uiEvalActAxes2 = findobj(app,'UserData','uiEvalActAxes2');
    %cla(uiEvalActAxes2);
    uiEvalActAxes3 = findobj(app,'UserData','uiEvalActAxes3');
    cla(uiEvalActAxes3);
    cla(uiEvalGAxes1);
    cla(uiEvalGAxes2);
    cla(uiEvalGAxes3);
    cla(uiEvalGAxes4);
    cla(uiEvalGAxes5);
    cla(uiEvalGAxes6);
    cla(uiEvalGAxes7);
    cla(uiEvalGAxes8);
    
else
    campFit = [campList.Cost].*[campList.Time];
    
    [~,idx] = sort(campFit);
    campList = campList(idx);
    scenario.Campaigns = campList;
    
%     if length(campList)>10
%         campList = campList(1:10);
%     end
    
    uiCampaignList = findobj(app,'UserData','uiCampaignList');
    uiCampaignList.Items = strcat("C ",string([campList.CID]));
    uiCampaignList.ItemsData = campList;
    uiCampaignList.Value = uiCampaignList.ItemsData(1);
    DisplayCampaigns(uiCampaignList,[],app);
    
    %     Y1 = [[campList.Cost]',[campList.Time]'.*0];
    %     Y2 = [[campList.Cost]'.*0,[campList.Time]'];
    %     if length(campList)<2
    %         Y1 = vertcat(Y1,nan(size(Y1)));
    %         Y2 = vertcat(Y2,nan(size(Y2)));
    %     end
    %
    %     yyaxis(uiEvalGraphAxes,'left')
    %     bar(uiEvalGraphAxes,Y1,'grouped')
    %
    %     yyaxis(uiEvalGraphAxes,'right')
    %     bar(uiEvalGraphAxes,Y2,'grouped')
    %
    %     uiEvalGraphAxes.XTickLabel = categorical(uiCampaignList.Items);
    %     uiEvalGraphAxes.XTick = 1:length(campList);

    bar(uiEvalGAxes1,[campList.Time],'FaceColor',"#0072BD")

    bar(uiEvalGAxes2,[campList.Cost],'FaceColor',"#D95319")

    bar(uiEvalGAxes3,[campList.CO2],'FaceColor',"#EDB120")

    bar(uiEvalGAxes4,[campList.NOx],'FaceColor',"#7E2F8E")

    bar(uiEvalGAxes5,[campList.SOx],'FaceColor',"#77AC30")

    bar(uiEvalGAxes6,[campList.PM],'FaceColor',"#4DBEEE")

    bar(uiEvalGAxes7,[campList.CH4],'FaceColor',"#A2142F")
    
    bar(uiEvalGAxes8,[campList.FuelConsumption],'FaceColor','k')

%     Tab = table([campList.Time]',[campList.Cost]',[campList.CO2]',[campList.NOx]',[campList.SOx]',[campList.PM]',[campList.CH4]','variablenames',{'Time','Cost','CO2','NOx','SOx','PM','CH4'});
%     vars = {"Time","Cost",["CO2","NOx","SOx","PM","CH4"]};
%     stackedplot(uiEvalGAxes1,Tab,vars);
    
end
end