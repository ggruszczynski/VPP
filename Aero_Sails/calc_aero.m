function [FA, CEA, L, D_TOT, D_i,  D_visc] = calc_aero(TWS,VS,HEEL,TWA,R,hulldata,rigdata,SAILSET)

P = rigdata.P; %[m]
E = rigdata.E; %[m]
I = rigdata.I; %[m]
J = rigdata.J; %[m]
BAD = rigdata.BAD; %[m]
LPG = rigdata.LPG; %[m]
D = hulldata.D; %[m]

% Calculate sail areas from standard rig measurments 
  SA_main  = 0.5 * P * E *1.1;                      % [m^2] Mainsail area, factor 1.1 accounts for some roach
  SA_jib   = 0.5*sqrt(J^2 + I^2)*LPG;                       % [m^2] Jib area
  SA_spinn = 1.8 *J *I;                     % [m^2] SPinnaker area

% Calculate centre of effort for each individual sail, origo = keel-line
  CE_main  =  0.39*P+BAD +D;              % [m] Centre of effort measured from keelline of canoe body 
  CE_jib   =   0.39*I + D;            % [m] Centre of effort measured from keelline of canoe body
  CE_spinn =   0.565*I +D;             % [m] Centre of effort measured from keelline of canoe body

% Check which SAILSET that is used, 1=Upwind, 2=Downwind 
  switch SAILSET
	  % Upwind, NO spinnaker, calculate CEA
      case 1
          SA_spinn = 0;
      % Downwind, NO jib, calculate CEA
      case 2
          SA_jib   = 0;
  end
  
% Calculate reference sail area
  SA_ref =  SA_main + SA_jib + SA_spinn;
  
% Calculate CEA for complete sailplan
   CEA = R*(CE_main * SA_main + CE_jib * SA_jib +CE_spinn * SA_spinn )/SA_ref;

% Calculate apparent wind angle and windspeed, AWS and AWA, from velocity triangle, use the law of cosines twice
  AWS    =   sqrt(TWS^2 + VS^2 -2*TWS*VS*cos(pi-TWA));  % [m/s] From Velocity triangle  
  AWA    = acos((VS^2+AWS^2 - TWS^2)/(2*VS*AWS));     % [rad] From Velocity triangle
  AWAd    = AWA*360/(2*pi);    % [deg] From Velocity triangle

% Check so that the argument x in acos(x) is smaller or equal to 1, otherwise imaginary result!
  if (AWS^2+TWS^2-VS^2)/(2*AWS*TWS)>1; AWAd=TWA; end   % Check so that the argument x<=1 in acos(x) otherwise imaginary result!

 % Transform apparent wind speed to heeled coordinate system, i.e. calculate vector W_RED
   W      =  [ - AWS *cos(AWA); - AWS*sin(AWA); 0 ];

  Mtrans =          [ 1                  0                       0;                             % Transformation matrix, boat fixed upright coords  -> boat heeled coor sys 
                             0         cos(HEEL)       sin(HEEL);
                             0        -sin(HEEL)       cos(HEEL)];
   W_RED  = Mtrans * W;

 % Calculate heel reduced apparent windangle and windspeed, AWS_RED and AWA_RED
   AWS_RED = sqrt(W_RED(1)^2 + W_RED(2)^2);        % [m/s] Heel reduced apparent windspeed
   AWA_RED = atan(W_RED(2)/W_RED(1)) ;             % [rad] Heel reduced apparent windangle
   
        if (AWA_RED < 0) % for broaching course
%             fprintf('AWA_REDd =  %0.4f [deg] <0 \n ',  (pi+ AWA_RED) *360/(2*pi));
            AWA_RED = pi + AWA_RED;           
        end
   AWA_REDd = AWA_RED*360/(2*pi);                       % [deg] Heel reduced apparent windangle

% Calculate aspect ratio for sailplan
          if AWA_RED<30*pi/180
              BE = 1;
          elseif AWA_RED<90*pi/180
              BE =1.5 - AWA_REDd/60; % linear interpolation
          else
              BE = 0;
          end
  
  AR = ((I*(1+0.1*BE))^2)/SA_ref; % [-] Sailplan Aspect ratio

% Calculate the individual sails lift and drag coefficients at a given reduced apparent wind angle
  [CL_main, CD_main, CL_jib, CD_jib, CL_spinn, CD_spinn] = calc_Sail_CLCD(AWA_RED);  % [-] Lift and drag coefficients for sailplan

% Calculate sailplan total lift, CL  
  CL = R*R*( CL_main*SA_main+CL_jib*SA_jib+CL_spinn*SA_spinn )/SA_ref;  % [-] Total lift coefficient, note R^2  

% Calculate induced drag, CDi and calculate sailplan total drag coefficient, CD_TOT
  CD_visc     =   R*R*( CD_main*SA_main+CD_jib*SA_jib+CD_spinn*SA_spinn )/SA_ref;                  % [-] Total drag coefficient, note R^2  
  CD_i   =   CL*CL*(1/(pi*AR) + 0.005);                                                            % [-] Induced drag coefficent
  CD_TOT =   CD_visc +CD_i;                                                                        % [-] Total aerodynamic drag coefficient

% Calculate the total lift and drag, L and D 
  rho = 1.2;                            %air density [ kg/m3 ]
  q  = 0.5 *rho*AWS_RED *AWS_RED;       % Dynamic head
  D_visc = q *CD_visc* SA_ref;          % [N] viscous drag
  D_i = q *CD_i* SA_ref;                % [N] induceed drag
  D_TOT  =  q *CD_TOT* SA_ref;          % [N] In parallell to wind system  
  L  =   q* CL* SA_ref;                 % [N] Perpendicular to flow direction in wind system
  
% Formulate force vector in heeled wind fixed coordinate system, FA_WIND
  FA_WIND = [-D_TOT; -L ; 0];       % [N] Forces in heeled wind fixed system
  
% Transformation matrix from wind system to heeled coordinate system, A
  A      =      [ cos(AWA_RED)       -sin(AWA_RED)                  0;                            
                     sin(AWA_RED)         cos(AWA_RED)                 0;
                                 0                               0                            1];
                         
% Transform FA_WIND to heeled coordinate system, FA_HEEL and then  to upright coordinate system, FA
  FA_HEEL = A* FA_WIND;   % [N] 
  FA      =   Mtrans' * FA_HEEL;  % [N] 





