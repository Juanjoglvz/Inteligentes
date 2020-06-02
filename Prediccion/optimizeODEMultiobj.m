%%%
% Target function to optimize for multiobjective optimizer
%%%
function [RMSEI, RMSEH, RMSEU, RMSER, RMSED] = ...
    optimizeODEMultiobj(data, maxTime, step, constants, params, lossfnc)
global funccounter;
funccounter = funccounter + 1;

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
RA = interpolatedY(:, 11);
TI = interpolatedY(:, 12);
TH = interpolatedY(:, 13);
TU = interpolatedY(:, 14);

Idata = data.AcumulatedPRC;
Hdata = data.Hospitalized;
Udata = data.Critical;
Rdata = data.AcumulatedRecoveries;
Ddata = data.Deaths;

RMSEI = lossfnc(Idata, TI);
RMSEH = lossfnc(Hdata, TH + TU);
RMSEU = lossfnc(Udata, TU);
RMSER = lossfnc(Rdata, R);
RMSED = lossfnc(Ddata, D);

end

