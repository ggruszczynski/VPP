function [] = make_plots(HEEL,hulldata,FAY)

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
 

%-------------------------plots preparation  ----------------------------%
VSkn = 4:0.1:12;                                 %velocity range [kn]
VS = VSkn *1852/3600;                      % kn --> m/s
HEEL_deg = HEEL * 57.2957795;     % heel angle in degrees

%[ RF, CEH, RFvisc, RFi]  = calc_fin(VS,FAY,T,C,HEEL); %OK

rozmiar = size (VS);
rozmiar(:,1) = []; % estimation of the size of the vector which will store data

RF(rozmiar) = 0;
RCF(rozmiar) = 0;
RR(rozmiar) = 0;
dRRH(rozmiar) = 0;

SWC        =  calc_SWC(LWL,BWL,TC,CM,V);                   % [m2] : Upright wet surface of canoe body
SWCH       = calc_SWCH(SWC,TC,BWL,CM,HEEL);                   % [m2] : Heeled  wet surface of canoe body
for i = 1: rozmiar
    RF(i)  = calc_fin(VS(i),FAY,T,C,HEEL); %OK

    RCF(i) = calc_RCF(SWCH,VS(i),LWL);
    RR(i) = calc_RR(VS(i),V,CP,LWL,LCBfpp,LCFfpp,BWL,TC,AWP,CM);
    dRRH(i) = calc_dRRH(VS(i),LWL,BWL,TC,LCBfpp,V,HEEL);
end

RC = RCF +RR + dRRH;
Rtot = RC + RF;

%-----------------R(VS)----------------%
 str = sprintf('R(VS) \n AR=%0.1f, HEEL = %0.1f [deg], FAY = %0.1f [N], LWL =%0.1f [m],  BWL = %0.1f [m],  \n TC = %0.1f [m], CM = %0.1f [-], DISPL = %0.1f [m3], CP  = %0.1f [-], AWP = %0.1f [m2], LCBfpp  = %0.1f [m], LCFfpp  = %0.1f [m]' ,T/C,HEEL_deg,FAY, LWL, BWL, TC, CM, V, CP, AWP, LCBfpp, LCFfpp);
% str = sprintf('R(VS)' );
srt_file = sprintf(' RF,RFvisc,RFi,VSmin=%0.1f_VS_max=%0.1f,AR=%0.1f,HEEL=%0.1f[deg],FAY=%0.1f [N],LWL =%0.1f[m],BWL=%0.1f [m],TC=%0.1f [m],CM=%0.1f [-],DISPL=%0.1f [m3],CP=%0.1f [-],AWP=%0.1f [m2],LCBfpp=%0.1f[m],LCFfpp =%0.1f[m]', min(VS), max(VS),(T/C),HEEL_deg,FAY,LWL,BWL,TC, CM,V,CP,AWP, LCBfpp, LCFfpp );
srt_file = strrep(srt_file, '.', ','); %zamieniamy '.' na ',' w nazwie pliku aby sie kompilowalo w latexie
figure ('name','R(VS)');
set(gcf,'Position',get(0,'Screensize')/1.5) % enlarge image to ( .../1.5) full screen
plot(VS,RF, VS,RCF, VS,RR, VS, dRRH, VS, RC, VS, Rtot);
grid on;
xlabel('VS [m/s]');
ylabel('R [N]');
title(str);
legend('RF','RCF','RR','dRRH','RC','Rtot');
print('-djpeg','-r300',srt_file);

