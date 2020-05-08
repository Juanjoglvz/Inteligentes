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