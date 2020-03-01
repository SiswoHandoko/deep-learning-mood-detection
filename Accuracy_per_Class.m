benar_class_a_1 = 0;
salah_class_a_2 = 0;
salah_class_a_3 = 0;
salah_class_b_1 = 0;
benar_class_b_2 = 0;
salah_class_b_3 = 0;
salah_class_c_1 = 0;
salah_class_c_2 = 0;
benar_class_c_3 = 0;
for i=1:size(guess_train,2)
	if(i<45)
		if(guess_train(i)==1)
			benar_class_a_1 =  benar_class_a_1 + 1;
		elseif(guess_train(i)==2)
			salah_class_a_2 =  salah_class_a_2 + 1;
		else
			salah_class_a_3 =  salah_class_a_3 + 1;
		end
	
	elseif(i<89)
		if(guess_train(i)==2)
			benar_class_b_2 =  benar_class_b_2 + 1;
		elseif(guess_train(i)==1)
			salah_class_b_1 =  salah_class_b_1 + 1;
		else
			salah_class_b_3 =  salah_class_b_3 + 1;
		end
	else
		if(guess_train(i)==3)
			benar_class_c_3 =  benar_class_c_3 + 1;
		elseif(guess_train(i)==2)
			salah_class_c_2 =  salah_class_c_2 + 1;
		else
			salah_class_c_1 =  salah_class_c_1 + 1;
		end
	end
end



%akurasi_a = (benar_class_a / 44) * 100;
%akurasi_b = (benar_class_b / 44) * 100;
%akurasi_c = (benar_class_c / 44) * 100;