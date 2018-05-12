function varargout = digi_hull(varargin)
% Simply run this file from the MATLAB Editor
% (don't call as a function)

% Check for proper number of input arguments
error(nargchk(0,1,nargin));

% Identify image filename
if (nargin == 0),
     [filename, pathname] = uigetfile( ...
	       {'*.jpg;*.tif;*.gif;*.png;*.bmp', ...
		'All MATLAB Image Files (*.jpg,*.tif,*.gif,*.png,*.bmp)'; ...
		'*.jpg;*.jpeg', ...
		'JPEG Files (*.jpg,*.jpeg)'; ...
		'*.tif;*.tiff', ...
		'TIFF Files (*.tif,*.tiff)'; ...
		'*.gif', ...
		'GIF Files (*.gif)'; ...
		'*.png', ...
		'PNG Files (*.png)'; ...
		'*.bmp', ...
		'Bitmap Files (*.bmp)'; ...
		'*.*', ...
		'All Files (*.*)'}, ...
	       'Select image file');
     if isequal(filename,0) | isequal(pathname,0)
	  return
     else
	  imagename = fullfile(pathname, filename);
     end
elseif nargin == 1,
     imagename = varargin{1};
     [path, file,ext] = fileparts(imagename);
     filename = strcat(file,ext);
end   

% Read image from target filename
pic = imread(imagename);
image(pic);    
% colormap([0 0 0;1 1 1])

% 'Position', [0 0.125 1 0.85], ...
FigName = ['IMAGE: ' filename];
set(gcf,'Units', 'normalized', ...
	'Name', FigName, ...
	'NumberTitle', 'Off', ...
	'MenuBar','None')
set(gca,'Units','normalized','Position',[0   0 1   1]);

% Determine location of origin with mouse click
OriginButton = questdlg('Select the ORIGIN with left mouse button click', ...
			'DIGITIZE: user input required', ...
			'OK','Cancel','OK');
switch OriginButton,
     case 'OK',
	  drawnow
	  [Xopixels,Yopixels] = ginput(1);
	  line(Xopixels,Yopixels,...
	       'Marker','o','Color','g','MarkerSize',14)
	  line(Xopixels,Yopixels,...
	       'Marker','x','Color','g','MarkerSize',14)
     case 'Cancel',
	  close(FigName)
	  return
end % switch OriginButton

% Prompt user for X- & Y- values at origin
prompt={'Enter the abcissa (X value) at the origin',...
        'Enter the ordinate (Y value) at the origin:'};
def={'0','0'};
dlgTitle='DIGITIZE: user input required';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
if (isempty(char(answer{:})) == 1),
     close(FigName)
     return
else
    OriginXYdata = str2num(char(answer{:}));
end


% Define X-axis
XLimButton = questdlg(...
	  'Select a point on the X-axis with left mouse button click ', ...
	  'DIGITIZE: user input required', ...
	  'OK','Cancel','OK');
switch XLimButton,
     case 'OK',
	  drawnow
	  [XAxisXpixels,XAxisYpixels] = ginput(1);
	  line(XAxisXpixels,XAxisYpixels,...
	       'Marker','*','Color','b','MarkerSize',14)
	  line(XAxisXpixels,XAxisYpixels,...
	       'Marker','s','Color','b','MarkerSize',14)
     case 'Cancel',
	  close(FigName)
	  return
end % switch XLimButton

% Prompt user for XLim value
prompt={'Enter the abcissa (X value) at the selected point'};
def={'1'};
dlgTitle='DIGITIZE: user input required';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
if (isempty(char(answer{:})) == 1),
     close(FigName)
     return
else
     XAxisXdata = str2num(char(answer{:}));
end

% Determine X-axis scaling
Xtype = questdlg(...
	  'Select axis type for absicca (X)', ...
	  'DIGITIZE: user input required', ...
	  'LINEAR','LOGARITHMIC','Cancel');
drawnow
switch upper(Xtype),
     case 'LINEAR',
	  logx = 0;
	  scalefactorXdata = XAxisXdata - OriginXYdata(1);
     case 'LOGARITHMIC',
	  logx = 1;
	  scalefactorXdata = log10(XAxisXdata/OriginXYdata(1));
     case 'CANCEL',
	  close(FigName)
	  return
end % switch Xtype


% Rotate image if necessary
% note image file line 1 is at top
th = atan((XAxisYpixels-Yopixels)/(XAxisXpixels-Xopixels));  
% axis rotation matrix
rotmat = [cos(th) sin(th); -sin(th) cos(th)];    


% Define Y-axis
YLimButton = questdlg(...
	  'Select a point on the Y-axis with left mouse button click', ...
	  'DIGITIZE: user input required', ...
	  'OK','Cancel','OK');
switch YLimButton,
     case 'OK',
	  drawnow
	  [YAxisXpixels,YAxisYpixels] = ginput(1);
	  line(YAxisXpixels,YAxisYpixels,...
	       'Marker','*','Color','b','MarkerSize',14)
	  line(YAxisXpixels,YAxisYpixels,...
	       'Marker','s','Color','b','MarkerSize',14)
     case 'Cancel',
	  close(FigName)
	  return
end % switch YLimButton

% Prompt user for YLim value
prompt={'Enter the ordinate (Y value) at the selected point'};
def={'1'};
dlgTitle='DIGITIZE: user input required';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);
if (isempty(char(answer{:})) == 1),
     close(FigName)
     return
else
     YAxisYdata = str2num(char(answer{:}));
end

% Determine Y-axis scaling
Ytype = questdlg('Select axis type for ordinate (Y)', ...
		 'DIGITIZE: user input required', ...
		 'LINEAR','LOGARITHMIC','Cancel');
drawnow
switch upper(Ytype),
     case 'LINEAR',
	  logy = 0;
	  scalefactorYdata = YAxisYdata - OriginXYdata(2);
     case 'LOGARITHMIC',
	  logy = 1;
	  scalefactorYdata = log10(YAxisYdata/OriginXYdata(2));
     case 'CANCEL',
	  close(FigName)
	  return
end % switch Ytype

% Complete rotation matrix definition as necessary
delxyx = rotmat*[(XAxisXpixels-Xopixels);(XAxisYpixels-Yopixels)];
delxyy = rotmat*[(YAxisXpixels-Xopixels);(YAxisYpixels-Yopixels)];
delXcal = delxyx(1);
delYcal = delxyy(2);

% Commence Data Acquisition from image
msgStr{1} = 'Click with LEFT mouse button to ACQUIRE';
msgStr{2} = ' ';
msgStr{3} = 'PC: Click with RIGHT mouse button to start new section';
msgStr{4} = ' ';
msgStr{5} = 'MAC: CTRL-Click to start new section';
msgStr{6} = ' ';
msgStr{7} = 'Press Q to quit';
titleStr = 'Ready for data acquisition';
uiwait(msgbox(msgStr,titleStr,'warn','modal'));
drawnow

numberformat = '%6.2f';
nXY = [];
ng = 0;
ii=0;
while 1,
    ii=ii+1;
     fprintf('\n INFO >> PC: Click with RIGHT mouse button to start new section \n');
     fprintf('\n INFO >> MAC: CTRL-Click to start new section \n');
     fprintf('\n INFO >> Press Q to quit \n\n');
     n = 0;
     NN=[];     xpt=[]; ypt=[];
     disp(sprintf('\n %s \n',' Index          X            Y'))
     
% %%%%%%%%%%%%%% DATA ACQUISITION LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     while 1
	  [x,y, buttonNumber] = ginput(1);                       
	  xy = rotmat*[(x-Xopixels);(y-Yopixels)];
	  delXpoint = xy(1);
	  delYpoint = xy(2);
	  if buttonNumber == 1, 
	       line(x,y,'Marker','.','Color','r','MarkerSize',12)
	       if logx,
		    x = OriginXYdata(1)*10^(delXpoint/delXcal*scalefactorXdata);
	       else
		    x = OriginXYdata(1) + delXpoint/delXcal*scalefactorXdata;
	       end
	       if logy, 
		    y = OriginXYdata(2)*10^(delYpoint/delYcal*scalefactorYdata);
	       else  
		    y = OriginXYdata(2) + delYpoint/delYcal*scalefactorYdata;
	       end
	       n = n+1;
           NN(n) = n;
	       xpt(n) = x;
	       ypt(n) = y;
	       disp(sprintf(' %4d         %f      %f',n, x, y))
	       ng = ng+1;
	       nXY(ng,:) = [n x y];
           
      elseif buttonNumber == 3
          break     %   Exit loop and save current section
      else
          % Convert the offsets into Britfair format and save to file
            [filename, pathname, filterindex] = uiputfile('*.bri', 'Save Britfair file as');
            fid = fopen(filename,'wt');
            fprintf(fid,filename);
            fprintf(fid,'\n%d\n',1);
            for ii = 1:length(sections)
                section_tmp1 = abs(sections(ii).section);
                section_tmp2 = section_tmp1(:,2:3);     % X- and Y-coordinates
                Noff = size(section_tmp2,1);      	% number of section offsets
                fprintf(fid,'%d %f %f \n',Noff,ii,ii);
                for jj = 1:Noff
                    fprintf(fid,'%f %f\n',section_tmp2(jj,1),section_tmp2(jj,2));
                end
                fprintf(fid,'%d\n',0);
            end
            fprintf(fid,'%d %d %d\n',0,0,0);
            fclose(fid);
          return
      end
     end
     sections(ii) = struct('section',[NN' xpt' ypt'])
% %%%%%%%%%%%%%% DATA ACQUISITION LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end






