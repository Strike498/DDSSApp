function Dashboard(app)
delete(app.Children)
uiGrid = uigridlayout(app,[1 1],...
    'Padding',[0 0 0 0]);
uiTabGp = uitabgroup(uiGrid);

UnitTab(app,uiTabGp);

SiteTab(app,uiTabGp);

ScenarioTab(app,uiTabGp);

EvaluationTab(app,uiTabGp);

OptimisationTab(app,uiTabGp);

end