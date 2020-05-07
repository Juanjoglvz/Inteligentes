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
R = interpolatedY(:, 5);
D = interpolatedY(:, 6);

%Idata = data.AcumulatedPRC;
Idata = data.DailyCases;
Hdata = data.Hospitalized;
Rdata = data.DailyRecoveries;
Ddata = data.DailyDeaths;

RMSEI = computeRMSE(Idata, I);
RMSEH = computeRMSE(Hdata, cumsum(H));
RMSER = computeRMSE(Rdata(2:end), diff(R));
RMSED = computeRMSE(Ddata(2:end), diff(D));

RMSE = RMSEI + RMSEH + RMSER + RMSED;
%RMSE = RMSEI;
    
end

