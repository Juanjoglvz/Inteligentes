clear;
close all;

if ~isfolder('figures')
    mkdir('figures')
end

%% Setting up

[output, name_ccaa, iso_ccaa, data_spain] = HistoricDataSpain();

population = 47100396;
quarantineDay = 26;

solverStep = 1;
daysToSolve = 200;
tspan = 1:solverStep:daysToSolve;

constants = [population quarantineDay];

%% Params

quarantinePercent = 0.65;
startingLatents = 20;
betaBefore = 1.3;
betaAfter = 0.649;
betaQuarantine = 0.15;
thetaLatents = 0.72;
kappaLatents = 0.12;
gammaAsymptomatic = 0.2;
deltaHospitalized = 0.4;
gammaInfected = 0.23;
gammaHospitalized = 0.631;
tauHospitalized = 0.37;
sigmaHospitalized = 0.12;
tauCritical = 0.74;
roCritical = 0.7;
gammaRecoveredCritical = 0.2;

params = [quarantinePercent, startingLatents, betaBefore, betaAfter, betaQuarantine, ...
    thetaLatents, kappaLatents, gammaAsymptomatic, deltaHospitalized, ...
    gammaInfected, gammaHospitalized, tauHospitalized, ...
    sigmaHospitalized, tauCritical, roCritical, gammaRecoveredCritical];


[x, y] = solveODE(tspan, constants, params);

%% Plot

helperPlot(x, data_spain.DailyCases, y(:, 4), 'Casos diarios', 'SimCases');
helperPlot(x, data_spain.Hospitalized, cumsum(y(:, 6)), 'Hospitalizados totales', 'SimHosp');
helperPlot(x, data_spain.Critical, cumsum(y(:, 7)), 'Ingresados en UCI totales', 'SimUCI');
helperPlot(x(2:end), data_spain.DailyRecoveries, diff(y(:, 9)), 'Recuperados diarios', 'SimRecov');
helperPlot(x(2:end), data_spain.DailyDeaths, diff(y(:, 10)), 'Fallecidos diarios', 'SimDece');

function helperPlot(x, real, predicted, ylbl, filename)
figure('units', 'normalized', 'outerposition', [0 0 0.65 1])
hold on
plot(1:length(real), real, 'LineWidth', 3.1);
plot(x, predicted, 'LineWidth', 3.1);
legend('Datos reales', 'Datos predichos')
grid minor
xlabel('Días')
ylabel(ylbl)
set(gca, 'fontsize', 26)

if nargin > 4
    saveas(gcf, strcat('figures/', filename, '.png'))
end
end