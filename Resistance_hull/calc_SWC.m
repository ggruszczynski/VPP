function SWC = calc_SWC(LWL,BWL,TC,CM,DISPL)

%-------------------------------------------------------------------------
% Estimation of Canoe body upright wet surface, Keuning 1998
%
% SWC   : [m2]  Canoe body upright wet surface 
% 
% LWL   : [m]   Waterline length
% BWL   : [m]   Waterline Beam
% TC    : [m]   Canoe body draft
% CM    : [-]   Midship section coefficient
% DISPL : [m3]  Volume displacement of canoe
%-------------------------------------------------------------------------

SWC  = (1.97 + 0.171*BWL/TC)*((0.65/CM)^(1/3)) *sqrt(DISPL*LWL); % [m2] Keuning 1998, eq.6    

