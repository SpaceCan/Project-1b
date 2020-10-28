function [T,s,P,h,COP] = Conventional_Cycle(P1,P3,substance)

load(file, 'tempC', 'timestamp')
addpath('..\Project-1b\ThermoTablesCoolProp_v6_1_0')

Q1 = 1;
Q3 = 0;
% State 1
T1 = CoolProp.PropsSI('T','P',P1,'Q',Q1,substance);
s1 = CoolProp.PropsSI('S','P',P1,'Q',Q1,substance);
h1 = CoolProp.PropsSI('H','P',P1,'Q',Q1,substance);
% State 2a
s2a = s1;
T2a = CoolProp.PropsSI('T','P',P3,'S',s2a,substance);
h2a = CoolProp.PropsSI('H','P',P3,'S',s2a,substance);
% State 2b
T2b = CoolProp.PropsSI('T','P',P3,'Q',Q1,substance);
s2b = CoolProp.PropsSI('S','P',P3,'Q',Q1,substance);
h2b = CoolProp.PropsSI('H','P',P3,'Q',Q1,substance);
% State 3
T3 = T2b;
s3 = CoolProp.PropsSI('S','P',P3,'Q',Q3,substance);
h3 = CoolProp.PropsSI('H','P',P3,'Q',Q3,substance);
% State 4
T4 = T1;
h4 = h3;
P4 = P1;
s4 = CoolProp.PropsSI('S','P',P1,'H',h4,substance);

% Process 1-2
P1_2 = linspace(P1,P3,100);
for i = 1:length(P1_2)
    h1_2(i) = CoolProp.PropsSI('H','P',P1_2(i),'S',s2a,substance);
end
% Process 3-4
s3_4 = linspace(s3,s4,100);
for i = 1:length(s3_4)
    T3_4(i) = CoolProp.PropsSI('T','S',s3_4(i),'H',h4,substance);
end
% Process 2a-2b
T2a_2b = linspace(T2a,T2b,100);
for i = 1:length(T2a_2b)
    s2a_2b(i) = CoolProp.PropsSI('S','T',T2a_2b(i),'P',P3,substance);
end

T = [T1,T2a_2b,T3_4,T1];
s = [s1,s2a_2b,s3_4,s1];
P = [P1_2,P3,P4,P1];
h = [h1_2,h3,h4,h1];
TL = T1;
TH = T2a;

% Will need code added to calculate the COP for heating and cooling modes

end


