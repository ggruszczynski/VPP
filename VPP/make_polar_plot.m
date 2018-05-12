function [] = make_polar_plot(TWS, TWA_upwind,VS_upwind, TWA_downwind,VS_downwind)

%-----------------Polar Plot----------------%
str = sprintf('Polar Plot \n TWS=%0.1f [m/s] \n\n',TWS);
srt_file = sprintf('PolarPlot_TWS=%0.1f[ms]',TWS);
srt_file = strrep(srt_file, '.', ','); %zamieniamy '.' na ',' w nazwie pliku aby sie kompilowalo w latexie
figure ('name','Polar Plot');
set(gcf,'Position',get(0,'Screensize')/1.5) % enlarge image to ( .../1.5) full screen
polar(TWA_upwind,VS_upwind,'r');
view([90 -90]) % changes the view so that 0 degrees on is at the top of the figure and increasing angles are in the clockwise direction.
grid on;
xlabel('VS[m/s]');
ylabel('TWA[deg]');
title(str);

hold on
polar(TWA_downwind,VS_downwind,'b');
hold off

legend('VS_{upwind} [m/s]','VS_{downwind} [m/s]' );

print('-djpeg','-r300',srt_file);