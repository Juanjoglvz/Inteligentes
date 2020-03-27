% Read data
raw = readtable("groups_a_priori.csv");


% Extract groups column
group = table2array(raw(:,"Group"));


% Perform ANOVA test for each column
variables = ["Delicassen", "Detergents_Paper", "Fresh", "Frozen", "Grocery", "Milk"];

p_values = zeros(length(variables));
for i = 1:length(variables)
   disp(variables(i));
   data = raw(:,variables(i));
   p_values(i) = kruskalwallis(data, group);
end

disp(p_values);

% Transform table into matlab matrix
raw_data = table2array(raw);

% Calculate centroids for each group using median
centroids = zeros(6, length(variables));
for i = 1:6
    rows = raw_data(:, 9) == i-1;
    for j = 1:length(variables)
       data = table2array(raw(rows, variables(j)));
       centroids(i, j) = median(data);
    end
end

disp(centroids);


