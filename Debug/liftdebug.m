x = Projects.Activities;
x = [x.Type];
x = find(x == categorical("Lift"));
for i = x
test = Projects.Activities(i).ResourceOptions;
for n = 1:length(Projects.Activities(i).ResourceOptions)
nz = Projects.Activities(i).ResourceOptions(n);
if Projects.Activities(i).LiftTarget.Mass > Projects.Vessels(nz).CraneCapacity
test = test(test~=nz);
end
end
Projects.Activities(i).ResourceOptions = test;
end