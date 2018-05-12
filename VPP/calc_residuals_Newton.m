
function [F,M] = calc_residuals_Newton(VS,HEEL,TWS,TWA,hulldata,rigdata,SAILSET,R)

%--------------------------------------------------------------------------
% Aerodynamic calculations
%--------------------------------------------------------------------------
% Calculate aerodynamic force components vector FA
[FA,CEA] = calc_aero(TWS,VS,HEEL,TWA,R,hulldata,rigdata,SAILSET);


% Divide into force vectors in upright coordinate system
FAX = FA(1);
FAY = FA(2);
FAZ = FA(3);

%--------------------------------------------------------------------------
% Hydrodynamic calculations
%--------------------------------------------------------------------------
% Calculate hydrodynamic forces
[FH CEH] = calc_hydro(VS,HEEL,hulldata,FAY);

% Divide into force vectors in upright coordinate system
FHX     = FH(1);                      % [N]   Hydrodynamic Driving Force component
FHY     = FH(2);                       % [N]   Hydrodynamic Side Force component
FHZ     = FH(3);                      % [N]   Hydrodynamic Vertical Force component

%--------------------------------------------------------------------------
% Equilibrium equations
%--------------------------------------------------------------------------

g =9.81; % [m/s2] gravity

% Moments
MH  =    - (abs(CEH) + CEA)*  FHY/cos(HEEL); % [Nm] Heeling moment % of course FHY/cos(HEEL) = sqrt(FAY^2 + FAZ^2) = sqrt(FHY^2 + FHZ^2)
GZ  =   interp1(hulldata.GZdata(:,1),hulldata.GZdata(:,2),HEEL);                            % [m] Rightening arm %GZdata contains two columns [HEEL, GZ]
%MR  = 	GZ*weights.WTOT *g;                            % [Nm] Rightening moment
MR = GZ * hulldata.V*1000*g;

% Calculate the residuals
F  = FAX + FHX;	                            % [N]  Residual in x-direction forces (thrust)
M  = MH +MR ;	                            % [Nm] Resulting moment residual






