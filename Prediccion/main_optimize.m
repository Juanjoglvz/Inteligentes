clear;
close all;

global bestFitness
bestFitness = [];

global funccounter;
funccounter = 0;

clearGlobalVariables();
[output, name_ccaa, iso_ccaa, data_spain] = HistoricDataSpain();
ccaaPopulation = getCCAAPopulation();

solverStep = 1;
quarantineDay = 26;

vars = 16;

timeFactor = 5;

for i=1:length(name_ccaa)
    if i ~= 7
        continue;
    end

    data = output.historic{i};
    ccaa = name_ccaa{i};
    data = data_spain;
    ccaa = 'España';
    
    population = ccaaPopulation(ccaa);    
    constants = [population, quarantineDay];
    
    daysToSolve = length(data.label_x); 
    funcToOptimize = @(x) optimizeODE(data, daysToSolve, solverStep, constants, x);
    
    gradientOpts = optimoptions('fmincon', 'Algorithm', 'sqp', ...
        'MaxFunctionEvaluations', vars * 3000, 'MaxIterations', 1000, ...
        'OutputFcn', @gradoutfun);
    opts = optimoptions('ga', 'OutputFcn', @gaoutfun, 'HybridFcn', {@fmincon, gradientOpts}); 

    rng(3214655, 'twister');
    [optimalParams, ~, ~, ~] = ga(funcToOptimize, vars, [], [], [], [], ...
        zeros(1, vars), [1 Inf 1 1 1 1 1 1 1 1 1 1 1 1 1 1], [], opts);
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
title(ccaa);
grid minor

figure
hold on
plot(x, cumsum(y(:, 6)));
plot(1:length(data.label_x), data.Hospitalized);
xlabel('Dias');
ylabel('Hospitalizaciones totales');
title(ccaa);
grid minor

figure
hold on
plot(x, cumsum(y(:, 7)));
plot(1:length(data.label_x), data.Critical);
xlabel('Dias');
ylabel('Ingresos en UCI totales');
title(ccaa);
grid minor

figure
hold on
plot(x(2:end), diff(y(:, 9)));
plot(1:length(data.label_x), data.DailyRecoveries);
xlabel('Dias');
ylabel('Recuperaciones diarias');
title(ccaa);
grid minor

figure
hold on
plot(x(2:end), diff(y(:, 10)));
plot(1:length(data.label_x), data.DailyDeaths);
xlabel('Dias');
ylabel('Defunciones diarias');
title(ccaa);
grid minor

figure
semilogy(bestFitness)
hold on
xlabel('Iteraciones del optimizador')
ylabel('RMSE')
title(strcat(ccaa, {' - Evaluaciones de la función: '}, num2str(funccounter)));
grid minor

autoArrangeFigures(2, 3, 1);

function [state,options,optchanged] = gaoutfun(options, state, flag)
global bestFitness
if length(state.Best) == 1
    bestFitness(end + 1) = state.Best;
end
optchanged = false;
end

function stop = gradoutfun(x, optimValues, state)
global bestFitness
bestFitness(end + 1) = optimValues.fval;
stop = false;
end