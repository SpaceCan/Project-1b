%% Adding CoolProp and Variables
% Run this section (CTRL - ENTER) before running other sections
close all; clear; clc
load('weather_2019.mat', 'tempC', 'timestamp')
time = datetime(timestamp,'convertfrom','posixtime');
addpath('..\Project-1b\ThermoTablesCoolProp_v6_1_0')
file = 'weather_2019.mat';

%% Temperature Plot
% Graphs the temperature for representitive weeks of the year
figure
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

%% Heating and Cooling loads Plots
% Contour plot of heating and cooling loads vs. Inside and outside
% temperature




%% Plotting and values for refrigerant selection
% Spencer's code for showing different refrigerant COPs

%refrigerants winter scenario
substances = {'R717','R410a','R407C'};
%The number of steps between curved sections of the cycle
steps = 100;
%Inside temperature
TH = 20;

%Difference between TH and TL, and the cycle temperature
deltaT = 5;

T_l = linspace(-15,15,steps);
T_h = TH * ones(1,length(T_l));

%Input T_l and T_h into COP function to get COP array
[COP_R717] = COP(T_h,T_l,deltaT,substances{1},'heat pump');
[COP_R410a] = COP(T_h,T_l,deltaT,substances{2},'heat pump');
[COP_R407C] = COP(T_h,T_l,deltaT,substances{3},'heat pump');
%COP Plot

figure
hold on
plot(T_l,COP_R717)
plot(T_l,COP_R410a)
plot(T_l,COP_R407C)

%formatting
title(sprintf('Heat Pump COPs for Refrigerants'));
ylabel(sprintf('COP'))
xlabel(sprintf('Outside Temperature (Celcius)'))
legend('Ammonia','R-410a','R407C')


%refrigerants summer scenario

%Inside temperature
TL = 20;

T_h = linspace(25,35,steps);
T_l = TL * ones(1,length(T_h));

%Input T_L and T_H matrices into COP function to get COP array
[COP_R717] = COP(T_h,T_l,deltaT,substances{1},'refrigeration');
[COP_R410a] = COP(T_h,T_l,deltaT,substances{2},'refrigeration');
[COP_R407C] = COP(T_h,T_l,deltaT,substances{3},'refrigeration');

%COP Plot
figure
hold on
plot(T_h,COP_R717)
plot(T_h,COP_R410a)
plot(T_h,COP_R407C)
%formatting
title(sprintf('AC COPs for Refrigerants'));
ylabel(sprintf('COP'))
xlabel(sprintf('Outside Temperature (Celcius)'))
legend('Ammonia','R-410a','R407C')


%% Plotting and Values for Conventional Cycle

% Code for finding PL and PH using TL and TH
substance = 'Air';
wallArea = 81.59471;
wallResistance = 5.205;
windowArea = 30.28696;
windowResistance = 0.1905;
massFlowrate = 0.248;
Patm = 101325;
QHuman = 100;

[QConduction,QVentilation,QPeople,QSum,QNeeded,tempInside,time]...
    = HeatCoolLoads(massFlowrate,wallResistance,windowResistance,QHuman,file);

% called 'HeatCoolLoads' function to find relevent Q terms
substance = 'R410a';
deltaT = 2;
TLow = min(tempC)-deltaT;
disp(TLow);
THigh = max(tempC)+deltaT;
disp(THigh);
PLow = CoolProp.PropsSI('P','T',TLow+273.15,'Q',1,substance);
%sLow = CoolProp.PropsSI('S','T',TLow,'Q',1.0,substance);
PHigh = CoolProp.PropsSI('P','T',THigh+273.15,'Q',0,substance);
% called 'Coventional_Cycle' function to find mdot for R-410a and power for
% heat pump
[T_C,s_C,P_C,h_C,QCooling,QHeating,massFlowrate2,PowerHP,COPcooling,COPheating]...
    = Conventional_Cycle(PLow,PHigh,QNeeded,tempInside,substance,file);

% P-v vapor dome
steps = 100;
P = linspace(50,4860,steps*5)*10^3;
for i=1:length(P)
    %Getting vapour dome enthalpy and converting to kJ/kg
    hliq(i) = CoolProp.PropsSI('H','P',P(i),'Q',0,'R410a')./1000;
    hvap(i) = CoolProp.PropsSI('H','P',P(i),'Q',1,'R410a')./1000;
end
%converting the vapour dome pressure to kPa
P = P./1000;

% T-s vapor dome
T = linspace(-50,71.3,steps*3)+273.15;
for i=1:length(T)
    %Getting vapour dome entropy and converting to kJ/kg-k
    sliq(i) = CoolProp.PropsSI('S','T',T(i),'Q',0,'R410a')./1000;
    svap(i) = CoolProp.PropsSI('S','T',T(i),'Q',1,'R410a')./1000;
end
%converting the vapour dome temperature to celcius
T = T-273.15;

if tempC < tempInside
  Qhp = QHeating;
  COP = COPheating;
else
  Qhp = QCooling;
  COP = COPcooling;
end
PowerNeeded = ((QNeeded./Qhp)* PowerHP)./1000;

figure
hold on
plot(tempC,PowerNeeded)
title('Power Consumption vs Outside Air Temperature')
xlabel('Outside Air Temperature    (C)')
ylabel('Power Consumption    (kW)')

figure
hold on
plot([sliq,flip(svap)],[T,flip(T)],'Color', '#00ADEF', 'LineWidth', 2)
plot(s_C,T_C)
title('T-s Diagram')
xlabel('Specific Entropy (J/(kg*k))')
ylabel('Temperature   (C)')

figure
hold on
plot([hliq,flip(hvap)],[P,flip(P)], 'Color', '#00ADEF', 'LineWidth', 2)
plot(h_C,P_C)
title('P-h Diagram')
xlabel('Specific Enthalpy   (kJ/kg)')
ylabel('Pressure   (kPa)')


%% Plotting and Values for Newer System



%% Plotting and Values for Actual Cycle

[T1,s1,P1,h1] = Actual_Cycle(283.15,293.15,'R410a');
figure
plot(s1,T1)

figure
plot(h1,P1)


%% Plotting and Values for Financial Assessment


