function UpdateSaveLoc(~,~,app,uiSaveLocEdit)

saveDir = uigetdir;
app.UserData.SaveLocation = saveDir;
uiSaveLocEdit.Value = saveDir;
app.Visible = 'off';
app.Visible = 'on';

end