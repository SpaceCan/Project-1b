function [massFlowrate, PConsumption, COP] = Newer_Cycle(tempOutside,tempInside,deltaT,QNeeded,substance)
%Finds COP for the vapour compression cycle given matrices T_H and T_L

Q1 = 1;
Q2 = 0;

%Calculating T1 and T3
heatMode = tempOutside < tempInside;
T1 = tempInside + deltaT + 273.15;
T1(heatMode) = tempOutside(heatMode) - deltaT + 273.15;
T3 = tempOutside - deltaT + 273.15;
T3(heatMode) = tempInside(heatMode) + deltaT + 273.15;

%Creates a array the same size as T1

for i = 1:size(tempOutside,1)
    for k = 1:size(tempInside,2)
        % State 1
        s1 = CoolProp.PropsSI('S', 'T', T1(i,k), 'Q', Q1, substance);
        P1 = CoolProp.PropsSI('P', 'T', T1(i,k),'S', s1, substance);
        h1 = CoolProp.PropsSI('H', 'T', T1(i,k), 'Q', Q1, substance);
        % State 2
        s2a = s1;
        P2 = CoolProp.PropsSI('P', 'T', T3(i,k), 'Q', Q1, substance);
        T2a = CoolProp.PropsSI('T', 'S', s2a, 'P', P2, substance);
        h2 = CoolProp.PropsSI('H', 'P', P2, 'S', s2a, substance);
        s2b = CoolProp.PropsSI('S', 'P', P2, 'Q', Q1, substance);
        T2b = CoolProp.PropsSI('T', 'P', P2, 'Q', Q1, substance);
        % State 3
        s3 = CoolProp.PropsSI('S', 'T', T3(i,k), 'Q', Q2, substance);
        h3 = CoolProp.PropsSI('H', 'T', T3(i,k), 'Q', Q2, substance);
        P3 = CoolProp.PropsSI('P', 'T', T3(i,k), 'Q', Q2, substance);
        % State 4
        h4 = h3;
        P4 = P1;
        T4 = CoolProp.PropsSI('T', 'P', P4, 'H', h4, substance);
        s4 = CoolProp.PropsSI('S', 'P', P4, 'H', h4, substance);
        
        q_h = (h2 - h3);
        q_l = (h1 - h4);
        w = (h2 - h1);
        
        if QNeeded(i,k) < 0
            massFlowrate(i,k) = abs(QNeeded(i,k)./q_l);
            COP(i,k) = min(abs(q_l/w),500);
        else
            massFlowrate(i,k) = abs(QNeeded(i,k)./q_h);
            COP(i,k) = min(abs(q_h/w),500);
        end
        PConsumption(i,k) = massFlowrate(i,k).*w;
    end
end

end