close all
clc
load('weather_2019.mat', 'tempC', 'timestamp')
time = datetime(timestamp,'convertfrom','posixtime');

ax = gca;
wPlot = plot(time(1:192),tempC(1:192));
wPlot.LineWidth = 2;
wPlot.Color = '#f54538';
title('Temperature Variation for the first week of 2019')
ylabel(sprintf('Temperature (\x2103)'))

figure
yPlot = plot(time,tempC);
yPlot.LineWidth = 2;
yPlot.Color = '#16f55d';
title('Temperature Variation for all of 2019')
ylabel(sprintf('Temperature (\x2103)'))
