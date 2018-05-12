function [CL_main, CD_main, CL_jib, CD_jib, CL_spinn, CD_spinn] = calc_Sail_CLCD(AWA_RED)
%----------------------------------------------------------------------
% Calculates the lift and drag coefficients of the complete sailplan
% according to ORC documentation 2010.
%----------------------------------------------------------------------

% Defines the semi-empirical sailcoeficients
cl_main = [0.000 0.948 1.138 1.250 1.427 1.269 1.125 0.838 0.296 -0.112];
cd_main = [0.034 0.017 0.015 0.015 0.026 0.113 0.383 0.969 1.316 1.345]; 

cl_jib = [0 0 1.1 1.475 1.5 1.43 1.25 0.4 0 -0.1];
cd_jib = [0 0.05 0.032 0.031 0.037 0.25 0.35 0.73 0.95 0.9];

cd_spinn = [0 0.1063	0.1607	0.2125	0.391	0.6188	0.85	0.935	0.935	0.935];
cl_spinn = [0      0         0.9775 	1.241	1.4535	1.4365	1.19	0.7055	0.425	0];

% Defines the angles at which the sailcoefficients are derived
angles_main = [0 7 9 12 28 60 90 120 150 180]*pi/180;
angles_jib = [0 7 15 20 27 50 60 100 150 180]*pi/180;
angles_spinn = [0 28 41	46	60	75	100	130	150	180]*pi/180;

% Calculate lift coefficient at any given apparent wind angle (AWA)
CL_main = interp1(angles_main,cl_main,AWA_RED,'PCHIP');
CL_jib  = interp1(angles_jib,cl_jib,AWA_RED,'PCHIP');
CL_spinn= interp1(angles_spinn,cl_spinn,AWA_RED,'PCHIP');

% Calculate drag coefficient at any given apparent wind angle (AWA)
CD_main = interp1(angles_main,cd_main,AWA_RED,'PCHIP');
CD_jib  = interp1(angles_jib,cd_jib,AWA_RED,'PCHIP');
CD_spinn= interp1(angles_spinn,cd_spinn,AWA_RED,'PCHIP');














