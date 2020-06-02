%%%
% Computes RMSE
%%%
function RMSE = computeRMSE(groundTruth, predictedValues)
predictedValues = reshape(predictedValues, size(groundTruth));
RMSE = sqrt(sum((predictedValues - groundTruth).^2) / length(groundTruth));
end