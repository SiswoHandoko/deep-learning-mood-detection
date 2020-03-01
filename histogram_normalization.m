function [H_img] = histogram_normalization(Img)
    
    numofpixels=size(Img,1)*size(Img,2);
    
    % Membuat matrix 0 + string to int
    H_img=uint8(zeros(size(Img,1),size(Img,2)));
    f_pxl=zeros(256,1);              % var kemunculan pixel sama
    f_prob=zeros(256,1);             % var untuk probabilitas per pxl
    f_prob_all=zeros(256,1);         % probabilitas all pxl
    temp_arr=zeros(256,1);               % temp jml matrix     
    round_temp=zeros(256,1);               % temp untuk round 


   %f_pxl perhitungan tiap nilai pixel
   %The probability of each occurrence is calculated by f_prob.


   for i=1:size(Img,1)
        for j=1:size(Img,2)
            value=Img(i,j);
            %f_pxl[n+1] = banyak nilai matrix yang sama di Img
            f_pxl(value+1)=f_pxl(value+1)+1;
            %f_prob[n+1] = nilai matrix f_pxl / numpixels
            f_prob(value+1)=f_pxl(value+1)/numofpixels;
        end

   end

   jumlah=0;                    % temp jumlah                
   no_bins=255;                 % biner

   % menghitung kemunculan

   for i=1:size(f_prob)
       
       jumlah=jumlah+f_pxl(i);
       temp_arr(i)=jumlah;
       f_prob_all(i)=temp_arr(i)/numofpixels;
       %buletin ke atas
       round_temp(i)=round(f_prob_all(i)*no_bins);

   end

   for i=1:size(Img,1)
       for j=1:size(Img,2)
               H_img(i,j)=round_temp(Img(i,j)+1);
       end

   end

end
