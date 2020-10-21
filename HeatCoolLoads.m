TL1 = -15; %arbitrary lowest TL, using this until we get actual data from climate section

TL2 = 15;%arbitrary highest TL, using this until we get actual data from climate section

hcW = 12.12 - 1.16 v + 11.6 v1/2 %convection heat transfer formula I found on piazza

Rswa = (x1/k1) +(x2/x2);%In series thermal resistance formula for wall, rough draft of what it will look like

Rswi = (x3/k3) +(x4/x4);%In series thermal resistance formula for window, rough draft of what it will look like

r = (1/Rswa)+(1/Rswi);

Rp = (TL2 - TL1)/(r);%Use this formula to combine the thermal resistances for the walls in parallel