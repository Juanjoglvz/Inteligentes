function [x, y] = solveODE(tspan, constants, params)
[population, dayQuarantine] = unpackModelConstants(constants);

quarantinePercent = unpackModelParams(params);


odes = @(t, y) getODE(t, y, constants, params);
tspanBefore = tspan(tspan <= dayQuarantine);
tspanAfter = tspan(tspan >= dayQuarantine);

[x1, y1] = ode45(odes, tspanBefore, [0, population - 2, 2, 0, 0, 0]);

dquarantinedt = y1(end, 2) * quarantinePercent;

[x2, y2] = ode45(odes, tspanAfter, [dquarantinedt, y1(end, 2) - dquarantinedt, y1(end, 3), y1(end, 4), y1(end, 5), y1(end, 6)]);

x = cat(1, x1, x2(2:end, :));
y = cat(1, y1, y2(2:end, :));

%     initializeHistoric()
%     ddes = @(t, y, z) getDDE(t, y, z, params);
%     
%     sol = dde23(ddes, delays, @ddehist, tspan);
end

function dydt = getODE(t, y, constants, params)
Q = y(1);
S = y(2);
I = y(3);
H = y(4);
R = y(5);
D = y(6);

[population, dayQuarantine] = unpackModelConstants(constants);

[~, betaBefore, betaAfter, betaQuarantine, ...
    gammaInfected, deltaHospitalized, gammaHospitalized, tauHospitalized] = ...
    unpackModelParams(params);

if t <= dayQuarantine
    beta = betaBefore;
else
    beta = betaAfter;
end

dydt = [ -1 * betaQuarantine * Q * I / population; % Q
    
        -1 * beta * S * I / population; % S
        
        beta * S * I / population ...
            + betaQuarantine * Q * I / population ...
            - deltaHospitalized * I ...
            - gammaInfected * I; % I
            
        deltaHospitalized * I ...
            - gammaHospitalized * H ...
            - tauHospitalized * H; % H
        
        gammaInfected * I ...
            + gammaHospitalized * H; % R
        
        tauHospitalized * H;]; % D
end

function s = ddehist(t)
global historic
if t >= 0
    s = historic(t);
else % ??????
    s = [47100000 0 0 0 0];
end
end

function initializeHistoric()
global historic
if isempty(historic)
    historic = containers.Map('KeyType', 'double', 'ValueType', 'any');
end
historic(0) = [47100000 - 2 0 2 0 0];
end

function dydt = getDDE(t, y, Z, params)
global historic
%fprintf("Solving DDE for t=%d\n", t);
    population = params(1);
    beta = params(2);
    gamma = params(3);

    ylag1 = Z(:, 1);
    ylag2 = Z(:, 2);
    ylag3 = Z(:, 3);

    dydt = [-1 * beta * y(1) * y(3) / population 
            beta * y(1) * y(3) / population - ylag1(2)
            ylag1(3) - (gamma * ylag2(3)) - (1 - gamma) * ylag3(2);
            gamma * ylag2(3)
            (1 - gamma) * ylag3(3)
        ];
    historic(t) = dydt;
end