load('weather_2019.mat')
addpath('..\Project-1b\ThermoTablesCoolProp_v6_1_0')

time = datetime(timestamp,'convertfrom','posixtime');

substance = 'Air';
wallArea = 81.59471;
wallResistance = 5.914;
windowArea = 30.28696;
windowResistance = 0.1905;
massFlowrate = 0.248;
Patm = 101325;
QHuman = 100;

tempOutside = tempC;

hAir_in = zeros(1,length(time));
hAir_out = zeros(1,length(time));
numPeople = zeros(1,length(time));
tempInside = zeros(1,length(time));

for i = 1:length(tempOutside)
    if hour(time(i)) >= 10 && hour(time(i)) <= 14
        numPeople(i) = 45;
        tempInside(i) = 20;
    else
        numPeople(i) = 0;
        tempInside(i) = min(max(tempOutside(i), 10),24);
    end
    hAir_in(i) = CoolProp.PropsSI('H','P',Patm,'T',tempOutside(i)+273.15,substance);
    hAir_out(i) = CoolProp.PropsSI('H','P',Patm,'T',tempInside(i)+273.15,substance);
end


QCond = ((wallArea *(-(tempOutside - tempInside)))/(wallResistance))...
+ ((windowArea *(-(tempOutside - tempInside)))/(windowResistance));
% Heat transfer lost through the walls/windows

QVentilation = (massFlowrate*(hAir_in - hAir_out));
% Heat transfer from change in temperature of outside and inside air

QPeople = (QHuman * numPeople);
% Heat transfer from occupants inside the room

figure
hold on
plot(time,QVentilation)
plot(time,QCond)
plot(time,QPeople)

plot(time, QVentilation+QCond+QPeople)





%hcW = 12.12 - 1.16*v + 11.6 v1/2; %convection heat transfer formula I found on piazza

% Rswa = (x1/k1) +(x2/x2); %In series thermal resistance formula for wall, rough draft of what it will look like
% 
% Rswi = (x3/k3) +(x4/x4); %In series thermal resistance formula for window, rough draft of what it will look like
% 
% r = (1/Rswa)+(1/Rswi);
% 
% Rp = (TL2 - TL1)/(r);%Use this formula to combine the thermal resistances for the walls in parallel