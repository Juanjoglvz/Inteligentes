function [quarantinePercent, startingLatents, betaBefore, betaAfter, betaQuarantine, ...
    thetaLatents, kappaLatents, gammaAsymptomatic, deltaHospitalized, ...
    gammaInfected, gammaHospitalized, tauHospitalized, ...
    sigmaHospitalized, tauCritical, roCritical, gammaRecoveredCritical] = ...
    unpackModelParams(params)

quarantinePercent = params(1);
startingLatents = params(2);
betaBefore = params(3);
betaAfter = params(4);
betaQuarantine = params(5);
thetaLatents = params(6);
kappaLatents = params(7);
gammaAsymptomatic = params(8);
deltaHospitalized = params(9);
gammaInfected = params(10);
gammaHospitalized = params(11);
tauHospitalized = params(12);
sigmaHospitalized = params(13);
tauCritical = params(14);
roCritical = params(15);
gammaRecoveredCritical = params(16);

end