function [WTOT,KG,weights] = IMSYC_weight_and_KG(LOA,TK,B,WK,P,E,I,J,BAD,D)

%------------------------------------------------------------------------
%  [WTOT,KG,weights] = IMSYC_weight_and_KG(LOA,T,B,WK,P,E,I,J,BAD,D)
%
%  The function estimates the weights and center of gravity of various
%  parts of the boat according to empirical assumptions. 
%  
%  LOA : [m]  Length over all
%  B   : [m]  Total Beam of hull
%  TK  : [m]  Keel blade draught from canoe body keel-line
%  WK  : [KG] Bulb weight
%  P   : [m]  Mainsail hoist
%  E   : [m]  Foot of mainsail
%  J   : [m]  Base of foretriangle
%  I   : [m]  Height of foretriangle
%  BAD : [m]  Height of main boom above sheer
%  D   : [m]  Height of hull from canoe body keel
%
%  WTOT : [kg] Total weight of complete boat
%  KG   : [m]  vertical center of gravity from canoe body keel-line
%  weights : A struct with weights and CG:s for the components.
%
%------------------------------------------------------------------------

% Rig weight and CG   
SA_main = (0.5*P*E);      
SA_fore = 0.5*I*J;
SA_nom  = SA_main + SA_fore;
W_rig   = 0.45*SA_nom^1.5;
KG_rig  = (D)+0.36*(BAD+P);

% Deck gear weight and CG
W_deck  = 0.17*LOA^2.89;
KG_deck = D;

% Structure, interior and machinery weight and CG
W_interior  = 0.04*LOA^3.4;
W_machinery = 0.1*LOA^3.1;
W_hull      = (sqrt(WK)*0.1+50)*((LOA*B*D)^(1/3))^2.5;
KG_hull     = 0.85*D*((B/LOA)^(1/3));
WTOT        = W_rig+W_deck+W_interior+W_machinery+W_hull+WK;

% Keel weight and CG
KG_keel = -TK;

% Totally
KG  = (KG_rig*W_rig+KG_deck*W_deck+KG_hull*(W_interior+W_machinery+W_hull)+KG_keel*WK)/WTOT;

% For output
weights.WK          = WK;  % Keel bulb weight
weights.W_deck      = W_deck;
weights.W_rig       = W_rig;
weights.W_interior  = W_interior;
weights.W_machinery = W_machinery;
weights.W_hull      = W_hull;
weights.WTOT        = WTOT;
weights.KG_rig      = KG_rig;
weights.KG_hull     = KG_hull;
weights.KG_keel     = KG_keel;
weights.KG_deck     = KG_deck;
weights.KG          = KG ;