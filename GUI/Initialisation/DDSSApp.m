function DDSSApp(Projects)
screenSize = get(groot,'Screensize');
figSize = [screenSize(3:4).*0.5-screenSize(3:4).*0.75.*0.5,...
    screenSize(4)*0.75*3/2 screenSize(4)*0.75];
app = uifigure('name','DDSSApp','Position',figSize,'Visible','on','UserData',Projects);

StartMenu([],[],app);

%Demo Bypass to Speed up Coding
NewProject([],[],app);
CreateProject([],[],app);
ImportUnit([],[],app);
Projects.SaveLocation = app;

CalculateScenarios([],[],app);
ww = getWebWindowOfUiFigure(app);
ww.Icon = which('NDC_Icon.ico');

end