function [RMSE, x, y] = optimizeODE(data, maxTime, step, constants, params)
clearGlobalVariables();

dataTime = length(data.DailyCases);
tspan = 0:step:maxTime;
[x, y] = solveODE(tspan, constants, params);


interpolatedY = interp1(x, y, 1:dataTime);

Q = interpolatedY(:, 1);
S = interpolatedY(:, 2);
L = interpolatedY(:, 3);
I = interpolatedY(:, 4);
A = interpolatedY(:, 5);
H = interpolatedY(:, 6);
U = interpolatedY(:, 7);
UR = interpolatedY(:, 8);
R = interpolatedY(:, 9);
D = interpolatedY(:, 10);

Idata = data.DailyCases;
Hdata = data.Hospitalized;
Udata = data.Critical;
Rdata = data.DailyRecoveries;
Ddata = data.DailyDeaths;

RMSEI = computeRMSE(Idata, L);
RMSEH = computeRMSE(Hdata, cumsum(H));
RMSEU = computeRMSE(Udata, cumsum(U));
RMSER = computeRMSE(Rdata(2:end), diff(R));
RMSED = computeRMSE(Ddata(2:end), diff(D));

RMSE = RMSEI + RMSEH + RMSEU + RMSER + RMSED;
    
end

