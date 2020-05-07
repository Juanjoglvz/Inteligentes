clear;
close all;
clearGlobalVariables();
[output, name_ccaa, iso_ccaa, data_spain] = HistoricDataSpain();
ccaaPopulation = getCCAAPopulation();

solverStep = 1;
quarantineDay = 26;

timeToHospitalization = 5.8;
timeToRecovery = 14;

timeToDecease = 7.5;
timeToRecoveryHospitalized = 7;

for i=1:length(name_ccaa)
    if i ~= 9
        continue;
    end
    
    ccaa = name_ccaa{i};
    population = ccaaPopulation(ccaa);
    
    constants = [population, quarantineDay, timeToHospitalization, ...
        timeToRecovery, timeToDecease, timeToRecoveryHospitalized];

    data = output.historic{i};

    rng(3214654, 'twister');
    
    [optimalParams, RMSE] = ga(@(x) ...
        optimizeODE(data, length(data.label_x), solverStep, ...
        constants, x), 6, [], [], [], [], [0 0 0 0 0 0], [1 1 1 1 1 1], @(x) nonlcon(x));

    [RMSE, x, y] = optimizeODE(data, length(data.label_x) * 2,...
        solverStep, constants, optimalParams);

end

%optimalParams(5) = 0.2;
optimalParams(6) = 0.7;
%optimalParams = [0.7 0.59 0.1 0.15 0.05 0.065];

[RMSE, x, y] = optimizeODE(data, length(data.label_x) * 3,...
    solverStep, constants, optimalParams);

figure
hold on
plot(x, y(:, 3));
plot(1:length(data.label_x), data.DailyCases);
xlabel('Dias');
ylabel('Casos diarios');
grid minor

figure
hold on
plot(x, cumsum(y(:, 4)));
plot(1:length(data.label_x), data.Hospitalized);
xlabel('Dias');
ylabel('Hospitalizaciones totales');
grid minor

figure
hold on
plot(x(2:end), diff(y(:, 5)));
plot(1:length(data.label_x), data.DailyRecoveries);
xlabel('Dias');
ylabel('Recuperaciones diarias');
grid minor

figure
hold on
%plot(x(2:end), diff(y(:, 6)));
plot(x(2:end), diff(y(:, 6)));
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