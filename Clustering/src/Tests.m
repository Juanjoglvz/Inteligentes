raw = readtable("groups.csv");
group = table2array(raw(:,"Group"));

variables = ["Delicassen", "Detergents_Paper", "Fresh", "Frozen", "Grocery", "Milk"];
p_values = zeros(length(variables));
for i = 1:length(variables)
   disp(variables(i));
   data = table2array(raw(:,variables(i)));
   p_values(i) = anova1(data, group);
end

disp(p_values);