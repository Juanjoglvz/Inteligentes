%%%
% Return every model constant from a vector
%%%
function [population, dayQuarantine] = unpackModelConstants(constants)
population = constants(1);
dayQuarantine = constants(2);
end