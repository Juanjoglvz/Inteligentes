%%%
% Single-Objetive optimization script
%%%
clear;
close all;

%% Reset global variables
global bestFitness
bestFitness = [];

global funccounter;
funccounter = 0;

%% Retrieve ground truth data
[output, name_ccaa, iso_ccaa, data_spain] = HistoricDataSpain();
ccaaPopulation = getCCAAPopulation();

%% Set up parameters

solverStep = 1; % ODE solver step
quarantineDay = 26; 

vars = 16; %% Model parameters

timeFactor = 4.25; % How many more times than the providedd data will the x-axis span?
labelInterval = 21; % x-axis label interval

paralellize = true;
optimizer = 'ga'; % Optimizer (ga or pso)
lossfnc = @computeRMSE; % Set up loss function

%% Select data to optimize with

CCAA_ISO = 'AN';

if strcmp(CCAA_ISO, 'ES')
    data = data_spain;
    ccaa = 'España';
else
    CCAA_IDX = find(strcmp(iso_ccaa, 'AN'));
    data = output.historic{CCAA_IDX};
    ccaa = name_ccaa{CCAA_IDX};
end

%% Prepare optimization

population = ccaaPopulation(ccaa); % Retrieve population   
constants = [population, quarantineDay]; % Set up constants

daysToSolve = length(data.label_x); 

funcToOptimize = @(x) optimizeODE(data, daysToSolve, solverStep, constants, x, lossfnc);


tic;
rng(314159265, 'twister'); % Set up the RNG for reproducibility
gradientOpts = optimoptions('fmincon', 'Algorithm', 'sqp', ...
    'MaxFunctionEvaluations', vars * 3000, 'MaxIterations', 1000, ...
    'OutputFcn', @gradoutfun);
if strcmp(optimizer, 'ga')
    opts = optimoptions('ga', 'UseParallel', paralellize, ...
        'MaxGenerations', 100 * vars ,'OutputFcn', @gaoutfun, ...
        'HybridFcn', {@fmincon, gradientOpts});

    [optimalParams, ~, ~, ~] = ga(funcToOptimize, vars, [], [], [], [], ...
        zeros(1, vars), [1 Inf 2 2 2 2 2 2 2 2 2 2 2 2 2 2], [], opts);

else
    opts = optimoptions('particleswarm', 'UseParallel', paralellize ...
        ,'OutputFcn', @psooutfun, 'HybridFcn', {@fmincon, gradientOpts});

    optimalParams = particleswarm(funcToOptimize, vars, ...
        zeros(1, vars), [1 Inf 2 2 2 2 2 2 2 2 2 2 2 2 2 2], opts);
end 


optTime = toc;
fprintf("Optimized in %f seconds\n", optTime);

%% Compute other situations

[PquarantinePercent, PstartingLatents, PbetaBefore, PbetaAfter, PbetaQuarantine, ...
    PthetaLatents, PkappaLatents, PgammaAsymptomatic, PdeltaHospitalized, ...
    PgammaInfected, PgammaHospitalized, PtauHospitalized, ...
    PsigmaHospitalized, PtauCritical, ProCritical, PgammaRecoveredCritical] = ...
    unpackModelParams(optimalParams);

% Obtain original predicted values
[RMSE, x, y] = optimizeODE(data, length(data.label_x) * timeFactor,...
    solverStep, constants, optimalParams, @computeRMSE);

constants(2) = 10; % Change quarantine effect day
[RMSE2, x2, y2] = optimizeODE(data, length(data.label_x) * timeFactor,...
    solverStep, constants, optimalParams, @computeRMSE);

Q = y(:, 1);    S = y(:, 2);    L = y(:, 3);    I = y(:, 4);   A = y(:, 5);
H = y(:, 6);    U = y(:, 7);    UR = y(:, 8);   R = y(:, 9);   D = y(:, 10);
RA = y(:, 11);  TI = y(:, 12);  TH = y(:, 13);  TU = y(:, 14);

%% Plot results

plotfnc([0.85 1], 'Día', 'Individuos', 'Casos diarios en España', ...
    {'Modelo realidad', 'Modelo adelantado', 'Datos reales'}, data.label_x{1}, ...
    labelInterval, x(2:end), diff(TI), x2(2:end), diff(y2(:, 12)), 1:length(data.label_x), data.DailyCases)
%saveas(gcf, 'figures/DailyCases.png')

plotfnc([0.85 1], 'Día', 'Individuos', 'Hospitalizados acumulados en España', ...
    {'Modelo realidad', 'Modelo adelantado', 'Datos reales'}, data.label_x{1}, ...
    labelInterval, x, TH, x2, y2(:, 13), 1:length(data.label_x), data.Hospitalized)
%saveas(gcf, 'figures/Hospitalized.png')

plotfnc([0.85 1], 'Día', 'Individuos', 'Ingresos en UCI acumulados en España', ...
    {'Modelo realidad', 'Modelo adelantado', 'Datos reales'}, data.label_x{1}, ...
    labelInterval, x, TU, x2, y2(:, 14), 1:length(data.label_x), data.Critical)
%saveas(gcf, 'figures/Critical.png')

plotfnc([0.85 1], 'Día', 'Individuos', 'Recuperaciones diarias en España', ...
    {'Modelo realidad', 'Modelo adelantado', 'Datos reales'}, data.label_x{1}, ...
    labelInterval, x(2:end), diff(R), x2(2:end), diff(y2(:, 9)), 1:length(data.label_x), data.DailyRecoveries)
%saveas(gcf, 'figures/DailyRecoveries.png')

plotfnc([0.85 1], 'Día', 'Individuos', 'Defunciones diarias en España', ...
    {'Modelo realidad', 'Modelo adelantado', 'Datos reales'}, data.label_x{1}, ...
    labelInterval, x(2:end), diff(D), x2(2:end), diff(y2(:, 10)), 1:length(data.label_x), data.DailyDeaths)
%saveas(gcf, 'figures/DailyDeaths.png')

plotfnc([0.85 1], 'Día', 'Individuos', 'Casos totales en España', ...
    {'Modelo realidad', 'Modelo adelantado', 'Datos reales'}, data.label_x{1}, ...
    labelInterval, x, TI, x2, y2(:, 12), 1:length(data.label_x), cumsum(data.DailyCases))
%saveas(gcf, 'figures/TotalCases.png')

%autoArrangeFigures(2, 3, 1);


function [state,options,optchanged] = gaoutfun(options, state, flag)
global bestFitness
if length(state.Best) == 1
    bestFitness(end + 1) = state.Best;
end
optchanged = false;
end

function stop = psooutfun(optimValues, state)
global bestFitness
if length(optimValues.bestfval) == 1
    bestFitness(end + 1) = optimValues.bestfval;
end
stop = false;
end

function stop = gradoutfun(x, optimValues, state)
global bestFitness
bestFitness(end + 1) = optimValues.fval;
stop = false;
end