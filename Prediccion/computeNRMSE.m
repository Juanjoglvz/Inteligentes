%%%
% Computes NRMSE
%%%
function RMSE = computeNRMSE(groundTruth, predictedValues)
predictedValues = reshape(predictedValues, size(groundTruth));
RMSE = sqrt(sum((predictedValues - groundTruth).^2) / length(groundTruth)) / mean(groundTruth);
end