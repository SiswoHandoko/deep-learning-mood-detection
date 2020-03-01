function varargout = moodDetect(varargin)
	% MOODDETECT MATLAB code for moodDetect.fig
	%      MOODDETECT, by itself, creates a new MOODDETECT or raises the existing
	%      singleton*.
	%
	%      H = MOODDETECT returns the handle to a new MOODDETECT or the handle to
	%      the existing singleton*.
	%
	%      MOODDETECT('CALLBACK',hObject,eventData,handles,...) calls the local
	%      function named CALLBACK in MOODDETECT.M with the given input arguments.
	%
	%      MOODDETECT('Property','Value',...) creates a new MOODDETECT or raises the
	%      existing singleton*.  Starting from the left, property value pairs are
	%      applied to the GUI before moodDetect_OpeningFcn gets called.  An
	%      unrecognized property name or invalid value makes property application
	%      stop.  All inputs are passed to moodDetect_OpeningFcn via varargin.
	%
	%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
	%      instance to run (singleton)".
	%
	% See also: GUIDE, GUIDATA, GUIHANDLES

	% Edit the above text to modify the response to help moodDetect

	% Last Modified by GUIDE v2.5 19-Jun-2016 20:36:08

	% Begin initialization code - DO NOT EDIT
	gui_Singleton = 1;
	gui_State = struct('gui_Name',       mfilename, ...
					   'gui_Singleton',  gui_Singleton, ...
					   'gui_OpeningFcn', @moodDetect_OpeningFcn, ...
					   'gui_OutputFcn',  @moodDetect_OutputFcn, ...
					   'gui_LayoutFcn',  [] , ...
					   'gui_Callback',   []);
	if nargin && ischar(varargin{1})
		gui_State.gui_Callback = str2func(varargin{1});
	end

	if nargout
		[varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
	else
		gui_mainfcn(gui_State, varargin{:});
	end
	% End initialization code - DO NOT EDIT


	% --- Executes just before moodDetect is made visible.
function moodDetect_OpeningFcn(hObject, eventdata, handles, varargin)
	% This function has no output args, see OutputFcn.
	% hObject    handle to figure
	% eventdata  reserved - to be defined in a future version of MATLAB
	% handles    structure with handles and user data (see GUIDATA)
	% varargin   command line arguments to moodDetect (see VARARGIN)

	% Choose default command line output for moodDetect
	handles.output = hObject;

	% Update handles structure
	guidata(hObject, handles);

	% UIWAIT makes moodDetect wait for user response (see UIRESUME)
	% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = moodDetect_OutputFcn(hObject, eventdata, handles) 
	% varargout  cell array for returning output args (see VARARGOUT);
	% hObject    handle to figure
	% eventdata  reserved - to be defined in a future version of MATLAB
	% handles    structure with handles and user data (see GUIDATA)

	% Get default command line output from handles structure
	varargout{1} = handles.output;


% --- Executes on button press in browse_photo.
function browse_photo_Callback(hObject, eventdata, handles)
	% hObject    handle to browse_photo (see GCBO)
	% eventdata  reserved - to be defined in a future version of MATLAB
	% handles    structure with handles and user data (see GUIDATA)
	
	global I
	global img_vj
	global Objects
	
	

	[nama_file, nama_path,tes] = uigetfile('*');
    cd ViolaJones
	% ConvertHaarcasadeXMLOpenCV('HaarCascades/haarcascade_frontalface_alt.xml');
	I = imread([nama_path nama_file]);
    
    I= imresize(I,[600,600]);
	imshow(I,'Parent',handles.axes1)																%show Gambar di GUI
	
	FilenameHaarcasade = 'HaarCascades/haarcascade_frontalface_alt.mat';
	Objects=ObjectDetection(I,FilenameHaarcasade);
    
    cd ..	
    %proses pemotongan image 
    img_vj = CropImageProccess(I,Objects);
					
											
	

	% --- Executes on button press in detect.
function detect_Callback(hObject, eventdata, handles)
	% hObject    handle to detect (see GCBO)
	% eventdata  reserved - to be defined in a future version of MATLAB
	% handles    structure with handles and user data (see GUIDATA)
	
	global I
	global img_vj
	global Objects
	
    %proses pemberian label default untuk proses perhitungan cnn
	label_test = [];
	for i=1:size(img_vj,2)
		temp_lbl = [0 0 0];                                
		label_test = [label_test; temp_lbl];	
	end
		label_test = label_test';						
    
    %Pra Processing Beta 
	for i=1:size(img_vj,2)
		img_resize=imresize(img_vj{1,i},[28,28]);
		%if tidak channel rgb
		if(size(img_resize,3)~=1) 														 
			img_gray = rgb2gray(img_resize);
			img_hist =  histogram_normalization(img_gray);
		else
			img_hist =  histogram_normalization(img_resize);
        end
        img_double =  double(img_hist);
        
		%img_double =  double(img_gray);
        %pembentukan matrix 3 dimensi m x n x jumlah
		data_test(:,:,i)=img_double(:,:);
    end
    
    %load model dengan 100 epoch
    addpath('Model/');
	load m-10000-2612-3.mat
	addpath('cnn/');
    
    %test and detect mood dengan cnn
	[er_test, bad_test, guess_test, class_test] = cnntest(cnn, data_test, label_test);

	%cd ..
    
    %show image di axes GUI
	imshow(I,'Parent',handles.axes1), hold on;
	
    %jika Object detection dari viola jones !=0
	if(~isempty(Objects));
		for n=1:size(Objects,1)
			x1=Objects(n,1); y1=Objects(n,2);
            %penambahan dengan posisis x1 dan y1 karna titik 0,0 dinamis
            x2=x1+Objects(n,3); y2=y1+Objects(n,4);
			%cek prediksi mood
            guess_test(1,n);
			switch guess_test(1,n)
                %draw plot kotak x1 + y1, x1 +y2, dst
				case 1
					plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'g');
				case 2
					plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'y');
				case 3
					plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'r');
			end
			
		end
    end
