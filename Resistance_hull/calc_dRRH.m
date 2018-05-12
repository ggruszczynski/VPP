function dRRH = calc_dRRH(VS,LWL,BWL,TC,LCBfpp,V,HEEL);

%             VS = 5; %  yacht velocity [m/s]
%             HEEL = 0.5236; %  heel angle [rad]
%             LWL = 17;  % Waterline length [m]
%             BWL = 3;  % Waterline Beam [m]  
%             V = 12;% Volume displacement of canoe [m3] 
%             LCBfpp  = 8.5;  %  Distance LCB (longitudinal center of bouyancy) to forward perpend. [m]
%             TC = 0.6;    %  Canoe body draft [m]



%-------------------------------------------------------------------------
% dRRH    : [N]   Canoe body residuary resistance addition due to heel 
% 
% VS     : [m/s] Boat speed
% LWL    : [m]   Waterline length
% BWL    : [m]   Waterline Beam
% TC     : [m]   Canoe body draft
% LCBfpp : [m]   Longitudinal center of buoyancy to fwd perpendicular
% V      : [m3]  Volume displacement
% HEEL   : [rad] Angle of heel
%-------------------------------------------------------------------------
g    = 9.81;               % [m/s2]  Acceleratoin of gravitation  
rho  = 1000;               % [kg/m3] Density of water 
LCBx = (LWL/2-LCBfpp)/LWL; % [-]     LCB in percent of waterline measured from midship
Fn   = VS/sqrt(g*LWL);  % [-]     Froude number

Fn_vec   = [0  0.25    0.30     0.35     0.40     0.45     0.50    0.55 ];  % Frounde numbers
u = [0 -0.0268  0.6628   1.6433  -0.8659  -3.2715  -0.1976  1.5873;  % coefficients
            0 -0.0014 -0.0632  -0.2144  -0.0354   0.1372  -0.1480 -0.3749;  % Fossati Table 2.7
            0 -0.0057 -0.0699  -0.1640   0.2226   0.5547  -0.6593 -0.7105;
            0  0.0016  0.0069   0.0199   0.0188   0.0268   0.1862  0.2146;
            0 -0.0070  0.0459  -0.0540  -0.5800  -1.0064  -0.7489 -0.4818;
            0 -0.0017 -0.0004  -0.0268  -0.1133  -0.2026  -0.1648 -0.1174]./1000;
%    
%  u_intp = interp1(Fn_vec,u',Fn,'cubic'); % Interpolate at specific Fn
% RRH20 = V*1000* g*(u_intp(1)  + u_intp(2)*LWL/BWL + u_intp(3)*BWL/TC + u_intp(4)*(BWL/TC)^2 + u_intp(5)*LCBx + u_intp(6) *LCBx^2 )
% dRRH = RRH20 *6* HEEL^(1.7)
% 
% disp('--------------now vector:--------------');

RRH20_vec = V*rho* g* u' * [1   LWL/BWL  BWL/TC (BWL/TC)^2  LCBx  LCBx^2 ]' ;  %  [N] Delta RR @ HEEL=20deg,  Fossati eq. 2.26
RRH20     = interp1(Fn_vec,RRH20_vec,Fn,'PCHIP') ;                                                               % Interpolate in RRH20_vec at specific Fn
dRRH = RRH20 *6* HEEL^(1.7) ;                                                                                               %  [N]  Delta residuary resistance due to heel,  Fossati eq. 2.27

% %     
% RRH20_vec = V*1000* g*(u(1,:)  + u(2,:)*LWL/BWL + u(3,:)*BWL/TC + u(4,:)*(BWL/TC)^2 + u(5,:)*LCBfpp + u(6,:) *LCBfpp^2 ) % [N] Delta RR @ HEEL=20deg,  Fossati eq. 2.26
% RRH20     = interp1(Fn_vec,RRH20_vec,Fn,'cubic') % Interpolate in RRH20_vec at specific Fn
% dRRH      =  RRH20 * 6* HEEL^1.7                   % [N]  Delta residuary resistance due to heel,  Fossati eq. 2.27
% % 

