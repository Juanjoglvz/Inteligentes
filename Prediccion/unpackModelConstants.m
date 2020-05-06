function [population, dayQuarantine, timeToHospitalization, timeToRecovery, timeToDecease, timeToRecoveryHospitalized] ...
    = unpackModelConstants(constants)

population = constants(1);
dayQuarantine = constants(2);
timeToHospitalization = constants(3);
timeToRecovery = constants(4);
timeToDecease = constants(5);
timeToRecoveryHospitalized = constants(6);
end