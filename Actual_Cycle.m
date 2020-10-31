function [T,s,P,h] = Actual_Cycle(T1,T4,substance)
Q1 = 1;
Q4 = 0;
cond_eff = 0.75;
P4 = CoolProp.PropsSI('P','T',T4,'Q',Q4,substance);
P1 = CoolProp.PropsSI('P','T',T1,'Q',Q1,substance);
% State 1
s1 = CoolProp.PropsSI('S','T',T1,'Q',Q1,substance);
h1 = CoolProp.PropsSI('H','T',T1,'Q',Q1,substance);
% State 2
T2 = T1+2;
P2 = P1;
s2 = CoolProp.PropsSI('S','T',T2,'P',P2,substance);
h2 = CoolProp.PropsSI('H','T',T2,'P',P2,substance);
% State 3
P3 = P4 + 80000;
s3s = s2;
h3s = CoolProp.PropsSI('H','P',P3,'S',s3s,substance);
h3 = ((h3s-h2)/cond_eff)+h2;
T3 = CoolProp.PropsSI('T','P',P3,'H',h3,substance);
s3 = CoolProp.PropsSI('S','P',P3,'H',h3,substance);
% State 3b
T3b = CoolProp.PropsSI('T','P',P3,'Q',Q1,substance);
s3b = CoolProp.PropsSI('S','P',P3,'Q',Q1,substance);
% State 4
s4 = CoolProp.PropsSI('S','P',P4,'Q',Q4,substance);
h4 = CoolProp.PropsSI('H','P',P4,'Q',Q4,substance);
% State 5
P5 = P4;
T5 = T4-2;
s5 = CoolProp.PropsSI('S','T',T5,'P',P5,substance);
h5 = CoolProp.PropsSI('H','T',T5,'P',P5,substance);
% State 6
P6 = P1+80000;
h6 = h5;
T6 = CoolProp.PropsSI('T','P',P6,'H',h6,substance);
s6 = CoolProp.PropsSI('S','P',P6,'H',h6,substance);

% State 3-3b
T3_3b = linspace(T3,T3b,100);
for i = 1:length(T3_3b)
    s3_3b(i) = CoolProp.PropsSI('S','T',T3_3b(i),'P',P3,substance);
end

T = [T1,T2,T3_3b,T4,T5,T6,T1];
s = [s1,s2,s3_3b,s4,s5,s6,s1];
P = [P1,P2,P3,P4,P5,P6,P1];
h = [h1,h2,h3,h4,h5,h6,h1];

end




