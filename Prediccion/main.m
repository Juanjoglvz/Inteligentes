clear;
close all;
clearGlobalVariables();
[output, name_ccaa, iso_ccaa, data_spain] = HistoricDataSpain();
ccaaPopulation = getCCAAPopulation();

solverStep = 1;
quarantineDay = 26;

vars = 12;

timeFactor = 5;

for i=1:length(name_ccaa)
    if i ~= 9
        continue;
    end
    
    ccaa = name_ccaa{i};
    population = ccaaPopulation(ccaa);
    
    constants = [population, quarantineDay];

    %data = output.historic{i};
    data = output.historic{i};

    rng(3214654, 'twister');
    
    [optimalParams, ~] = ga(@(x) ...
        optimizeODE(data, length(data.label_x), solverStep, ...
        constants, x), vars, [], [], [], [], zeros(1, vars), ones(1, vars), @(x) nonlcon(x));

end

[PquarantinePercent, PbetaBefore, PbetaAfter, PbetaQuarantine, ...
    PdeltaHospitalized, PgammaInfected, PgammaHospitalized, PtauHospitalized, ...
    PsigmaHospitalized, PtauCritical, ProCritical, PgammaRecoveredCritical] = ...
    unpackModelParams(optimalParams);

[RMSE, x, y] = optimizeODE(data, length(data.label_x) * timeFactor,...
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
plot(x, cumsum(y(:, 5)));
plot(1:length(data.label_x), data.Critical);
xlabel('Dias');
ylabel('Ingresos en UCI totales');
grid minor

figure
hold on
plot(x(2:end), diff(y(:, 7)));
plot(1:length(data.label_x), data.DailyRecoveries);
xlabel('Dias');
ylabel('Recuperaciones diarias');
grid minor

figure
hold on
plot(x(2:end), diff(y(:, 8)));
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