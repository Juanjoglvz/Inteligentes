%%%
% Return every model parameter from a vector
%%%
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