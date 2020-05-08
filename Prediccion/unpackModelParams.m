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
thetaLatents = 0.1923;%params(6);
deltaHospitalized = params(7);
gammaInfected = params(8);
gammaHospitalized = params(9);
tauHospitalized = params(10);
sigmaHospitalized = params(11);
tauCritical = params(12);
roCritical = params(13);
gammaRecoveredCritical = params(14);

% quarantinePercent = 0.75;%params(1);
% betaBefore = 0.78;%params(2);
% betaAfter = 0.6816;%params(3);
% betaQuarantine = 0.4735;%params(4);
% deltaHospitalized = 0.4448;%params(5);
% gammaInfected = 0.1147;%params(6);
% gammaHospitalized = 0.726;%params(7);
% tauHospitalized = 0.277;%params(8);
% sigmaHospitalized = params(1);
% tauCritical = params(2);
% roCritical = params(3);
% gammaRecoveredCritical = params(4);

end