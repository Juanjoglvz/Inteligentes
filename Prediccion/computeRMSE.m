function RMSE = computeRMSE(groundTruth, predictedValues)
predictedValues = reshape(predictedValues, size(groundTruth));
RMSE = sum((predictedValues - groundTruth).^2);
end