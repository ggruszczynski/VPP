function [ RF, CEH, RFvisc, RFi, CL_3D, CL_2D, alfa ] = calc_fin( VS,FAY,T,C,HEEL)

rho=1000; % water density [kg/m3]
a0 = 2*pi; % slope of the lift coeff [1/rad] in 2D flow
e= 0.8; % Oswald efficiency factor

q = 0.5 *rho*VS*VS; % dynamic pressure [Pa]
AR = 2*T/C; % aspect ratio %--> it shlud be AR = 2*T/C
A = T*C; % fin area [m2]
CEH=-T/2; %Center of Effort Hydro [m]
FHY = FAY; % hydrodynamic side force [m]
FHyz = FHY/cos(HEEL);
CL_3D = FHyz/(q*A);
% a = a0/(1+a0/(pi*e*AR)); % slope of the lift coeff [1/rad] in 3D flow
% alfa = CL/a % leeway angle --> may be calculated this way as well
CL_2D = CL_3D*(1+2/(e*AR));   % lecture 
alfa = CL_2D/a0; %leeway anlge


CDvisc = 0.008 + 0.01*CL_2D*CL_2D;
CDi = CL_3D*CL_3D/(pi*e*AR);
%CD = CDvisc + CDi;

RFvisc = q*CDvisc*A; %viscous part of the blade resistance [N]
RFi = q*CDi*A; %induceed part of the blade resistance [N]
RF =RFvisc +RFi; % total blade resistance [N]

end

