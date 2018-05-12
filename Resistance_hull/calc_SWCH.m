function SWCH = calc_SWCH(SWC,TC,BWL,CM,HEEL);

%-------------------------------------------------------------------------
% Heeled wetted surface of canoe body, Fossati eq. 2.25
%
% SWCH   : [m2]  Canoe body wet surface including effects of heel 
% 
% SWC    : [m2]  Canoe body upright wet surface  // from calc_SWC
% TC     : [m]   Canoe body draft
% BWL    : [m]   Waterline Beam
% CM     : [-]   Midship section coefficient
% HEEL   : [rad] Heel angle
%-------------------------------------------------------------------------

if HEEL>40*pi/180; fprintf('calc_SWCH warning: TOO_HIGH_HEEL, HEEL = %0.1f [deg] \n', HEEL*180/pi);end;       % Watchdog 
if HEEL<0        ;NEGATIVE_HEEL_NONO;end;  % Watchdog

% Interpolation of coefficients, Fossati Table 2.6
Heel_vec = [0    5      10      15      20      25     30       35  ]*pi/180; 

s = [0 -4.112  -4.522  -3.291   1.850   6.510  12.334  14.648; % Coefficients from Fossati Table 2.6
            0  0.054  -0.132  -0.389  -1.200  -2.305  -3.911  -5.182;
            0 -0.027  -0.077  -0.118  -0.109  -0.066   0.024   0.102;
            0  6.329   8.738   8.949   5.364   3.443   1.767   3.497];
                
s_intp = interp1(Heel_vec,s',HEEL,'PCHIP'); % Interpolate 

SWCH  =SWC*(1+0.01*(s_intp(1)+s_intp(2)*BWL/TC +s_intp(3)*(BWL/TC)^2 + s_intp(4)*CM)); % [m2]     Fossati eq. 2.25 
