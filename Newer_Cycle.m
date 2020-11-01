function [T,s,P,h,massFlowrate,] = Newer_Cycle(tempOutside,tempInside,deltaT,substance)
%Finds COP for the vapour compression cycle given matrices T_H and T_L

Q1 = 0;
Q2 = 1;
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
s1 = CoolProp.PropsSI('S', 'T', T1, 'Q', Q2, substance);
h1 = CoolProp.PropsSI('H', 'T', T1, 'Q', Q2, substance);
% State 2   
P2 = CoolProp.PropsSI('P', 'T', T3, 'Q', Q1, substance);
T2 = CoolProp.PropsSI('T', 'S', s1, 'P', P2, substance);
h2 = CoolProp.PropsSI('H', 'T', T2, 'S', s1, substance);
% State 3
h3 = CoolProp.PropsSI('H', 'T', T3, 'Q', Q1, substance);
% State 4   
h4 = h3;

q_h = (h2 - h3);
q_l = (h1 - h4);
w = (h2 - h1);
%         switch type
%             case 'refrigeration'
%                 cop(i,j) = q_l/w;
%             case 'heat pump'
%                 cop(i,j) = q_h/w;
%         end
end