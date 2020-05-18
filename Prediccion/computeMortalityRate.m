function mortalityRate = computeMortalityRate(y)
R = y(:, 9);
D = y(:, 10);
RA = y(:, 11);

totalInfected = R(end) + D(end) + RA(end);
mortalityRate = D(end) / totalInfected;
end