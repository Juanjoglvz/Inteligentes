%%%
% Auxiliary plot that shows the discontinuity of the quarantine compartment
%%%
clear;
close all;

if ~isfolder('figures')
    mkdir('figures')
end

xinterval = [0 30];

figure('units', 'normalized', 'outerposition', [0 0 0.65 1])
hold on
fplot(@S, xinterval, 'LineWidth', 3.1);
fplot(@Q, xinterval, 'LineWidth', 3.1);

legend('Susceptibles', 'En cuarentena')
grid minor
xlabel('Día')
ylabel('Proporción de la población en cada compartimento')
set(gca, 'fontsize', 26)
saveas(gcf, 'figures/Discontinuity.png')

function y = S(t)
if t < 15
    t = t - 15;
    y = 1 / (1 + exp(t));
else
    t = t - 15;
    y = 1 / (1 + exp(0.35 * t));
    y = y * 0.25;
end
end

function y = Q(t)
if t < 15
    y = 0;
else
    y = 1 / (1 + exp(0)) * 0.75;
end
end