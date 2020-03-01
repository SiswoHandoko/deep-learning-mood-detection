%----------------------------------------------------------------------------------------------------------------------------------------------------------
%---------------------------------------------TEST OUTPUT DARI VIOLA JONES LANGSUNG DI MASUKIN KE CNN------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------------------------------------------------

cd ViolaJones
% ConvertHaarcasadeXMLOpenCV('HaarCascades/haarcascade_frontalface_alt.xml');


% [nama_file, nama_path,tes] = uigetfile('*.jpg');												%Get File unparsed name
% img = imread([nama_path nama_file]);		
% img = imread('Images/2.jpg');		
% I = findstr('.',nama_file);																		%parse string with . remove ext
% file = nama_file(1:I(end)-1);																	%get 1 - before .


ConvertHaarcasadeXMLOpenCV('HaarCascades/haarcascade_frontalface_alt.xml');

[nama_file, nama_path,tes] = uigetfile('*.jpg');
I = imread([nama_path nama_file]);

FilenameHaarcasade = 'HaarCascades/haarcascade_frontalface_alt.mat';
Objects=ObjectDetection(I,FilenameHaarcasade);

%condition 1 = pengecekan face, 2 plot gambar
condition = 1;	

img_vj = ShowDetectionResult(I,Objects,condition);
				
												
label_test = [];
for i=1:size(img_vj,2)
	temp_lbl = [0 0 0];																				%label default
    label_test = [label_test; temp_lbl];	
end
	label_test = label_test';																		%transpose

%------------------------------------------------
for i=1:size(img_vj,2)
	img_resize=imresize(img_vj{1,i},[28,28]); 														%ubah ukuran 
	img_gray = rgb2gray(img_resize);																%udah gray
	img_double =  double(img_gray);
	data_test(:,:,i)=img_double(:,:); 																	%menjadi vektor x
end

cd ../cnn

[er_test, bad_test, guess_test, class_test] = cnntest(cnn, data_test, label_test);

ShowDetectionResultCustom(I,Objects,guess_test);