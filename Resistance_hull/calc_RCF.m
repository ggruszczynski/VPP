function RCF = calc_RCF(S,VS,LWL);
%-------------------------------------------------------------------------
% Frictional resistance of the Canoe body according to Fossati Ch2.3
%
% RFC : [N]  Frictional resistance 
% 
% VS  : [m/s] Boatspeed
% S   : [m^2] Wetted area
% LWL : [m]   Waterline length
%-------------------------------------------------------------------------

visc   = 1.19*10^(-6);                   % [m^2/s]  Kinematic viscosity of water at 20 degrees, Fossati Ch2.3
rho    = 1000;                           % [kg/m3]  Density of water
Re     = VS*0.7*LWL/visc;              % [-]      Reynolds number (Keuning 1998 eq. 4)
cf     = 0.075/(log10(Re) -2 )^2;     % [-]      Frictional resistance coefficient ITTC-57, Fossati eq. 2.2
q      = 0.5*rho*VS*VS;                  % [Pa]     Dynamic pressure
RCF    =q*cf* S;                       % [N]      Frictional resistance, Fossati eq. 2.1

