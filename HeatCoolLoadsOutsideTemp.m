function [QConduction,QVentilation,QPeople,QSum,QNeeded]...
    = HeatCoolLoadsOutsideTemp...
         (tempOutside,tempInside,tempInsideDelta,airMassFlowrate,wallResistance,windowResistance,QHuman)
%Calculates Heat transfer values over a specified temperature range
if length(tempInside) == 1
   tempInside = tempInside .* ones(size(tempOutside));
end
    
addpath('..\Project-1b\ThermoTablesCoolProp_v6_1_0')

substance = 'Air';
wallArea = 81.59471;
%wallResistance = 5.205;
windowArea = 30.28696;
%windowResistance = 0.1905;
%massFlowrate = 0.248;
Patm = 101325;
%QHuman = 100;


hAir_in = zeros(size(tempOutside));
hAir_out = zeros(size(tempOutside));
numPeople = 45;

for i = 1:size(tempOutside,1)
    for j = 1:size(tempOutside,2)
        tempInside(i,j) = min(max(tempOutside(i,j),tempInside(i,j)-tempInsideDelta),tempInside(i,j)+tempInsideDelta);

        hAir_in(i,j) = CoolProp.PropsSI('H','P',Patm,'T',tempOutside(i,j)+273.15,substance);
        hAir_out(i,j) = CoolProp.PropsSI('H','P',Patm,'T',tempInside(i,j)+273.15,substance);
    end


    QConduction(i,:) = -((wallArea *(-(tempOutside(i,:) - tempInside(i,:))))/(wallResistance))...
    - ((windowArea *(-(tempOutside(i,:) - tempInside(i,:))))/(windowResistance));
    % Heat transfer lost through the walls/windows

    QVentilation(i,:) = airMassFlowrate*(hAir_in(i,:) - hAir_out(i,:));
    % Heat transfer from change in temperature of outside and inside air

    QPeople(i,:) = (QHuman .* numPeople);
    % Heat transfer from occupants inside the room

    QSum(i,:) = QVentilation+QConduction+QPeople;
    
    
    QNeeded(i,:) = -QSum;
end
end