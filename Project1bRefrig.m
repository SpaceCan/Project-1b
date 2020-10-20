%refrigerants winter scenario

clear all;clc
addpath('..\Project-1b\ThermoTablesCoolProp_v6_1_0')

substances = {'R717','R410a','R407C'};
%The number of steps between curved sections of the cycle
steps = 100;
%Inside temperature
TH = 25;
%Outside temperature
TL = -5;
%Difference between TH and TL, and the cycle temperature
deltaT = 5;

T_l = linspace(-15,10,20);
T_h = linspace(15,20,20);
%Covert those ranges to matrices to create contour plot
[T_L,T_H] = meshgrid(T_l,T_h);

%Input T_L and T_H matrices into COP function to get COP matrix
[COP] = COP1(T_H,T_L,deltaT,substances{1});
[COP2] = COP4(T_H,T_L,deltaT,substances{2});
[COP3] = COP4(T_H,T_L,deltaT,substances{3});
%COP Plot
figure(1)
%Create contour plot from T_H, T_L, and COP matrices
contour(T_L, T_H, COP, min(COP,[],'all'):max(COP,[],'all'), 'Fill', 'on', 'LineColor', 'black')

%formatting
title(sprintf('Coefficient of Performance for Ammonia'));
ylabel(sprintf('T_H (\x2103)'))
xlabel(sprintf('T_L (\x2103)'))
colormap winter
c=colorbar;
c.Label.String = 'COP';

figure(2)
%Create contour plot from T_H, T_L, and COP matrices
contour(T_L, T_H, COP2, min(COP2,[],'all'):max(COP2,[],'all'), 'Fill', 'on', 'LineColor', 'black')

%formatting
title(sprintf('Coefficient of Performance for R410a'));
ylabel(sprintf('T_H (\x2103)'))
xlabel(sprintf('T_L (\x2103)'))
colormap winter
c=colorbar;
c.Label.String = 'COP';

figure(3)
%Create contour plot from T_H, T_L, and COP matrices
contour(T_L, T_H, COP3, min(COP3,[],'all'):max(COP3,[],'all'), 'Fill', 'on', 'LineColor', 'black')

%formatting
title(sprintf('Coefficient of Performance for R410a'));
ylabel(sprintf('T_H (\x2103)'))
xlabel(sprintf('T_L (\x2103)'))
colormap winter
c=colorbar;
c.Label.String = 'COP';