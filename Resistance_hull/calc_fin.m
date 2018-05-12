function [ RF, CEH, RFvisc, RFi, CL, Cl, alfa ] = calc_fin( VS,FAY,T,C,HEEL)

rho=1000; % water density [kg/m3]
a = 2*pi; % slope of the lift coeff [1/rad]
e= 0.8; % Oswald efficiency factor

q = 0.5 *rho*VS.*VS; % dynamic pressure [Pa]
AR = T/C; % aspect ratio
A = T*C; % fin area [m2]
CEH=-T/2; %Center of Effort Hydro [m]
FHY = FAY; % hydrodynamic side force [m]
FHyz = FHY/cos(HEEL);
CL = FHyz./(q*A);
%Cl = CL /(1- CL/(pi*e*AR)); % lift coeff in a 2D flow %book version
Cl = CL*(1+2/(e*AR));   % lecture 
alfa = Cl/a; %leeway anlge

CDvisc = 0.008 + 0.01*Cl.*Cl;
CDi = CL.*CL/(pi*e*AR);
%CD = CDvisc + CDi;

RFvisc = q.*CDvisc*A; %viscous part of the blade resistance [N]
RFi = q.*CDi*A; %induceed part of the blade resistance [N]
RF =RFvisc +RFi; % total blade resistance [N]

end

