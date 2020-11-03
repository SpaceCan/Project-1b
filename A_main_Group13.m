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
title('Temperature Variation for the first week of 2019','FontSize',14)
ylabel(sprintf('Temperature (\x2103)'),'FontSize',12)

figure
yPlot = plot(time,tempC);
yPlot.LineWidth = 2;
yPlot.Color = '#16f55d';
title('Temperature Variation for all of 2019','FontSize',14)
ylabel(sprintf('Temperature (\x2103)'),'FontSize',12)

%% Heating and Cooling loads Plots
% plot of heating and cooling loads vs. outside temp
% temperature
wallResistance = 5.205;
windowResistance = 0.1905;
airMassFlowrate = 0.248;
QHuman = 100;
tempOutside = linspace(min(tempC),max(tempC),100);

[QConduction,QVentilation,QPeople,QSum,~]...
    = HeatCoolLoadsOutsideTemp(tempOutside,20,0,airMassFlowrate,wallResistance,windowResistance,QHuman);
figure
hold on
plot(tempOutside, QSum./10^3,'LineWidth', 2, 'DisplayName','Sum of Loads');
plot(tempOutside, QConduction./10^3,'LineWidth', 2, 'DisplayName','Conduction through walls');
plot(tempOutside, QVentilation./10^3,'LineWidth', 2, 'DisplayName','Ventilation');
plot(tempOutside, QPeople.*ones(size(QSum))./10^3,'LineWidth', 2, 'DisplayName','Human Body Heat');
title('Heating & Cooling Loads vs Outside Air Temperature')
xlabel(sprintf('Outside Air Temperature (\x2103)'))
ylabel('Heat Transfer (kW)')
legend('Location','SouthEast')

%% Plotting and values for refrigerant selection
% Spencer's code for showing different refrigerant COPs

%refrigerants winter scenario
substances = {'R717','R410a','R407C'};
%The number of steps between curved sections of the cycle
steps = 100;
%Inside temperature
T_Inside = 20;

%Difference between TH and TL, and the cycle temperature
deltaT = 5;

T_l = linspace(-15,T_Inside-((T_Inside+15)/steps),steps);
T_H = T_Inside * ones(1,steps);

%Input T_l and T_h into COP function to get COP array
[HP_COP_R717] = COP(T_H,T_l,deltaT,substances{1},'heat pump');
[HP_COP_R410a] = COP(T_H,T_l,deltaT,substances{2},'heat pump');
[HP_COP_R407C] = COP(T_H,T_l,deltaT,substances{3},'heat pump');

T_h = linspace(T_Inside,35,steps);

[AC_COP_R717] = COP(T_h,T_H,deltaT,substances{1},'refrigeration');
[AC_COP_R410a] = COP(T_h,T_H,deltaT,substances{2},'refrigeration');
[AC_COP_R407C] = COP(T_h,T_H,deltaT,substances{3},'refrigeration');



%COP Plot

figure
hold on
plot([T_l T_h],[HP_COP_R717 AC_COP_R717], 'LineWidth',2)
plot([T_l T_h],[HP_COP_R410a AC_COP_R410a], 'LineWidth',2)
plot([T_l T_h],[HP_COP_R407C AC_COP_R407C], 'LineWidth',2)

%formatting
title(sprintf('COPs for Refrigerants'));
ylabel(sprintf('COP'))
xlabel(sprintf('Outside Air Temperature (\x2103)'))
lgd = legend('Ammonia','R-410a','R407C','Location','NorthWest');
title(lgd, 'Refrigerant')


clear HP_COP_R717 AC_COP_R717 HP_COP_R410a AC_COP_R410a HP_COP_R407C AC_COP_R407C
clear deltaT

%% Plotting and Values for Conventional System Model

% Code for finding PL and PH using TL and TH
wallArea = 81.59471;
wallResistance = 5.205;
windowArea = 30.28696;
windowResistance = 0.1905;
airMassFlowrate = 0.248;
Patm = 101325;
QHuman = 100;
substance = 'R410a';
tempOutside = linspace(min(tempC),max(tempC),100);

deltaT = 2;
TLow = min(tempC)-deltaT;
THigh = max(tempC)+deltaT;
PLow = CoolProp.PropsSI('P','T',TLow+273.15,'Q',1,substance);
PHigh = CoolProp.PropsSI('P','T',THigh+273.15,'Q',0,substance);

[QConduction,QVentilation,QPeople,QSum,QNeeded]...
    = HeatCoolLoadsOutsideTemp(tempOutside,20,0,airMassFlowrate,wallResistance,windowResistance,QHuman);
% called 'HeatCoolLoadsOutsideTemp' function to find relevent Q terms

[T_C,s_C,P_C,h_C,QCooling,QHeating,~,PowerHP,COPcooling,COPheating]...
    = Conventional_Cycle(PLow,PHigh,QNeeded,substance);
% called 'Coventional_Cycle' function to find mdot for R-410a and power for
% heat pump

heatMode = QNeeded > 0;
Qhp = ones(size(QNeeded)).*QCooling;
Qhp(heatMode) = QHeating;
COP= ones(size(QNeeded)).*COPcooling;
COP(heatMode) = COPheating;

PowerNeeded_CC = ((QNeeded./Qhp).* PowerHP)./1000;
%Plot power usage
figure
hold on
plot(tempOutside,PowerNeeded_CC,'Color', '#e6b800', 'LineWidth', 2,...
    'DisplayName','20')
title('Power Consumption vs Outside Air Temperature')
xlabel(sprintf('Outside Air Temperature (\x2103)'))
ylabel('Power Consumption    (kW)')
lgd = legend('Location','SouthEast');
title(lgd,'Inside Temperature')

%Plot Power Savings
figure
hold on
for tempInsideDelta = 1:5
    [PowerDelta] = ConventionalCyclePowerSavings...
        (tempOutside,tempInsideDelta,airMassFlowrate,wallResistance,windowResistance,QHuman,PLow,PHigh,substance,PowerNeeded_CC);
    
    plot(tempOutside,PowerDelta,'LineWidth', 2,'DisplayName',...
        sprintf('%d-%d',20-tempInsideDelta,20+tempInsideDelta))
end
title('Power Savings vs Outside Air Temperature')
xlabel(sprintf('Outside Air Temperature (\x2103)'))
ylabel('Power Savings (kW)')
lgd = legend('Location','SouthEast');
title(lgd,'Inside Temperature')


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

%Plot T-s diagram
figure
hold on
plot([sliq,flip(svap)],[T,flip(T)],'Color', '#00ADEF', 'LineWidth', 2)
plot(s_C,T_C, 'Color', '#fe5f55', 'LineWidth', 1.5)
title('T-s Diagram')
xlabel('Specific Entropy (kJ/(kg*k))')
ylabel(sprintf('Temperature (\x2103)'))

%Plot P-h diagram
figure
hold on
plot([hliq,flip(hvap)],[P,flip(P)], 'Color', '#00ADEF', 'LineWidth', 2)
plot(h_C,P_C, 'Color', '#577399', 'LineWidth', 1.5)
title('P-h Diagram')
xlabel('Specific Enthalpy   (kJ/kg)')
ylabel('Pressure   (kPa)')


%% Plotting and Values for Newer System Model

tempInside = 10:5:30;
[tempInside_NC,tempOutside_NC] = meshgrid(tempInside,tempOutside);
[QConduction,QVentilation,QPeople,QSum,QNeeded]...
= HeatCoolLoadsOutsideTemp...
         (tempOutside_NC,tempInside_NC,0,airMassFlowrate,wallResistance,windowResistance,QHuman);

[massFlowrate_NC, PConsumption_NC, COP_NC] = Newer_Cycle(tempOutside_NC,tempInside_NC,deltaT,QNeeded,substance);

figure
hold on
for i = 1:length(tempInside)
plot(tempOutside_NC(:,i),PConsumption_NC(:,i),'LineWidth',2)
end
title('Power Consumption','FontSize',14)
xlabel('Outside Air Temperature ( ^{o}C )','FontSize',13)
ylabel('Power Consumed  ( kW )','FontSize',13)
legend('Inside Temperature = 10 ^{o}C', 'Inside Temperature = 15 ^{o}C',...
    'Inside Temperature = 20 ^{o}C', 'Inside Temperature = 25 ^{o}C',...
    'Inside Temperature = 30 ^{o}C','Location','north')

figure
hold on
for i = 1:length(tempInside)
plot(tempOutside_NC(:,i),massFlowrate_NC(:,i),'LineWidth',2)
end
title('Mass Flowrate','FontSize',14)
xlabel('Outside Air Temperature ( ^{o}C )','FontSize',13)
ylabel('Mass Flowrate  ( kg/s )','FontSize',13)
legend('Inside Temperature = 10 ^{o}C', 'Inside Temperature = 15 ^{o}C',...
    'Inside Temperature = 20 ^{o}C', 'Inside Temperature = 25 ^{o}C',...
    'Inside Temperature = 30 ^{o}C','Location','north')

figure
hold on
for i = 1:length(tempInside)
plot(tempOutside_NC(:,i),COP_NC(:,i),'LineWidth',2)
end
title('COP','FontSize',14)
xlabel('Outside Air Temperature ( ^{o}C )','FontSize',13)
ylabel('Coefficient of Performance','FontSize',13)
legend('Inside Temperature = 10 ^{o}C', 'Inside Temperature = 15 ^{o}C',...
    'Inside Temperature = 20 ^{o}C', 'Inside Temperature = 25 ^{o}C',...
    'Inside Temperature = 30 ^{o}C','Location','northwest')

%% Plotting and Values for Actual Cycle
[T_act,s_act,P_act,h_act] = Actual_Cycle(-10, 20, 2, 'R410a');
figure
hold on
plot([sliq,flip(svap)],[T,flip(T)],'Color', '#00ADEF', 'LineWidth', 2)
plot(s_act,T_act, 'Color', '#fe5f55', 'LineWidth', 1.5)
yline(-10, '--', 'Label', 'T_L', 'LineWidth', 1.5);
yline(20, '--', 'Label', 'T_H', 'LineWidth', 1.5);
title('T-s Diagram for Actual Cycle')
xlabel('Specific Entropy (kJ/(kg*k))')
ylabel(sprintf('Temperature (\x2103)'))

figure
hold on
plot([hliq,flip(hvap)],[P,flip(P)], 'Color', '#00ADEF', 'LineWidth', 2)
plot(h_act,P_act, 'Color', '#577399', 'LineWidth', 1.5)
yline(max(P_act), '--', 'Label', 'P_{Max}', 'LineWidth', 1.5);
yline(min(P_act), '--', 'Label', 'P_{Min}', 'LineWidth', 1.5);
title('P-h Diagram for Actual Cycle')
xlabel('Specific Enthalpy   (kJ/kg)')
ylabel('Pressure   (kPa)')

%Plotting actual cycle COP
tempInside = linspace(15,25,20);
tempOutside = linspace(min(tempC),12,20);

[tempInside_Act,tempOutside_Act] = meshgrid(tempInside,tempOutside);
[~,~,~,~,QNeeded_Act]...
= HeatCoolLoadsOutsideTemp...
         (tempOutside_Act,tempInside_Act,0,airMassFlowrate,wallResistance,windowResistance,QHuman);

[COP_Act] = Actual_Cycle_COP(tempOutside_Act,tempInside_Act,deltaT,QNeeded_Act,substance);

figure
contour(tempOutside_Act, tempInside_Act, COP_Act, min(COP_Act,[],'all'):2:max(COP_Act,[],'all'), 'Fill', 'on', 'LineColor', 'black')
title(sprintf('Coefficient of Performance vs Temperature for Actual Cycle, \x0394T = 2\x2103'));
ylabel(sprintf('Inside Temperature (\x2103)'))
xlabel(sprintf('Outside Temperature (\x2103)'))
colormap hot
c=colorbar;
c.Label.String = 'COP';


%% Plotting and Values for Financial Assessment

[~,~,~,~,QNeeded,tempInside,time]...
    = HeatCoolLoads(airMassFlowrate,wallResistance,windowResistance,QHuman,file);

[massFlowrate, PConsumption, COP_Finance]...
    = Newer_Cycle(tempC,tempInside,deltaT,QNeeded,substance);

powerCostHP = 0.1 * abs((QNeeded/1000)*3600)./COP_Finance;
powerCostGas = 14 * abs((QNeeded/1000)*3600) * 0.0034095106405145;
figure
hold on
plot(time,powerCostGas, 'LineWidth', 0.5,'DisplayName', 'Gas hourly price')
plot(time,powerCostHP, 'LineWidth', 0.5, 'DisplayName', 'Heat Pump hourly price')
ylabel('Cost per hour($)')
legend


sprintf('%d dollars saved', sum(powerCostGas-powerCostHP))