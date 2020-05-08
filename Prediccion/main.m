clear;
close all;
clearGlobalVariables();
[output, name_ccaa, iso_ccaa, data_spain] = HistoricDataSpain();
ccaaPopulation = getCCAAPopulation();

solverStep = 1;
quarantineDay = 26;

vars = 14;

timeFactor = 5;

for i=1:length(name_ccaa)
    if i ~= 6
        continue;
    end
    
    ccaa = name_ccaa{i};
    population = ccaaPopulation(ccaa);
    
    constants = [population, quarantineDay];

    data = output.historic{i};
    
    daysToSolve = length(data.label_x);    

    rng(3214654, 'twister');
    
    funcToOptimize = @(x) optimizeODE(data, daysToSolve, solverStep, constants, x);
    
    [optimalParams, ~] = ga(funcToOptimize, vars, [], [], [], [], ...
        zeros(1, vars), [1 Inf 1 1 1 1 1 1 1 1 1 1 1 1 1 1], @(x) nonlcon(x));

end

[quarantinePercent, startingLatents, betaBefore, betaAfter, betaQuarantine, ...
    thetaLatents, kappaLatents, gammaAsymptomatic, deltaHospitalized, ...
    gammaInfected, gammaHospitalized, tauHospitalized, ...
    sigmaHospitalized, tauCritical, roCritical, gammaRecoveredCritical] = ...
    unpackModelParams(optimalParams);

[RMSE, x, y] = optimizeODE(data, length(data.label_x) * timeFactor,...
    solverStep, constants, optimalParams);

figure
hold on
plot(x, y(:, 4));
plot(1:length(data.label_x), data.DailyCases);
xlabel('Dias');
ylabel('Casos diarios');
grid minor

figure
hold on
plot(x, cumsum(y(:, 6)));
plot(1:length(data.label_x), data.Hospitalized);
xlabel('Dias');
ylabel('Hospitalizaciones totales');
grid minor

figure
hold on
plot(x, cumsum(y(:, 7)));
plot(1:length(data.label_x), data.Critical);
xlabel('Dias');
ylabel('Ingresos en UCI totales');
grid minor

figure
hold on
plot(x(2:end), diff(y(:, 9)));
plot(1:length(data.label_x), data.DailyRecoveries);
xlabel('Dias');
ylabel('Recuperaciones diarias');
grid minor

figure
hold on
plot(x(2:end), diff(y(:, 10)));
plot(1:length(data.label_x), data.DailyDeaths);
xlabel('Dias');
ylabel('Defunciones diarias');
grid minor

autoArrangeFigures();

function [c, ceq] = nonlcon(x)
c = x(3) - x(2); % Hope for the best and that the optimizer will figure
%out the betaBefore param must be bigger than betaAfter
ceq = [];
%fprintf("c = %f\n", c);
end