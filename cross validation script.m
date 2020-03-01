% =========================================================
% CROSS VALIDAITON (5 FOLDS OF 660 DATA)
% RANDOM DATA TRAIN PICKER
%==========================================================
a = 1001;
b = 1220;

namefile=zeros(528,1);

for i=1:176
	n = 0;
	while n == 0

		j=1;
		temp = round((b-a).*rand(1,1) + a);
		find_name = find(namefile == temp);
		if(isempty(find_name))
		 	n = 1;
		end
	end
namefile(i) = temp;
end


a = 2001;
b = 2220;

for i=177:352
	n = 0;
	while n == 0

		j=1;
		temp = round((b-a).*rand(1,1) + a);
		find_name = find(namefile == temp);
		if(isempty(find_name))
		 	n = 1;
		end
	end
namefile(i) = temp;
end


a = 3001;
b = 3220;

for i=353:528
	n = 0;
	while n == 0

		j=1;
		temp = round((b-a).*rand(1,1) + a);
		find_name = find(namefile == temp);
		if(isempty(find_name))
		 	n = 1;
		end
	end
namefile(i) = temp;
end

% =========================================================
% END PICKER DATA PROCESS
%==========================================================


% =========================================================
% PARSE DATA TO CNN
% PRA PROCESSING DATA 
%==========================================================

addpath('img_train/ALL');

n = size(namefile,1);

for i=1:n
	
	%convert int to string
	string_name = num2str(namefile(i));
	
	img=imread([string_name '.png']);
	img_resize=imresize(img,[28,28]); 									%ubah ukuran 
	img_gray = rgb2gray(img_resize);									%udah grayscale
	img_hist = histogram_normalization(img_gray);						% normalisasi histogram
	img_double =  double(img_hist);										%ubah ke double
	data_train(:,:,i)=img_double(:,:); 									%menjadi vektor x

end

%Split Name jadi class dan label
temp_1 = {};
for i=1:n
	%convert int to string
	string_name = num2str(namefile(i));

    [pathstr,name,ext] = fileparts([string_name '.png']);
    temp_1{i} = name;
end

%make label jadi matrix
label_train = [];
for i=1:n
    fname = temp_1{i};													%ngambil namanya
    switch fname(1)														%case mood by name
        case '1'
            temp_lbl = [1 0 0];
        case '2'
            temp_lbl = [0 1 0];
		case '3'
			temp_lbl = [0 0 1];
		otherwise 
			temp_lbl = [0 0 0];
    end
    label_train = [label_train; temp_lbl];
end
	label_train = label_train';											%transpose

% =========================================================
% END PRA PROCESSING DATA 
%==========================================================


% =========================================================
% CNN SETTING TO CNN TRAIN
%==========================================================
addpath('cnn/');
cnn.layers = {
    struct('type', 'i') 												%input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) 				%convolution layer
    struct('type', 's', 'scale', 2) 									%sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5)				%convolution layer
    struct('type', 's', 'scale', 2) 									%subsampling layer
};

rand('state', 0)

opts.alpha = 1;
opts.batchsize = 44;    													%harus bisa di bagi
opts.numepochs = 10000;

cnn = cnnsetup(cnn, data_train, label_train);

cnn = cnntrain(cnn, data_train, label_train, opts);

% =========================================================
% END OF CNN TRAIN
%==========================================================













% =========================================================
% CROSS VALIDAITON (5 FOLDS OF 660 DATA)
% RANDOM DATA TEST PICKER
%==========================================================
a = 1001;
b = 1220;

namefile_test=zeros(132,1);

for i=1:44
	n = 0;
	while n == 0

		j=1;
		temp = round((b-a).*rand(1,1) + a);
		find_name = find(namefile == temp);
		find_name_test = find(namefile_test == temp);
		if(isempty(find_name) & isempty(find_name_test))
		 	n = 1;
		end
	end
namefile_test(i) = temp;
end


a = 2001;
b = 2220;

for i=45:88
	n = 0;
	while n == 0

		j=1;
		temp = round((b-a).*rand(1,1) + a);
		find_name = find(namefile == temp);
		find_name_test = find(namefile_test == temp);
		if(isempty(find_name) & isempty(find_name_test))
		 	n = 1;
		end
	end
namefile_test(i) = temp;
end


a = 3001;
b = 3220;

for i=89:132
	n = 0;
	while n == 0

		j=1;
		temp = round((b-a).*rand(1,1) + a);
		find_name = find(namefile == temp);
		find_name_test = find(namefile_test == temp);
		if(isempty(find_name) & isempty(find_name_test))
		 	n = 1;
		end
	end
namefile_test(i) = temp;
end

% =========================================================
% END PICKER DATA PROCESS
%==========================================================



% =========================================================
% PARSE DATA TO CNN
% PRA PROCESSING DATA 
%==========================================================

addpath('img_train/');

n = size(namefile_test,1);

for i=1:n
	
	%convert int to string
	string_name = num2str(namefile_test(i));
	
	img=imread([string_name '.png']);
	img_resize=imresize(img,[28,28]); 									%ubah ukuran 
	img_gray = rgb2gray(img_resize);									%udah grayscale
	img_hist = histogram_normalization(img_gray);						% normalisasi histogram
	img_double =  double(img_hist);										%ubah ke double
	data_test(:,:,i)=img_double(:,:); 									%menjadi vektor x

end

%Split Name jadi class dan label
temp_1 = {};
for i=1:n
	%convert int to string
	string_name = num2str(namefile_test(i));

    [pathstr,name,ext] = fileparts([string_name '.png']);
    temp_1{i} = name;
end

%make label jadi matrix
label_train = [];
for i=1:n
    fname = temp_1{i};													%ngambil namanya
    switch fname(1)														%case mood by name
        case '1'
            temp_lbl = [1 0 0];
        case '2'
            temp_lbl = [0 1 0];
		case '3'
			temp_lbl = [0 0 1];
		otherwise 
			temp_lbl = [0 0 0];
    end
    label_train = [label_train; temp_lbl];
end
	label_train = label_train';											%transpose

% =========================================================
% END PRA PROCESSING DATA 
%==========================================================


% =========================================================
% CNN TEST
%==========================================================
addpath('cnn/');
[er_train, bad_train ,guess_train ,class_train] = cnntest(cnn, data_test, label_train);


save('m-10000-2612-1.mat','cnn','data_train','label_train','er_train','bad_train','guess_train','class_train');
% =========================================================
% END CNN TEST
%==========================================================