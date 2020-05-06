function [quarantinePercent, betaBefore, betaAfter, betaQuarantine, ...
    ratioHospitalization, ratioRecovery] = ...
    unpackModelParams(params)

quarantinePercent = params(1);
betaBefore = params(2);
betaAfter = params(3);
betaQuarantine = params(4);
ratioHospitalization = params(5);
ratioRecovery = params(6);
end