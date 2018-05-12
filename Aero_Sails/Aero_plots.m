function [] = Aero_plots(TWS,VS,HEEL,TWA,R,hulldata,rigdata,SAILSET)

HEELd = HEEL *180/pi;

TWAd = 40 : 1 :180;
TWA = TWAd * 2 *pi /360;         % true wind angle [rad]

rozmiarFA = size (TWA);
rozmiarFA(:,1) = []; % estimation of the size of the vector which will store data

FA = zeros(3, rozmiarFA);
L(rozmiarFA) = 0;
D_TOT(rozmiarFA) = 0;
D_i(rozmiarFA) = 0;
D_visc(rozmiarFA) = 0;

for i = 1: rozmiarFA
    [FA(:,i) CEA L(i) D_TOT(i) D_i(i)  D_visc(i)]= calc_aero(TWS,VS,HEEL,TWA(i),R,hulldata,rigdata,SAILSET);
end


%-----------------F(TWA)----------------%
 str = sprintf('F(TWA) \n TWS=%0.1f [m/s], VS = %0.1f [m/s],  HEEL = %0.1f [deg], SAILSET = %d, R = %0.1f',TWS, VS, HEELd, SAILSET,R);
srt_file = sprintf('F(TWA)_TWS=%0.1f[ms]_VS =%0.1f [ms]_HEEL=%0.1f [deg]_SAILSET=%d_R =%0.1f',TWS, VS, HEELd, SAILSET,R);
srt_file = strrep(srt_file, '.', ','); %zamieniamy '.' na ',' w nazwie pliku aby sie kompilowalo w latexie
figure ('name','F(TWA)');
set(gcf,'Position',get(0,'Screensize')/1.5) % enlarge image to ( .../1.5) full screen
% plot(TWAd,FA(1,:),TWAd,FA(2,:));
plot(TWAd,FA(1,:),TWAd,FA(2,:), TWAd, L, TWAd, D_TOT);
grid on;
xlabel('TWA[deg]');
ylabel('F [N]');
title(str);
% legend('FAx','FAy');
legend('FAx','FAy', 'L', 'D_{TOT}');
print('-djpeg','-r300',srt_file);


%-----------------D(TWA)----------------%
 str = sprintf('D(TWA) \n TWS=%0.1f [m/s], VS = %0.1f [m/s],  HEEL = %0.1f [deg], SAILSET = %d, R = %0.1f',TWS, VS, HEELd, SAILSET,R);
srt_file = sprintf('D(TWA)_TWS=%0.1f[ms]_VS =%0.1f [ms]_HEEL=%0.1f [deg]_SAILSET=%d_R =%0.1f',TWS, VS, HEELd, SAILSET,R);
srt_file = strrep(srt_file, '.', ','); %zamieniamy '.' na ',' w nazwie pliku aby sie kompilowalo w latexie
figure ('name','D(TWA)');
set(gcf,'Position',get(0,'Screensize')/1.5) % enlarge image to ( .../1.5) full screen
plot( TWAd, D_TOT, TWAd, D_i, TWAd, D_visc, TWAd, L);
grid on;
xlabel('TWA[deg]');
ylabel('D [N]');
title(str);
legend('D_{TOT}','D_i','D_{visc}','L');
print('-djpeg','-r300',srt_file);


%-----------------S_ref(R)----------------%

R = 0.3 : 0.01 :1;
S = R.^2;

 str = sprintf('S(R)[m2]');
srt_file = sprintf('S(R)[m2]');
srt_file = strrep(srt_file, '.', ','); %zamieniamy '.' na ',' w nazwie pliku aby sie kompilowalo w latexie
figure ('name','S(R)[m2]');
set(gcf,'Position',get(0,'Screensize')/1.5) % enlarge image to ( .../1.5) full screen
plot( R, S);
grid on;
xlabel('R[-]');
ylabel('S [m2]');
title(str);
legend('S[m2]');
print('-djpeg','-r300',srt_file);

% %-----------------FA(AWA, R) -> 3D PLOT --------------------------------%
% 
%  R = 0.5 :0.1 :1;
%  rozmiarR = size (R);
%  rozmiarR(:,1) = []; % estimation of the size of the vector which will store data
% 
%  FA = zeros(3, rozmiarFA,rozmiarR);
%  
%     for j = 1: rozmiarR
%         for i = 1: rozmiarFA
%             FA(:,i,j) = calc_aero(TWS,VS,HEEL,TWA(i),R(j),hulldata,rigdata,SAILSET);
%         end
%     end
%     
% FAx = FA(1,:,:);
% FAx = squeeze(FAx); % Remove singleton dimensions
% 
% str = sprintf('FA(TWA, R) \n TWS=%0.1f [m/s], VS = %0.1f [m/s],  HEEL = %0.1f [deg], SAILSET = %d, R = %0.1f',TWS, VS, HEELd, SAILSET,R);
% srt_file = sprintf('FA(TWA, R)_TWS=%0.1f[ms]_VS =%0.1f [ms]_HEEL=%0.1f [deg]_SAILSET=%d_R =%0.1f',TWS, VS, HEELd, SAILSET,R);
% srt_file = strrep(srt_file, '.', ','); %zamieniamy '.' na ',' w nazwie pliku aby sie kompilowalo w latexie
% figure ('name','FA(AWA, R)');       
% title(str);
% surfc(R,TWAd,FAx,'FaceColor','interp','EdgeColor','none')
% colormap hsv
% colorbar
% xlabel('R [-]');
% ylabel('TWA [deg]');
% zlabel('FAx [N]');
% print('-djpeg','-r300',srt_file);
