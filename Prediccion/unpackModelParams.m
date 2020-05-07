function [quarantinePercent, betaBefore, betaAfter, betaQuarantine, ...
    gammaInfected, deltaHospitalized, gammaHospitalized, tauHospitalized] = ...
    unpackModelParams(params)

quarantinePercent = params(1);
betaBefore = params(2);
betaAfter = params(3);
betaQuarantine = params(4);
gammaInfected = params(5);
deltaHospitalized = params(6);
gammaHospitalized = params(7);
tauHospitalized = params(8);
end