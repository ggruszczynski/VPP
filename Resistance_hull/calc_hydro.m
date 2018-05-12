
 function [FH CEH] = calc_hydro(VS,HEEL,hulldata,FAY)
%-------------------------------------------------------------------------
% Function calculating the hydrodynamic forces vector and center of effort.
%
% CEH : [m] vertical center of effort of hydrodynamic side force on fin
% FH  : [N] Vector of hydro forces in in upright coordinate system
%
% VS       : [m/s] Boat speed
% HEEL     : [rad] Boat heel angle
% FAY      : [N]   Aerodynamic horizontal side force in upright coordinates
% hulldata : [...] A structured variable with fields 
%                  LWL, BWL, TC,V,CM,CP,AWP,LCBfpp,LCFfpp,T,C
%-------------------------------------------------------------------------

% Indata 

  LWL    = hulldata.LWL;    % [m]    Lenght at waterline
  BWL    = hulldata.BWL;    % [m]    Beam at waterline
  TC     = hulldata.TC;     % [m]    Draft of canoebody
  V      = hulldata.V;      % [m^3]  Volume displacment
  CM     = hulldata.CM;     % [-]    Midship coefficient
  CP     = hulldata.CP;     % [-]    Prismatic coefficient V/(Lwl*Ax)
  AWP    = hulldata.AWP;    % [m^2]  Area of waterplane
  LCBfpp = hulldata.LCBfpp; % [m]    Distance from LCB to forward perpend.
  LCFfpp = hulldata.LCFfpp; % [m]    Distance from LCF to forward perpend.
  T      = hulldata.T;      % [m]    Total draught of yacht including appendages
  C      = hulldata.C;      % [m]    Keel average chord

% Calculate the canoe body resistance components.
  SWC        =   calc_SWC(LWL,BWL,TC,CM,V);                            % [m2] : Upright wet surface of canoe body
  SWCH      = calc_SWCH(SWC,TC,BWL,CM,HEEL);                   % [m2] : Heeled  wet surface of canoe body
  RCF         =  calc_RCF(SWCH,VS,LWL);                                       % [N]  : Frictional resistance of canoe body
  RR           = calc_RR(VS,V,CP,LWL,LCBfpp,LCFfpp,BWL,TC,AWP,CM);                   % [N]  : Upright Residuary resistance of canoe body
  dRRH       = calc_dRRH(VS,LWL,BWL,TC,LCBfpp,V,HEEL);                                      % [N]  : Canoe body residuary resistance addition due to heel 
  RC            = RCF +RR + dRRH;                                                   % [N]  : Total Canoe body resistance 
  [ RF, CEH]  = calc_fin(VS,FAY,T,C,HEEL);                                  % [N]  : Fin Resistance and CEH
  R                  = RC + RF;                                                                  % [N]  : Total resistance (canoe + fin)

% Total hydrodynamic force vector in heeled system 
  Fheeled    = [-R, -FAY/cos(HEEL), 0] ;                    % [N]  : Force vector [x,y,z] in heeled system
                     
% Transform the force vector Fheeled to upright coordinate system in FH
 Mtrans =          [ 1                  0                       0;                             % Transformation matrix, boat fixed to upright coords   
                             0         cos(HEEL)       sin(HEEL);
                             0        -sin(HEEL)       cos(HEEL)];
             
  FH     = Mtrans*Fheeled' ;                % [N] : Force vector in upright coordinate system
  %FH = FH';
% FH= [-R,-FAY, tan(HEEL)*FAY];                             %%force vector in the upright coord sys OK - works as well
      