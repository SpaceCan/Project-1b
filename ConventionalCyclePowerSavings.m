function [PowerDelta]...
    = ConventionalCyclePowerSavings...
    (tempOutside,tempInsideDelta,airMassFlowrate,wallResistance,windowResistance,QHuman,P1,P3,substance,PowerNeeded)
%ConventionalCycleCOP Runs through the conventional cycle functions for
%multiple inside temperatures to find COP

[~,~,~,~,QNeeded]...
    = HeatCoolLoadsOutsideTemp(tempOutside,20,tempInsideDelta,airMassFlowrate,wallResistance,windowResistance,QHuman);
Q1 = 1;
Q3 = 0;

h1 = CoolProp.PropsSI('H','P',P1,'Q',Q1,substance);
s1 = CoolProp.PropsSI('S','P',P1,'Q',Q1,substance);
h2a = CoolProp.PropsSI('H','P',P3,'S',s1,substance);
h3 = CoolProp.PropsSI('H','P',P3,'Q',Q3,substance);
h4 = h3;

QCooling = min(QNeeded);
QHeating = max(QNeeded);

massFlowrateCooling = abs((h1-h4)/QCooling);
massFlowrateHeating = abs((h2a-h3)/QHeating);

if massFlowrateHeating > massFlowrateCooling
    massFlowrateSubstance = massFlowrateHeating;
else
    massFlowrateSubstance = massFlowrateCooling;
end
PowerHP = (massFlowrateSubstance*(h2a-h1))./1000;

heatMode = QNeeded > 0;
Qhp = ones(size(QNeeded)).*QCooling;
Qhp(heatMode) = QHeating;

%PowerDelta = ((QNeeded./Qhp).* PowerHP)./1000;

PowerDelta = PowerNeeded - ((QNeeded./Qhp).* PowerHP)./1000;

end

