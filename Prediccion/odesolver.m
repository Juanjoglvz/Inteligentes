clear;
% syms s(t) i(t) r(t)
% 
% ode1 = diff(s) == -3.2 * s * i;
% ode2 = diff(i) == 3.2 * s * i + 0.23 * i;
% ode3 = diff(r) == 0.23 * i;
% ode4 = diff(s) + diff(i) + diff(r) == 0;
% odes = [ode1; ode2; ode3];
% 
% S = dsolve(odes)

C = [
3 %25/02
10
16
32 
52 %29/02
83
114
150
198
237 %05/03
365
541
786
999
1622 %10/03
2128
2950 
4209
6391
7753 %15/03
9191
11178
13716
17147
19980 %20/03
24926
28572
33089
39673
47610 %25/03
56188
64059
72248
78797
85195 %30/05
94417
102136
110238
117710
124736
130759
135032
%<-------------- add new data here
]';

close all;
x = [1.168 0.05];
[x, RMSE] = ga(@(x) optFun(C, x), 2, [], [], [], [], [0 0], []);
disp(RMSE)
%x = particleswarm(@(x) optFun(C, x), 2, [0, 0], []);
%x = fmincon(@(x) optFun(C, x), [1.2, 0.2], [], [], [], [], [0, 0], []);
%x = fminsearch(@(x) optFun(C, x), [3.2, 0.2]);

[RMSE, Csol] = optFun(C, x, 1:length(C)*5);

hold on
plot(C)
plot(Csol(:,2) + Csol(:,3));
%figure
%hold on
%plot(diff(C));
%plot(Csol(:,2));

function [RMSE, Csol] = optFun(C, params, tspan)
if nargin < 3
    tspan = 1:length(C);
end

modelfuns = odeFun(params);

[tsol,Csol] = ode45(modelfuns, tspan, [47100396 - C(1), C(1), 0]);

if nargin < 3
    RMSE = sum(((Csol(:, 2) + Csol(:, 3))' - C).^2);
else
    RMSE = 0;
end

end

function fun = odeFun(params)
alfa = params(1);
beta = params(2);

fun = @(t, par) [-1 * alfa * par(1) * par(2) / sum(par);
                alfa * par(1) * par(2) / sum(par) - beta * par(2);
                beta * par(2)];
end