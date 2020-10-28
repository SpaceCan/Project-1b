% Code for finding PL and PH using TL and TH
load(file, 'tempC', 'timestamp')
addpath('..\Project-1b\ThermoTablesCoolProp_v6_1_0')

TL = min(tempC);
for i = 1:length(tempC)
    if mode = cooling
        TH = [20,21,22,23];
    elseif mode = heating
        TH = [17,18,19,20];
    end
end
PL = 200000;
PH = 1000000;
% massflowrate = 0.248;
