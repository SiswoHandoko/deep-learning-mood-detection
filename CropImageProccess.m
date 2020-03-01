function img_vj = CropImageProccess(Picture,Objects)

% Crop Object Gambar
if(~isempty(Objects));
    for n=1:size(Objects,1)
        x1=Objects(n,1); y1=Objects(n,2);
        x2=x1+Objects(n,3); y2=y1+Objects(n,4);
		
		%untuk nge crop nya
		J = imcrop(Picture,[x1 y1 x2 y2]);
		pict_array{n} = J;
    end
	img_vj = pict_array;
else
	error('Face Image not found on this pict');
end
