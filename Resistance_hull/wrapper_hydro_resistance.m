clc, clear all;
format short ;


initialize_hulldata; % sets hull data to workspace
VS = 5;                 %  yacht velocity [m/s]
HEEL = 0.5236;   %  heel angle [rad]
FAY = 10000;       % aerodynamic side force [N]

 [FH, CEH] = calc_hydro(VS,HEEL,hulldata,FAY);

hull_resistance_plots(HEEL,hulldata,FAY);