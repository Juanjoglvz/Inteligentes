function [quarantinePercent, betaBefore, betaAfter, betaQuarantine, ...
    deltaHospitalized, gammaInfected, gammaHospitalized, tauHospitalized, ...
    sigmaHospitalized, tauCritical, roCritical, gammaRecoveredCritical] = ...
    unpackModelParams(params)

quarantinePercent = params(1);
betaBefore = params(2);
betaAfter = params(3);
betaQuarantine = params(4);
deltaHospitalized = params(5);
gammaInfected = params(6);
gammaHospitalized = params(7);
tauHospitalized = params(8);
sigmaHospitalized = params(9);
tauCritical = params(10);
roCritical = params(11);
gammaRecoveredCritical = params(12);

end