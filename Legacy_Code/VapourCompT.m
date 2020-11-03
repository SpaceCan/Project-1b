function [T,s,P,h] = VapourCompT(T1,T3,substance,steps)
%VapourComp
%Built off of the ideal carnot function from recitation

%easy access variables for quality = 0 and 1
Q1 = 0;
Q2 = 1;

% Q,P,T,H,D,U,S

% State 1
s1 = CoolProp.PropsSI('S', 'T', T1, 'Q', Q2, substance);
P1 = CoolProp.PropsSI('P', 'T', T1, 'Q', Q2, substance);
h1 = CoolProp.PropsSI('H', 'T', T1, 'Q', Q2, substance);
% State 2
P2 = CoolProp.PropsSI('P', 'T', T3, 'Q', Q1, substance);
T2 = CoolProp.PropsSI('T', 'S', s1, 'P', P2, substance);
h2 = CoolProp.PropsSI('H', 'T', T2, 'S', s1, substance);
s2 = s1;
% State 3
P3 = P2;
h3 = CoolProp.PropsSI('H', 'T', T3, 'Q', Q1, substance);
s3 = CoolProp.PropsSI('S', 'T', T3, 'Q', Q1, substance);
% State 4
h4 = h3;
T4 = T1;
s4 = CoolProp.PropsSI('S', 'P', P1, 'H', h3, substance);
P4 = CoolProp.PropsSI('P', 'T', T4, 'S', s4, substance);

% 1-2
P12 = linspace(P1,P2,steps);
for i = 1:length(P12)
    h12(i) = CoolProp.PropsSI('H', 'P', P12(i), 'S', s1, substance);
end

% 2-3
s23 = linspace(s2,s3,steps);
for i = 1:length(s23)
    T23(i) = CoolProp.PropsSI('T', 'P', P2, 'S', s23(i), substance);
end

% 3-4
P34 = linspace(P3,P4,steps);
T34 = linspace(T3,T4,100);
for i = 1:length(P34)
    s34(i) = CoolProp.PropsSI('S', 'P', P34(i), 'H', h3, substance);
end

T=[T1,T23,T34,T1]-273.15;%covert T from K to degC
s=[s1,s23,s34,s1]./1000;%covert s from J/kg-K to kJ/kg-K
P=[P12,P3,P4,P1]./1000;%covert P from Pa to kPa
h=[h12,h3,h4,h1]./1000;%covert h from J/kg to kJ/kg




end