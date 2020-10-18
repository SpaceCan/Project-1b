%Bullet point 1/Bullet Point 2 part 1
P1 = 151470; %Evaporator Pressure
P3 = 1003200; %Condenser Pressure
%my refrigerant is Ammonia(R717)
%state 1
T1 = CoolProp.PropsSI('T','P',P1,'Q',1,'R717');
h1 = CoolProp.PropsSI('H','P',P1,'Q',1,'R717'); 
s1 = CoolProp.PropsSI('S','P',P1,'Q',1,'R717');
% state 3
 T3 = CoolProp.PropsSI('T','P',P3,'Q',0,'R717');
 h3 = CoolProp.PropsSI('H','P',P3,'Q',0,'R717');
 s3 = CoolProp.PropsSI('S','P',P3,'Q',0,'R717');
% state 2
 P2 = P3;
 s2 = s1;
 h2 = CoolProp.PropsSI('H','P',P2,'S',s2,'R717');
 T2 = CoolProp.PropsSI('T','P',P2,'S',s2,'R717');
% state 2a
 P2a = P3;
 T2a = CoolProp.PropsSI('T','P',P2a,'Q',1,'R717');
 h2a = CoolProp.PropsSI('H','P',P2a,'Q',1,'R717');
 s2a = CoolProp.PropsSI('S','P',P2a,'Q',1,'R717');
% state 4
 P4 = P1;
 h4 = h3;
 s4 = CoolProp.PropsSI('S','P',P4,'H',h4,'R717');
 T4 = CoolProp.PropsSI('T','P',P4,'H',h4,'R717');
 %T-s vapor dome
 T = (-40:1:132.25)+273.15;
 for i=1:length(T)
     sliq(i) = CoolProp.PropsSI('S','T',T(i),'Q',0,'R717');
     svap(i) = CoolProp.PropsSI('S','T',T(i),'Q',1,'R717');
 end
 %P-h vapor dome
 P = (50:5:11333)*10^3;
 for i=1:length(P)
     hliq(i) = CoolProp.PropsSI('H','P',P(i),'Q',0,'R717');
     hvap(i) = CoolProp.PropsSI('H','P',P(i),'Q',1,'R717');
 end
 
%Point 2 to Point 2a 
 s22a = linspace(s2,s2a,100); 
 for i=1:length(s22a)
     T22a(i) = CoolProp.PropsSI('T','P',P2,'S',s22a(i),'R717');
 end
 
 %Point 3 to Point 4
 s34 = linspace(s3,s4,100);
 for i=1:length(s34)
     T34(i) = CoolProp.PropsSI('T','H',h3,'S',s34(i),'R717');
 end
 P12 = linspace(P1,P2,100);
for i=1:length(P12)
    h12(i) = CoolProp.PropsSI('H','P',P12(i),'S',s1,'R717');
end

%%
%Bullet Point 2 Part 2
P1n = 151470; %Evaporator Pressure
P3n = 3105200; %Condenser Pressure
%state 1
T1n = CoolProp.PropsSI('T','P',P1n,'Q',1,'R717');
h1n = CoolProp.PropsSI('H','P',P1n,'Q',1,'R717'); 
s1n = CoolProp.PropsSI('S','P',P1n,'Q',1,'R717');
% state 3
 T3n = CoolProp.PropsSI('T','P',P3n,'Q',0,'R717');
 h3n = CoolProp.PropsSI('H','P',P3n,'Q',0,'R717');
 s3n = CoolProp.PropsSI('S','P',P3n,'Q',0,'R717');
% state 2
 P2n = P3n;
 s2n = s1n;
 h2n = CoolProp.PropsSI('H','P',P2n,'S',s2n,'R717');
 T2n = CoolProp.PropsSI('T','P',P2n,'S',s2n,'R717');
% state 2a
 P2an = P3n;
 T2an = CoolProp.PropsSI('T','P',P2an,'Q',1,'R717');
 h2an = CoolProp.PropsSI('H','P',P2an,'Q',1,'R717');
 s2an = CoolProp.PropsSI('S','P',P2an,'Q',1,'R717');
% state 4
 P4n = P1n;
 h4n = h3n;
 s4n = CoolProp.PropsSI('S','P',P4n,'H',h4n,'R717');
 T4n = CoolProp.PropsSI('T','P',P4n,'H',h4n,'R717');
 
%Point 2 to Point 2a 
 s22an = linspace(s2n,s2an,100); 
 for i=1:length(s22an)
     T22an(i) = CoolProp.PropsSI('T','P',P2n,'S',s22an(i),'R717');
 end
 
 %Point 3 to Point 4
 s34n = linspace(s3n,s4n,100);
 for i=1:length(s34n)
     T34n(i) = CoolProp.PropsSI('T','H',h3n,'S',s34n(i),'R717');
 end
 
 P12n = linspace(P1n,P2n,100);
for i=1:length(P12n)
    h12n(i) = CoolProp.PropsSI('H','P',P12n(i),'S',s1n,'R717');
end

%%
%Bullet Point 2 Part 3
P1g = 11470; %Evaporator Pressure
P3g = 1003200; %Condenser Pressure

%state 1
T1g = CoolProp.PropsSI('T','P',P1g,'Q',1,'R717');
h1g = CoolProp.PropsSI('H','P',P1g,'Q',1,'R717'); 
s1g = CoolProp.PropsSI('S','P',P1g,'Q',1,'R717');
% state 3
 T3g = CoolProp.PropsSI('T','P',P3g,'Q',0,'R717');
 h3g = CoolProp.PropsSI('H','P',P3g,'Q',0,'R717');
 s3g = CoolProp.PropsSI('S','P',P3g,'Q',0,'R717');
% state 2
 P2g = P3g;
 s2g = s1g;
 h2g = CoolProp.PropsSI('H','P',P2g,'S',s2g,'R717');
 T2g = CoolProp.PropsSI('T','P',P2g,'S',s2g,'R717');
% state 2a
 P2ag = P3g;
 T2ag = CoolProp.PropsSI('T','P',P2ag,'Q',1,'R717');
 h2ag = CoolProp.PropsSI('H','P',P2ag,'Q',1,'R717');
 s2ag = CoolProp.PropsSI('S','P',P2ag,'Q',1,'R717');
% state 4
 P4g = P1g;
 h4g = h3g;
 s4g = CoolProp.PropsSI('S','P',P4g,'H',h4g,'R717');
 T4g = CoolProp.PropsSI('T','P',P4g,'H',h4g,'R717');
 
%Point 2 to Point 2a 
 s22ag = linspace(s2g,s2ag,100); 
 for i=1:length(s22ag)
     T22ag(i) = CoolProp.PropsSI('T','P',P2g,'S',s22ag(i),'R717');
 end
 
 %Point 3 to Point 4
 s34g = linspace(s3g,s4g,100);
 for i=1:length(s34g)
     T34g(i) = CoolProp.PropsSI('T','H',h3g,'S',s34g(i),'R717');
 end
 
P12g = linspace(P1g,P2g,100);
for i=1:length(P12g)
    h12g(i) = CoolProp.PropsSI('H','P',P12g(i),'S',s1g,'R717');
end

%%
%T-s for Bullet Point 1
figure(1)
plot([sliq,flip(svap)],[T,flip(T)])
hold on
plot([s1,s22a,s3,s34,s4,s1],[T1,T22a,T3,T34,T4,T1])
yline(258.15)
yline(288.15,'-.b')
legend('Vapor Dome','Vapor Compre Cycle','TLe','THe','location','best')
xlabel('Specific Entropy (Joules Per Kilogram Kelvin)')
ylabel('Temperature (Kelvin)')
title('T-s Diagram for Compression Refrigeration Cycle')
text(s1,T1,'\leftarrow State 1')
text(s2,T2,'\leftarrow State 2')
text(s2a,T2a,'\leftarrow State 2a')
text(s3,T3,'\leftarrow State 3')
text(s4,T4,'\leftarrow State 4')
text(0,288.15,'THe') %THe means temperature of the high temperature environment
text(0,258.15,'TLe')%TLe means temperature of the low temperature environment

%P-h for Bullet Point 1
figure(2)
plot([hliq,flip(hvap)]/1000,[P,flip(P)]/1000)
hold on
plot([h12,h2a,h3,h4,h1]/1000,[P12,P2a,P3,P4,P1]/1000)
legend('Vapor Dome','Vapor Compre Cycle','location','best')
xlabel('Specific Enthalpy (Kilojoules Per Kilogram)')
ylabel('Pressure (Kilopascals)')
title('P-h Diagram for Compression Refrigeration Cycle')
text(1573.8062,151.4713,'\leftarrow State 1')
text(1850.4027,1003.2403,'\leftarrow State 2')
text(1326.5855,1003.2403,'State 2a \rightarrow')
text(460.8214,1003.2403,'\leftarrow State 3')
text(460.8214,151.4713,'\leftarrow State 4')

%%
%T-s diagram for bullet point 2
figure(3)
plot([sliq,flip(svap)],[T,flip(T)])
hold on
plot([s1,s22a,s3,s34,s4,s1],[T1,T22a,T3,T34,T4,T1],['-.g*'])
plot([s1n,s22an,s3n,s34n,s4n,s1n],[T1n,T22an,T3n,T34n,T4n,T1n])
plot([s1g,s22ag,s3g,s34g,s4g,s1g],[T1g,T22ag,T3g,T34g,T4g,T1g])
yline(258.15)
yline(288.15,'-.b')
xlabel('Specific Entropy (Joules Per Kilogram Kelvin)')
ylabel('Temperature (Kelvin)')
title('T-s Diagram for Comparison of Multiple Compression Refrigeration Cycles')
legend('Vapor Dome','Reference Cycle','Higher Conden Pres','Lower Evap Pres','TLe','THe','location','best')
text(s1,T1,'\leftarrow State 1')
text(s2,T2,'\leftarrow State 2')
text(s2a,T2a,'\leftarrow State 2a')
text(s3,T3,'\leftarrow State 3')
text(865.8075,249.0411,'State 4 \rightarrow')
text(s2n,T2n,'\leftarrow State 2n')
text(s2an,T2an,'\leftarrow State 2an')
text(s3n,T3n,'\leftarrow State 3n')
text(s4n,T4n,'\leftarrow State 4n')
text(s1g,T1g,'\leftarrow State 1g')
text(s2g,T2g,'\leftarrow State 2g')
text(1044.6694,205.7968,'State 4g \rightarrow')
text(0,288.15,'THe') %THe means temperature of the high temperature environment
text(0,258.15,'TLe')%TLe means temperature of the low temperature environment

%%
%P-h graph for Bullet Point 2
figure(4)
plot([hliq,flip(hvap)]/1000,[P,flip(P)]/1000)
hold on
plot([h12,h2a,h3,h4,h1]/1000,[P12,P2a,P3,P4,P1]/1000,['-.g*'])
plot([h12n,h2an,h3n,h4n,h1n]/1000,[P12n,P2an,P3n,P4n,P1n]/1000)
plot([h12g,h2ag,h3g,h4g,h1g]/1000,[P12g,P2ag,P3g,P4g,P1g]/1000)
xlabel('Specific Enthalpy (Kilojoules Per Kilogram)')
ylabel('Pressure (Kilopascals)')
title('P-h Diagram for Comparison of Multiple Compression Refrigeration Cycles')
legend('Vapor Dome','Reference Cycle','Higher Conden Pres','Lower Evap Pres','location','best')
text(1233.8062,151.4713,'State 1 \rightarrow')
text(1850.4027,1003.2403,'\leftarrow State 2')
text(1236.5855,1003.2403,'State 2a \rightarrow')
text(460.8214,1003.2403,'\leftarrow State 3')
text(110.8214,151.4713,'State 4 \rightarrow')
text(2078.5902,3105.2,'\leftarrow State 2n')
text(1628.9834,3105.2,'\leftarrow State 2an')
text(673.1116,3105.2,'\leftarrow State 3n')
text(673.1116,181.47,'\leftarrow State 4n')
text(1566.9013,21.4875,'\leftarrow State 1g')
text(2265.6155,983.1651,'\leftarrow State 2g')
text(60.8151,11.47,'State 4g \rightarrow')

%%
%Bullet Point 3
TL = (268.15:288.15);
TH = (298.15:305.15);
DeltaTL = 5;
DeltaTH = DeltaTL;
T1 = TL - DeltaTL;
T3 = TH + DeltaTH;
for i =1:length(TL)
    for j=1:length(TH)
P1(i) = CoolProp.PropsSI('P','T',T1(i),'Q',1,'R717');
h1(i) = CoolProp.PropsSI('H','T',T1(i),'Q',1,'R717'); 
s1(i) = CoolProp.PropsSI('S','T',T1(i),'Q',1,'R717');
P3(j) = CoolProp.PropsSI('P','T',T3(j),'Q',0,'R717');
h3(j) = CoolProp.PropsSI('H','T',T3(j),'Q',0,'R717');
s3(j) = CoolProp.PropsSI('S','T',T3(j),'Q',0,'R717');
P2(i,j) = P3(j);
s2(i,j) = s1(i);
h2(i,j) = CoolProp.PropsSI('H','P',P2(i,j),'S',s2(i,j),'R717');
QH(i,j)=(h2(i,j)-h3(j));
 W(i,j)=(h2(i,j)-h1(i));
 COP(i,j)= QH(i,j)/W(i,j);
    end
end
figure(5)
contourf(TH,TL,COP);
xlabel('Inside Temperature (Kelvin)')
ylabel('Outside Temperature (Kelvin)')
title('Heat Pump COP Diagram for fixed Delta T')
c = colorbar;
c.Label.String = 'COP of Heat Pump';

%%
%Bullet Point 4
natgasprice = 14;
elecpriceW = 0.10 * 293;
for i =1:length(TL)
    for j=1:length(TH)
elecpriceQ(i,j) = (elecpriceW)/COP(i,j);
pricediff(i,j) = natgasprice - elecpriceQ(i,j); 
    end
end
figure(6)
contourf(TH,TL,pricediff);
xlabel('Inside Temperature (Kelvin)')
ylabel('Outside Temperature (Kelvin)')
title('Cost savings Plot for heating Natural Gas and Electricity')
c = colorbar;
c.Label.String = 'Savings ($/MMbtu)';