clc, clear all;
format short ;

addpath('../Resistance_hull/');

% set data to workspace
initialize_hulldata; 
initialize_rigdata;


TWS = 5;                                    % true wind speed [m/s]
TWAd = 40;                                % true wind angle [deg]
TWA = TWAd * 2 *pi /360;         % true wind angle [rad]
VS = 3.6;                                     %  yacht velocity [m/s]
HEELd =15;                              %  heel angle [deg]
HEEL = HEELd * 2 *pi /360 ;    %  heel angle [rad]
SAILSET = 1;                              % 1=Upwind, 2=Downwind
R = 0.8;                                       % Reef factor


[FA, CEA] = calc_aero(TWS,VS,HEEL,TWA,R,hulldata,rigdata,SAILSET); % [FAx; FAy; FAz] in [N]

 Aero_plots(TWS,VS,HEEL,TWA,R,hulldata,rigdata,SAILSET)