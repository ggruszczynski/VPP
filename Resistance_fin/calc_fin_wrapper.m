clc, clear all;
format short ;
%format bank;
FAY=6400; % aerodynamic side force [N]
HEEL=0.4363; 
%HEEL = 2*HEEL;

T=4.5; % total draught [m]
C=1; % chord of the keel [m]
VS=3.0; % velocity [m/s]

v = 1e-6; %kinematic viscosity of the water [m2/s]
Re = VS*C/v; %Reynolds number

% e=0.80 ;
% rho=1000; 
% q=4500; %OK
% A=4.50; %OK
% AR=4.50; %OK
% L=7062; %OK
% CL=0.349; % OK
% CDi=0.0108;% OK
% LEEWAY=0.0863; %OK
% Cd=0.0109; %OK
% RFi=217.7; %OK
% RFvisc=221.6; %OK
% RF=439.3;%OK
% CEH=-2.25; %OK

[ RF, CEH, RFvisc, RFi, CL_3D, CL_2D, alfa  ]  = calc_fin(VS,FAY,T,C,HEEL);

VSkn = 4:0.1:12;
VS = VSkn *1852/3600; % kn --> m/s

rozmiar = size (VS);
rozmiar(:,1) = []; % estimation of the size of the vector which will store data

RF(rozmiar) = 0;
RFvisc(rozmiar) = 0;
RFi(rozmiar) = 0;

CL_3D(rozmiar) = 0;
CL_2D(rozmiar) = 0;
alfa(rozmiar) = 0;
for i = 1: rozmiar
    [ RF(i), CEH, RFvisc(i), RFi(i), CL_3D(i), CL_2D(i), alfa(i)  ]  = calc_fin(VS(i),FAY,T,C,HEEL);
end
alfa_deg = alfa *57.2957795; %leeway angle in degrees
HEEL_deg = HEEL * 57.2957795; % heel angle in degrees

fin_plots
