function [x, y] = solveODE(tspan, constants, params)
[population, dayQuarantine] = unpackModelConstants(constants);
[quarantinePercent, startingLatents] = unpackModelParams(params);

odes = @(t, y) getODE(t, y, constants, params);
tspanBefore = tspan(tspan <= dayQuarantine);
tspanAfter = tspan(tspan >= dayQuarantine);

% Solve ODE before discontinuity
[x1, y1] = ode45(odes, tspanBefore, ...
    [0, population - 2 - startingLatents, startingLatents, 2, 0, 0, 0, 0, 0, 0]);

dQdt = y1(end, 2) * quarantinePercent; % Number of susceptibles that go into quarantine

% Solve ODE after discontinuity
[x2, y2] = ode45(odes, tspanAfter, ...
    [dQdt, y1(end, 2) - dQdt, ...
    y1(end, 3), y1(end, 4), y1(end, 5), y1(end, 6), ...
    y1(end, 7), y1(end, 8), y1(end, 9), y1(end, 10)]);

% Concat both results
x = cat(1, x1, x2(2:end, :));
y = cat(1, y1, y2(2:end, :));
end

function dydt = getODE(t, y, constants, params)
Q = y(1);
S = y(2);
L = y(3);
I = y(4);
A = y(5);
H = y(6);
U = y(7);
UR = y(8);
R = y(9);
D = y(10);

[population, dayQuarantine] = unpackModelConstants(constants);

[~, ~, betaBefore, betaAfter, betaQuarantine, ...
    thetaLatents, kappaLatents, gammaAsymptomatic, deltaHospitalized, ...
    gammaInfected, gammaHospitalized, tauHospitalized, ...
    sigmaHospitalized, tauCritical, roCritical, gammaRecoveredCritical] = ...
    unpackModelParams(params);

if t <= dayQuarantine
    beta = betaBefore;
else
    beta = betaAfter;
end

dydt = [ -1 * betaQuarantine * Q * I / population; % Q
    
        -1 * beta * S * I / population; % S
        
        betaQuarantine * Q * I / population ...
            + beta * S * I / population ...
            - thetaLatents * L ...
            - kappaLatents * L; % L
        
        thetaLatents * L ...
            - deltaHospitalized * I ...
            - gammaInfected * I; % I
           
        kappaLatents * L ...
            - gammaAsymptomatic * A;
            
        deltaHospitalized * I ...
            - gammaHospitalized * H ...
            - tauHospitalized * H ...
            - sigmaHospitalized * H; % H
            
        sigmaHospitalized * H ...
            - tauCritical * U ...
            - roCritical * U; % U
        
        roCritical * U ...
            - gammaRecoveredCritical * UR; % UR
        
        gammaAsymptomatic * A ...
            + gammaInfected * I ...
            + gammaHospitalized * H ...
            + gammaRecoveredCritical * UR; % R
        
        tauHospitalized * H ...
            + tauCritical * U;]; % D
end