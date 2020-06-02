%%%
% Standardized plotting function
%%%
function plotfnc(sz, xlbl, ylbl, ttl, lgnd, date0, labelInterval, varargin)
vararg = nargin - 7;
date0 = datetime(strrep(date0, '-', '/'));

figure('units', 'normalized', 'outerposition', [0 0 sz(1) sz(2)])
hold on
grid minor

for i=1:vararg/2
    plot(date0 + varargin{2 * (i - 1) + 1}, varargin{2 * (i - 1) + 2}, 'LineWidth', 2.8);
end

xlabel(xlbl);
ylabel(ylbl);
title(ttl);
legend(lgnd{:});

ax = gca;
ax.XAxis.TickValues = date0 + (varargin{1}(1):labelInterval:varargin{1}(end));
ax.XAxis.TickLabelFormat = 'dd-MM';
set(ax, 'fontsize', 15)
end