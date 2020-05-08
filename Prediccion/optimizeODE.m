function [RMSE, x, y] = optimizeODE(data, maxTime, step, constants, params)
clearGlobalVariables();

dataTime = length(data.DailyCases);
tspan = 0:step:maxTime;
[x, y] = solveODE(tspan, constants, params);


interpolatedY = interp1(x, y, 1:dataTime);

Q = interpolatedY(:, 1);
S = interpolatedY(:, 2);
I = interpolatedY(:, 3);
H = interpolatedY(:, 4);
U = interpolatedY(:, 5);
UR = interpolatedY(:, 6);
R = interpolatedY(:, 7);
D = interpolatedY(:, 8);

Idata = data.DailyCases;
Hdata = data.Hospitalized;
Udata = data.Critical;
Rdata = data.DailyRecoveries;
Ddata = data.DailyDeaths;

RMSEI = computeRMSE(Idata, I);
RMSEH = computeRMSE(Hdata, cumsum(H));
RMSEU = computeRMSE(Udata, cumsum(U));
RMSER = computeRMSE(Rdata(2:end), diff(R));
RMSED = computeRMSE(Ddata(2:end), diff(D));

RMSE = RMSEI + RMSEH + RMSEU + RMSER + RMSED;
%RMSE = RMSEI;
    
end

