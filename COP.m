function [cop] = COP(T_H,T_L,deltaT,substances)
%Finds COP for the vapour compression cycle given matrices T_H and T_L

Q1 = 0;
Q2 = 1;
%Calculating T1 and T3
T1 = T_L - deltaT + 273.15;
T3 = T_H + deltaT + 273.15;

%Creates a matrix the same size as T1
cop = zeros(size(T1,1),size(T1,2));

for i = 1:size(T1,1)
    for j = 1:size(T1,2)
        s1 = CoolProp.PropsSI('S', 'T', T1(i,j), 'Q', Q2, substances);
        h1 = CoolProp.PropsSI('H', 'T', T1(i,j), 'Q', Q2, substances);
        
        P2 = CoolProp.PropsSI('P', 'T', T3(i,j), 'Q', Q1, substances);
        T2 = CoolProp.PropsSI('T', 'S', s1, 'P', P2, substances);
        h2 = CoolProp.PropsSI('H', 'T', T2, 'S', s1, substances);
        
        h3 = CoolProp.PropsSI('H', 'T', T3(i,j), 'Q', Q1, substances);
        
        h4 = h3;
        
        q_h = (h2 - h3);
        w = (h2 - h1);
        
        cop(i,j) = q_h/w;
    end
end
end
