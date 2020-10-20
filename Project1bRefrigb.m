clear all;clc
addpath('..\Thermal_Systems_Project_1\ThermoTablesCoolProp_v6_1_0')

substances = {'R410a','R717','R407C'};
%The number of steps between curved sections of the cycle
steps = 100;
%Inside temperature
TH = 25;
%Outside temperature
TL = -5;
%Difference between TH and TL, and the cycle temperature
deltaT = 5;

T_l = linspace(15,20,20);
T_h = linspace(25,35,20);
%Covert those ranges to matrices to create contour plot
[T_L,T_H] = meshgrid(T_l,T_h);

%Input T_L and T_H matrices into COP function to get COP matrix
[COP] = COP2(T_H,T_L,deltaT,substances);

%COP Plot
figure
%Create contour plot from T_H, T_L, and COP matrices
contour(T_L, T_H, COP, min(COP,[],'all'):max(COP,[],'all'), 'Fill', 'on', 'LineColor', 'black')

%formatting
title(sprintf('Coefficient of Performance vs T_H and T_L, \x0394T = 5\x2103'));
ylabel(sprintf('T_H (\x2103)'))
xlabel(sprintf('T_L (\x2103)'))
colormap hot
c=colorbar;
c.Label.String = 'COP';