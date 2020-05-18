clear;
close all;
load opt.mat

lbls = {'Cuarentena', 'Susceptibles', 'Latentes', 'Infectados', 'Asintomáticos', 'Hospitalizados', 'UCI', 'Recuperados UCI', 'Recuperado', 'Fallecido', 'Recuperados Asintomaticos'};

%plotFcn(y, lbls, 50);

generateVideo('videoprueba.mp4', 435 / 3, @(day) plotFcn(y, lbls, day), 0.35)

function generateVideo(filename, days, plotFcn, secsPerDay, framerate)
if nargin < 5
    framerate = 30;
end

figure('units', 'normalized', 'outerposition', [0 0 0.65 1])
frametime = 1 / framerate;
v = VideoWriter(filename, 'MPEG-4');
v.FrameRate = framerate;
open(v);

framesPerDay = ceil(secsPerDay / frametime);

for day=1:days
    plotFcn(day);
    frame = getframe(gcf);
    
    for frameCounter=1:framesPerDay
        writeVideo(v, frame);
    end
end

close(v);
end


function plotFcn(data, lbls, day)
initialDate = datetime('20/02/2020');
pie(data(day, :), lbls);
title(string(initialDate + day - 1))
set(findobj(gca,'type','text'), 'fontsize', 17)
set(gca, 'fontsize', 20)
end