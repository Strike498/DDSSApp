function CentreGeometry(Projects)
    lowestZ = NaN(1,length(Projects.Units));
    for i = 1:length(Projects.Units)
        if isa(Projects.Units{i},'Module')
            lowestZ(i) = Projects.Units{i}.Origin(3)-Projects.Units{i}.Height/2;
        end
    end
    [~,idx] = min(lowestZ);
    offset = -[Projects.Units{i}.Origin(1:2) lowestZ(idx)];
    for i = 1:length(Projects.Units)
        if isa(Projects.Units{i},'Module')
            Projects.Units{i}.GraphicObj = Connection.TranslateCuboid(Projects.Units{i}.GraphicObj,offset);
        end
    end
end