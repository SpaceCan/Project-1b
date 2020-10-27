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

COPcase1 = COP(1,:);
COPcase2 = COP2(1,:);
COPcase3 = COP3(1,:); 

figure(1)
plot(T_l,COPcase1)
hold on
plot(T_l,COPcase2)
plot(T_l,COPcase3)
%formatting
%formatting
title(sprintf('Heat Pump Coefficients of Performance for Refirgerants'));
ylabel(sprintf('COP'))
xlabel(sprintf('Outside Temperature (Celcius)'))
legend('Ammonia','R-410a','R407C')