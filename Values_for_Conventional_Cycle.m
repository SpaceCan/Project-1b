clear all
close all

% Code for finding PL and PH using TL and TH
file = 'weather_2019.mat';
load(file, 'tempC', 'timestamp')
addpath('..\Project-1b\ThermoTablesCoolProp_v6_1_0')

substance = 'Air';
wallArea = 81.59471;
wallResistance = 5.205;
windowArea = 30.28696;
windowResistance = 0.1905;
massFlowrate = 0.248;
Patm = 101325;
QHuman = 100;
[QConduction,QVentilation,QPeople,QSum,QNeeded,tempInside,time] = HeatCoolLoads(massFlowrate,wallResistance,windowResistance,QHuman,file);
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
[T_C,s_C,P_C,h_C,QCooling,QHeating,massFlowrate2,PowerHP,COPcooling,COPheating] = Conventional_Cycle(PLow,PHigh,QNeeded,tempInside,substance,file);

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
xlabel('Outside Air Temperature')
ylabel('Power Consumption')

figure
hold on
plot([sliq,flip(svap)],[T,flip(T)],'Color', '#00ADEF', 'LineWidth', 2)
plot(s_C,T_C)
title('T-s Diagram')
xlabel('Specific Entropy (J/(kg*k))')
ylabel('Temperature   (K)')

figure
hold on
plot([hliq,flip(hvap)],[P,flip(P)], 'Color', '#00ADEF', 'LineWidth', 2)
plot(h_C,P_C)
title('P-h Diagram')
xlabel('Specific Enthalpy   (kJ/kg)')
ylabel('Pressure   (kPa)')

