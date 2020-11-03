function [COP] = Actual_Cycle_COP(tempOutside,tempInside,deltaT,QNeeded,substance)

if length(tempInside) == 1
   tempInside = tempInside .* ones(size(tempOutside));
end

heatMode = tempOutside < tempInside;
T1 = tempInside + deltaT + 273.15;
T1(heatMode) = tempOutside(heatMode) - deltaT + 273.15;
T4 = tempOutside - deltaT + 273.15;
T4(heatMode) = tempInside(heatMode) + deltaT + 273.15;

Q1 = 1;
Q4 = 0;
cond_eff = 0.85;
for i = 1:size(tempOutside,1)
    for k = 1:size(tempInside,2)
        P4 = CoolProp.PropsSI('P','T',T4(i,k),'Q',Q4,substance);
        P1 = CoolProp.PropsSI('P','T',T1(i,k),'Q',Q1,substance);
        % State 1
        s1 = CoolProp.PropsSI('S','T',T1(i,k),'Q',Q1,substance);
        h1 = CoolProp.PropsSI('H','T',T1(i,k),'Q',Q1,substance);
        % State 2
        T2 = T1(i,k)+2;
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
        T5 = T4(i,k)-2;
        s5 = CoolProp.PropsSI('S','T',T5,'P',P5,substance);
        h5 = CoolProp.PropsSI('H','T',T5,'P',P5,substance);
        % State 6
        P6 = P1+80000;
        h6 = h5;
        T6 = CoolProp.PropsSI('T','P',P6,'H',h6,substance);
        s6 = CoolProp.PropsSI('S','P',P6,'H',h6,substance);
        
        q_l = h1-h4;
        q_h = h3-h4;
        w = h3-h2;
        
        if QNeeded(i,k) < 0
            COP(i,k) = min(abs(q_l/w),40);
        else
            COP(i,k) = min(abs(q_h/w),40);
        end
    end
end

end
