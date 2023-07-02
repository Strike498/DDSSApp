function OptimisationTab(app,uiTabGp)
    
uiOptimisationTab = uitab(uiTabGp,...
    'Title','Optimisation');

uiOptimisationGrid = uigridlayout(uiOptimisationTab,[22 20]);

uilabel1 = uilabel(uiOptimisationGrid,'Text','Optimisation Method','HorizontalAlignment','center','FontSize',16);
uilabel1.Layout.Row = 1;
uilabel1.Layout.Column = [1 4];

uilistbox1 = uilistbox(uiOptimisationGrid,...
    'Items',{'Greedy Search','Random Search','Best First Search','Genetic Algotithm'});
uilistbox1.Layout.Row = [2 10];
uilistbox1.Layout.Column = [1 4];

uilabel2 = uilabel(uiOptimisationGrid,'Text','Min Scenario:','HorizontalAlignment','right');
uilabel2.Layout.Row = 2;
uilabel2.Layout.Column = [5 8];

uieditfield1 = uieditfield(uiOptimisationGrid,'Value','1');
uieditfield1.Layout.Row = 2;
uieditfield1.Layout.Column = 9;

uilabel2 = uilabel(uiOptimisationGrid,'Text','Max Scenario:','HorizontalAlignment','right');
uilabel2.Layout.Row = 4;
uilabel2.Layout.Column = [5 8];

uieditfield2 = uieditfield(uiOptimisationGrid,'Value','2048');
uieditfield2.Layout.Row = 4;
uieditfield2.Layout.Column = 9;

uilabel3 = uilabel(uiOptimisationGrid,'Text','Stop Criteria:','HorizontalAlignment','right');
uilabel3.Layout.Row = 6;
uilabel3.Layout.Column = [5 8];

uidropdown1 = uidropdown(uiOptimisationGrid,'Items',{'100*n'},'Value','100*n');
uidropdown1.Layout.Row = 6;
uidropdown1.Layout.Column = 9;

uilabel4 = uilabel(uiOptimisationGrid,'Text','NPop','HorizontalAlignment','right');
uilabel4.Layout.Row = 8;
uilabel4.Layout.Column = [5 8];

uieditfield3 = uieditfield(uiOptimisationGrid,'Value','200');
uieditfield3.Layout.Row = 8;
uieditfield3.Layout.Column = 9;


uiOptButton = uibutton(uiOptimisationGrid,...
    'Text','Optimise Scenarios',...
    'FontSize',12,...
    'HorizontalAlignment','center',...
    'ButtonPushedFcn',{@OptScenarios,app});
uiOptButton.Layout.Row = 16;
uiOptButton.Layout.Column = [1 2];

uiOptTable = uitable(uiOptimisationGrid,'UserData','uiOptTable');
uiOptTable.Layout.Row = [16 20];
uiOptTable.Layout.Column = [3 20];

uiOptGraphAxes = uiaxes(uiOptimisationGrid,'UserData','uiOptGraphAxes');
hold(uiOptGraphAxes,'on')
uiOptGraphAxes.Layout.Row = [1 15];
uiOptGraphAxes.Layout.Column = [10 20];


end