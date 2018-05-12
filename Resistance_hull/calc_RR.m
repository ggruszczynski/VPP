function RR = calc_RR(VS,V,CP,LWL,LCBfpp,LCFfpp,BWL,TC,AWP,CM)

%-------------------------------------------------------------------------
% Calculate the residuary resistance (upright wave generation and viscous 
% pressure resistance) by interpolation using the University of Delft systematic 
% experimental series data for displacement hulls. 
%
% RR      : [N]   Upright Residuary resistance (wave resistance) from Fossati eq. 2.23 (Keuning 2008) 
% 
% VS      : [m/s] Boat speed
% V       : [m3]  Volume displacement
% CP      : [-]   Prismatic coefficient
% LWL     : [m]   Waterline length
% LCBfpp  : [m]   Distance LCB to forward perpend. 
% LCFfpp  : [m]   Distance LCF to forward perpend.
% BWL     : [m]   Waterline Beam
% TC      : [m]   Canoe body draft
% AWP     : [m2]  Waterplane area
% CM      : [-]   Midship section coefficient
%--------------------------------------------------------------------------

g   = 9.81;           % [m/s2]  Acceleraytion of gravitation
rho = 1000;           % [kg/m3] Density of water

Fn  = VS/sqrt(g*LWL); % [-]    Froude number
Fn  = min(Fn,0.75);   %        To Make sure to not extrapolate...

if Fn<0;STRANGE_WITH_NEGATIVE_FN;end;          % Just a watch dog for debugging
if imag(Fn)~=0;STRANGE_WITH_IMAGINARY_FN;end   % Just a watch dog for debugging
  
% A vector of Froude numbers relating to the a0-a8 coeffs
Fn_vec   = [0  0.1500  0.2000  0.2500  0.3000  0.3500  0.4000  0.4500  0.5000  0.5500  0.6000  0.6500  0.7000  0.7500]; 

% Here are all the  a0-a8 coefficients in a matrix according to Fossati Table 2.5
a =      [0 -0.0005 -0.0003 -0.0002 -0.0009 -0.0026 -0.0064 -0.0218 -0.0388 -0.0347 -0.0361  0.0008  0.0108  0.1023;  
            0  0.0023  0.0059 -0.0156  0.0016 -0.0567 -0.4034 -0.5261 -0.5986 -0.4764  0.0037  0.3728 -0.1238  0.7726;  
            0 -0.0086 -0.0064  0.0031  0.0337  0.0446 -0.1250 -0.2945 -0.3038 -0.2361 -0.2960 -0.3667 -0.2026  0.5040;
            0 -0.0015  0.0070 -0.0021 -0.0285 -0.1091  0.0273  0.2485  0.6033  0.8762  0.9661  1.3957  1.1282  1.7867;
            0  0.0061  0.0014 -0.0070 -0.0367 -0.0707 -0.1341 -0.2428 -0.0430  0.4219  0.6123  1.0343  1.1836  2.1934;
            0  0.0010  0.0013  0.0148  0.0218  0.0914  0.3578  0.6293  0.8332  0.8990  0.7534  0.3230  0.4973 -1.5479;
            0  0.0001  0.0005  0.0010  0.0015  0.0021  0.0045  0.0081  0.0106  0.0096  0.0100  0.0072  0.0038 -0.0115;
            0  0.0052 -0.0020 -0.0043 -0.0172 -0.0078  0.1115  0.2086  0.1336 -0.2272 -0.3352 -0.4632 -0.4477 -0.0977];


%  a_intp  = interp1(Fn_vec,a',Fn,'cubic'); % Interpolate 
 
% Now calculate the residuary resistance RR at all predefined Fn:s in Fn_vec according to Fossati eq 2.23
% RR =   a_intp(1);
% RR =   RR +   (a_intp(2)*LCBfpp/LWL + a_intp(3)*CP + a_intp(4)*V^(2/3)/AWP + a_intp(5)*BWL/LWL)   *( V^(1/3))/LWL;
% RR = RR +    (a_intp(6)*LCBfpp/LCFfpp + a_intp(7)*BWL/TC + a_intp(8)*CM)*(V^(1/3))/LWL;
% RR =  RR* V*rho*g

%------------- first calculate in a matrix form, then interpolate.... 
%  itmakes a difference!!!!!!

% Now calculate the residuary resistance RR at all predefined Fn:s in Fn_vec according to Fossati eq 2.23
RR_vec =V*rho*g *a'* [ 1/((V^(1/3))/LWL)  LCBfpp/LWL  CP    V^(2/3)/AWP 	BWL/LWL   LCBfpp/LCFfpp     BWL/TC  CM ]'  *( V^(1/3))/LWL;   
% Interpolate to get RR at exactly Fn
RR = interp1(Fn_vec,RR_vec,Fn,'PCHIP');




 









