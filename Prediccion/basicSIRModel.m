%%%
% Basic sir model solving and plotting
%%%
clear;
close all;

if ~isfolder('figures')
    mkdir('figures')
end

constants = 47100396;
params = [4 1.057];

solverStep = 0.01;
maxTime = 20;

tspan = 0:solverStep:maxTime;

odes = @(t, y) SIRModel(y, t, constants, params);
[x, y] = ode45(odes, tspan, [constants(1) - 2, 2, 0]);

figure('units', 'normalized', 'outerposition', [0 0 0.65 1])
plot(x, y, 'LineWidth', 3.1);
legend('Susceptibles', 'Infectados', 'Recuperados')
grid minor
xlabel('Días')
ylabel('Personas en cada grupo')
set(gca, 'fontsize', 26)
saveas(gcf, 'figures/SIRModelBasic.png')

function dydt = SIRModel(y, ~, constants, params)
population = constants(1);

beta = params(1);
gamma = params(2);

S = y(1);
I = y(2);
R = y(3);

dydt = [-1 * beta * S * I / population; % S
            beta * S * I / population - gamma * I; % I
            gamma * I]; % R 
end