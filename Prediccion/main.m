clear;
close all;
clearGlobalVariables();
[output, name_ccaa, iso_ccaa, data_spain] = HistoricDataSpain();
ccaaPopulation = getCCAAPopulation();

step = 1;
quarantineDay = 26;

for i=1:length(name_ccaa)
    if i ~= 14
        continue;
    end
    
    ccaa = name_ccaa{i};
    population = ccaaPopulation(ccaa);

    data = output.historic{i};

    rng(3214654, 'twister');
    
    [optimalParams, RMSE] = ga(@(x) ...
        optimizeODE(data, length(data.label_x), step, [population, quarantineDay], x), 6,...
        [], [], [], [], [0 0 0 0 0 0], [1 1 1 1 1 1], @(x) nonlcon(x));

    [RMSE, x, y] = optimizeODE(data, length(data.label_x) * 2,...
        step, [population, quarantineDay], optimalParams);

end


[RMSE, x, y] = optimizeODE(data, length(data.label_x) * 2.5,...
    step, [population, quarantineDay], optimalParams);

figure
hold on
plot(x(2:end), diff(y(:, 4)));
plot(1:length(data.label_x), data.DailyRecoveries);
xlabel('Dias');
ylabel('Recuperaciones diarias');
grid minor

figure
hold on
plot(x, y(:, 3));
plot(1:length(data.label_x), data.DailyCases);
xlabel('Dias');
ylabel('Casos diarios');
grid minor


figure
hold on
plot(x(2:end), diff(y(:, 5)));
plot(1:length(data.label_x), data.DailyDeaths);
xlabel('Dias');
ylabel('Defunciones diarias');
grid minor

function [c, ceq] = nonlcon(x)
c = x(3) - x(2); % Hope for the best and that the optimizer will figure
%out the betaBefore param must be bigger than betaAfter
ceq = [];
%fprintf("c = %f\n", c);
end