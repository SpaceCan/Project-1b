function [T,s,P,h,massFlowrate,] = Newer_Cycle(tempOutside,tempInside,deltaT,substance)
%Finds COP for the vapour compression cycle given matrices T_H and T_L

Q1 = 1;
Q2 = 0;
%Calculating T1 and T3
if tempOutside < tempInside
    T1 = tempOutside - deltaT + 273.15;
    T3 = tempInside + deltaT + 273.15;
else
    T3 = tempOutside - deltaT + 273.15;
    T1 = tempInside + deltaT + 273.15;
end

%Creates a array the same size as T1
%cop = zeros(size(T1,1),size(T1,2));

% State 1
s1 = CoolProp.PropsSI('S', 'T', T1, 'Q', Q1, substance);
P1 = CoolProp.PropsSI('P', 'T', T1,'S', s1, substance);
h1 = CoolProp.PropsSI('H', 'T', T1, 'Q', Q1, substance);
% State 2  
s2a = s1;
P2 = CoolProp.PropsSI('P', 'T', T3, 'Q', Q1, substance);
T2a = CoolProp.PropsSI('T', 'S', s2a, 'P', P2, substance);
h2 = CoolProp.PropsSI('H', 'T', T2, 'S', s2a, substance);
s2b = CoolProp.PropsSI('S', 'P', P2, 'Q', Q1, substance);
T2b = CoolProp.PropsSI('T', 'P', P2, 'Q', Q1, substance);
% State 3
s3 = CoolProp.PropsSI('S', 'T', T3, 'Q', Q2, substance);
h3 = CoolProp.PropsSI('H', 'T', T3, 'Q', Q2, substance);
P3 = CoolProp.PropsSI('P', 'T', T3, 'Q', Q2, substance);
% State 4
h4 = h3;
P4 = P1;
T4 = CoolProp.PropsSI('T', 'P', P4, 'H', h4, substance);
s4 = CoolProp.PropsSI('S', 'P', P4, 'H', h4, substance);

q_h = (h2 - h3);
q_l = (h1 - h4);
w = (h2 - h1);
%         switch type
%             case 'refrigeration'
%                 cop(i,j) = q_l/w;
%             case 'heat pump'
%                 cop(i,j) = q_h/w;
%         end

T = [T1,T2a,T2b,T3,T4,T1];
s = [s1,s2a,s2b,s3,s4,s1];
P = [P1,P2,P3,P4];
h = [h1,h2,h3,h4];

end