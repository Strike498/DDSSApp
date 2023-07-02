function out = ColorAllFaces(obj,color)
for i = 1:length(obj.Children)
    obj.Children(i).FaceColor = color;
end
out = obj;
end