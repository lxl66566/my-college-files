function coded_data = TDLTE_TurboEncodeFun(C,cdblksegdata,Cm,Km,Kp,F)
%Turbo±àÂë
% coded_data = zeros(3*C,Cp+4);

for k=1:C
    if(k<=Cm)
        info_len = Km;%K+
    else
        info_len = Kp;%K_
    end
    %Turbo±àÂë
    coded_data(3*(k-1)+1:3*k,1:info_len+4)=Turbo_encoder1(cdblksegdata(k,:),info_len);
   if(k==1)
        if F>0
            coded_data(1:2,1:F) = 2*ones(2,F); %fill "2" indecate the NULL
        end
   end

end