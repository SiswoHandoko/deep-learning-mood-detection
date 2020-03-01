function varargout = mood_detect_app(varargin)
% MOOD_DETECT_APP MATLAB code for mood_detect_app.fig
%      MOOD_DETECT_APP, by itself, creates a new MOOD_DETECT_APP or raises the existing
%      singleton*.
%
%      H = MOOD_DETECT_APP returns the handle to a new MOOD_DETECT_APP or the handle to
%      the existing singleton*.
%
%      MOOD_DETECT_APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOOD_DETECT_APP.M with the given input arguments.
%
%      MOOD_DETECT_APP('Property','Value',...) creates a new MOOD_DETECT_APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mood_detect_app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mood_detect_app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mood_detect_app

% Last Modified by GUIDE v2.5 25-Sep-2016 12:26:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mood_detect_app_OpeningFcn, ...
                   'gui_OutputFcn',  @mood_detect_app_OutputFcn, ...
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


% --- Executes just before mood_detect_app is made visible.
function mood_detect_app_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mood_detect_app (see VARARGIN)

% Choose default command line output for mood_detect_app
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mood_detect_app wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mood_detect_app_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_mood_detect.
function btn_mood_detect_Callback(hObject, eventdata, handles)
% hObject    handle to btn_mood_detect (see GCBO)
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

% If output only 1
if(size(img_vj,2)==1)
   jml_img = 2; 
else
   jml_img = size(img_vj,2); 
end
    
%Pra Processing Beta 
for i=1:jml_img
    % If output only 1
    if(size(img_vj,2)==1)
       img_resize=imresize(img_vj{1,1},[28,28]);
    else
       img_resize=imresize(img_vj{1,i},[28,28]);
    end
    
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
imshow(I,'Parent',handles.axes7), hold on;

%jika Object detection dari viola jones !=0
if(~isempty(Objects));
    good = 0;
    normal = 0;
    bad = 0;
    for n=1:size(Objects,1)
        x1=Objects(n,1); y1=Objects(n,2);
        %penambahan dengan posisis x1 dan y1 karna titik 0,0 dinamis
        x2=x1+Objects(n,3); y2=y1+Objects(n,4);
        %cek prediksi mood
        guess_test(1,n);
        switch guess_test(1,n)
            %draw plot kotak x1 + y1, x1 +y2, dst
            case 1
                good = good+1;
                %plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'g');
            case 2
                normal = normal+1;
                %plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'y');
            case 3
                bad = bad+1;
                %plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'r');
        end
    
    end
    
    if(good>normal && good>bad)
        plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'g');
    elseif(normal>good && normal>bad)
        plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'y');
    else
        plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'r');
    end
    
end


% --- Executes on button press in btn_browse.
function btn_browse_Callback(hObject, eventdata, handles)
% hObject    handle to btn_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
global img_vj
global Objects

[nama_file, nama_path,tes] = uigetfile('*');

% ConvertHaarcasadeXMLOpenCV('HaarCascades/haarcascade_frontalface_alt.xml');
I = imread([nama_path nama_file]);

I= imresize(I,[900,900]);
imshow(I,'Parent',handles.axes1)																%show Gambar di GUI




% --- Executes on button press in btn_resize.
function btn_resize_Callback(hObject, eventdata, handles)
% hObject    handle to btn_resize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
global img_vj
global Objects
img_resize=imresize(I,[28,28]);
imshow(img_resize,'Parent',handles.axes3)

% --- Executes on button press in btn_gray.
function btn_gray_Callback(hObject, eventdata, handles)
% hObject    handle to btn_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
global img_vj
global Objects
img_resize=imresize(I,[28,28]);
if(size(img_resize,3)~=1) 														 
    img_gray = rgb2gray(img_resize);
    imshow(img_gray,'Parent',handles.axes4)
else
    imshow(img_resize,'Parent',handles.axes4)
end


% --- Executes on button press in btn_normalization.
function btn_normalization_Callback(hObject, eventdata, handles)
% hObject    handle to btn_normalization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
global img_vj
global Objects

img_resize=imresize(I,[28,28]);
%if tidak channel rgb
if(size(img_resize,3)~=1) 														 
    img_gray = rgb2gray(img_resize);
    img_hist =  histogram_normalization(img_gray);
    imshow(img_hist,'Parent',handles.axes5)
else
    img_hist =  histogram_normalization(img_resize);
    imshow(img_hist,'Parent',handles.axes5)
end

%pembentukan matrix 3 dimensi m x n x jumlah



% --- Executes on button press in btn_double.
function btn_double_Callback(hObject, eventdata, handles)
% hObject    handle to btn_double (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
global img_vj
global Objects
img_resize=imresize(I,[28,28]);
%if tidak channel rgb
if(size(img_resize,3)~=1) 														 
    img_gray = rgb2gray(img_resize);
    img_hist =  histogram_normalization(img_gray);

else
    img_hist =  histogram_normalization(img_resize);

end
img_double =  double(img_hist);
imshow(img_double,'Parent',handles.axes6)

% --- Executes on button press in btn_face_detect.
function btn_face_detect_Callback(hObject, eventdata, handles)
% hObject    handle to btn_face_detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
global img_vj
global Objects

cd ViolaJones
FilenameHaarcasade = 'HaarCascades/haarcascade_frontalface_alt.mat';
Objects=ObjectDetection(I,FilenameHaarcasade);

%show image di axes GUI
imshow(I,'Parent',handles.axes2), hold on;

%jika Object detection dari viola jones != 0
if(~isempty(Objects));

    for n=1:size(Objects,1)
        x1=Objects(n,1); y1=Objects(n,2);
        %penambahan dengan posisis x1 dan y1 karna titik 0,0 dinamis
        x2=x1+Objects(n,3); y2=y1+Objects(n,4);
        %cek prediksi mood
        plot_post = plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'b');
        set(plot_post,'Parent', handles.axes2)

    end
    
end
cd ..	
%proses pemotongan image 
img_vj = CropImageProccess(I,Objects);
