%% MATLAB House-keeping, variable definitions
clear all;clc
addpath('..\Thermal_Systems_Project_1\ThermoTablesCoolProp_v6_1_0')

substance = 'R410a';
%The number of steps between curved sections of the cycle
steps = 100;
%Inside temperature
TH = 25;
%Outside temperature
TL = -5;
%Difference between TH and TL, and the cycle temperature
deltaT = 5;

%% Bullet one
% P-v vapor dome
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
%Calling the vapour compression cycle function, this finds T,s,p,h for the
%entire cycle. TL and TH are offset by deltaT
[T_1,s_1,P_1,h_1] = VapourCompT(TL-deltaT+273.15, TH+deltaT+273.15, substance, steps);

% P-h Diagram
figure
%plot vapour dome and P-h diagram together
plot([hliq,flip(hvap)],[P,flip(P)], 'Color', '#00ADEF', 'LineWidth', 2)
title('Pressure vs. Enthalpy')
hold on
phplot = plot(h_1,P_1, 'Color', '#577399', 'LineWidth', 3);

%formatting
xlabel('Specific Enthalpy (^{kJ}/_{kg})')
ylabel('Pressure (kPa)')
states = ['1';'2';'3';'4'];
stateIndsPh = [1, steps, steps+1, steps+2];%finds the state indices based on number of steps

text(h_1(stateIndsPh), P_1(stateIndsPh), states(1:4),...
'FontSize', 14, 'FontWeight', 'bold', 'VerticalAlignment', 'top')%add state labels

%Process direction arrows
phplot.Marker = '<';
phplot.MarkerIndices = steps/2;%Lazy method of adding arrows


% T-s Diagram
figure
plot([sliq,flip(svap)],[T,flip(T)],'Color', '#00ADEF', 'LineWidth', 2)
title('Temperature vs. Entropy')
hold on
tsplot = plot(s_1,T_1, 'Color', '#fe5f55', 'LineWidth', 3);

%formatting
xlabel('Specific Entropy (^{kJ}/_{kg-K})')
ylabel(sprintf('Temperature (\x2103)'))

%State numbers
stateIndsTs = [1, 2, steps, 2*steps];%finds the state indices based on number of steps
yline(TL, '--', 'Label', 'T_L', 'LineWidth', 1.5);
yline(TH, '--', 'Label', 'T_H', 'LineWidth', 1.5);

text(s_1(stateIndsTs), T_1(stateIndsTs), states(1:4),...
'FontSize', 14, 'FontWeight', 'bold', 'VerticalAlignment', 'top')%add state labels

%Process direction arrows
tsplot.Marker = '<';
tsplot.MarkerIndices = steps/2;

%% Bullet Two
[T_2,s_2,P_2,h_2] = VapourCompT(TL-deltaT+273.15, TH+273.15, substance, 100);%Lower T_H
[T_3,s_3,P_3,h_3] = VapourCompT(TL+273.15, TH+deltaT+273.15, substance, 100);%Higher T_L

%P-h diagram
figure
hold on
plot([hliq,flip(hvap)],[P,flip(P)], 'Color', '#00ADEF', 'LineWidth', 2,'DisplayName','Vapour Dome')
plot(h_1,P_1, 'Color', '#6a8dbd', 'LineWidth', 2.5, 'DisplayName','Original Cycle');

plot(h_2,P_2, 'Color', '#8e5aa3', 'LineWidth', 1.5, 'DisplayName','Lower T_H', 'LineStyle', ':');

plot(h_3,P_3, 'Color', '#6ce6eb', 'LineWidth', 1.5, 'DisplayName','Higher T_L', 'LineStyle', '--');

%formatting
xlabel('Specific Enthalpy (^{kJ}/_{kg})')
ylabel('Pressure (kPa)')
title('Pressure vs. Enthalpy for different T_H and T_L')
legend('Location', 'northwest')
hold off

%T-s diagram
figure
hold on
plot([sliq,flip(svap)],[T,flip(T)], 'Color', '#00ADEF', 'LineWidth', 2,'DisplayName','Vapour Dome')
plot(s_1,T_1, 'Color', '#fe5f55', 'LineWidth', 2.5, 'DisplayName','Original Cycle');

plot(s_2,T_2, 'Color', '#fc2899', 'LineWidth', 1.5, 'DisplayName','Lower T_H', 'LineStyle', ':');

plot(s_3,T_3, 'Color', '#ffac26', 'LineWidth', 1.5, 'DisplayName','Higher T_L', 'LineStyle', '--');

%formatting
xlabel('Specific Entropy (^{kJ}/_{kg-K})')
ylabel(sprintf('Temperature (\x2103)'))
title('Temperature vs. Entropy for different T_H and T_L')
legend('Location', 'northwest')


%% Bullet Three

%define ranges for T_L and T_H
T_l = linspace(-15,10,20);
T_h = linspace(15,20,20);
%Covert those ranges to matrices to create contour plot
[T_L,T_H] = meshgrid(T_l,T_h);

%Input T_L and T_H matrices into COP function to get COP matrix
[COP] = COP(T_H,T_L,deltaT,substance);

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

%% Bullet Four
gasCostMMBTU = 14;
heatPumpCostMMBTU = 0.1 * 239;

%use COP matrix to generate savings matrix of same size for T_H and T_L
savings = gasCostMMBTU - heatPumpCostMMBTU./COP;

%MMBtu Cost Savings Plot
figure
hold on
marks = min(savings,[],'all'):0.2:max(savings,[],'all');
contour(T_L, T_H, savings, marks, 'Fill', 'on', 'LineColor', 'black')

%MMBtu Cost Savings Plot
title(sprintf('Cost Savings of Heat Pump vs Natural Gas, \x0394T = 5\x2103'));
ylabel(sprintf('T_H (\x2103)'))
xlabel(sprintf('T_L (\x2103)'))
colormap winter

%This hideous colorbar definition shows prices for the array
c=colorbar('Ticks', marks,...
           'TickLabels', {sprintf('$%0.2f',marks(1)),...
           sprintf('$%0.2f',marks(2)),...
           sprintf('$%0.2f',marks(3)),...
           sprintf('$%0.2f',marks(4)),...
           sprintf('$%0.2f',marks(5)),...
           sprintf('$%0.2f',marks(6)),...
           sprintf('$%0.2f',marks(7)),...
           sprintf('$%0.2f',marks(8)),...
           sprintf('$%0.2f',marks(9)),...
           sprintf('$%0.2f',marks(10)),...
           sprintf('$%0.2f',marks(11)),...
           sprintf('$%0.2f',marks(12)),...
           sprintf('$%0.2f',marks(13)),...
           sprintf('$%0.2f',marks(14)),...
           sprintf('$%0.2f',marks(15)),...
           sprintf('$%0.2f',marks(16))});
c.Label.String = '$/MMBTU';