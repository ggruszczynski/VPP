
%-----------------R(VS)----------------%
str = sprintf('R(VS) \n AR=%0.1f, HEEL = %0.1f [deg]', T/C,HEEL_deg);
srt_file = sprintf(' RF,RFvisc,RFi,VSmin=%0.1f_VS_max=%0.1f,AR=%0.1f,HEEL=%0.1f[deg]', min(VS), max(VS),(T/C),HEEL_deg);
srt_file = strrep(srt_file, '.', ','); %zamieniamy '.' na ',' w nazwie pliku aby sie kompilowalo w latexie
figure ('name','RF(VS)');
plot(VS,RF, VS, RFvisc, VS, RFi);
grid on;
xlabel('VS [m/s]');
ylabel('R [N]');
title(str);
legend('RF', 'RFvisc', 'RFi');
print('-djpeg','-r300',srt_file);

%-----------------CL(VS), Cl(VS)----------------%
str = sprintf('CL_{3D}(VS), Cl_{2D}(VS) \n AR=%0.1f, HEEL = %0.1f [deg]', T/C,HEEL_deg);
srt_file = sprintf(' CL,Cl,VSmin=%0.1f_VS_max=%0.1f,AR=%0.1f,HEEL=%0.1f[deg]', min(VS), max(VS),(T/C),HEEL_deg);
srt_file = strrep(srt_file, '.', ','); %zamieniamy '.' na ',' w nazwie pliku aby sie kompilowalo w latexie
figure ('name','CL,Cl_2D');
plot(VS,CL_3D, VS, CL_2D);
grid on;
xlabel('VS [m/s]');
ylabel('CL_{3D}, CL_{2D}');
title(str);
legend('CL_{3D}', 'Cl_{2D}');
print('-djpeg','-r300',srt_file);

%-----------------alfa(VS))----------------%
str = sprintf('alfa(VS) \n AR=%0.1f, HEEL = %0.1f [deg]', T/C,HEEL_deg);
srt_file = sprintf(' alfa,VSmin=%0.1f_VS_max=%0.1f,AR=%0.1f,HEEL=%0.1f[deg]', min(VS), max(VS),(T/C),HEEL_deg);
srt_file = strrep(srt_file, '.', ','); %zamieniamy '.' na ',' w nazwie pliku aby sie kompilowalo w latexie
figure ('name','alfa_deg');
plot(VS,alfa_deg);
grid on;
xlabel('VS [m/s]');
ylabel('alfa[deg]');
title(str);
legend('alfa - leeway');
print('-djpeg','-r300',srt_file);
