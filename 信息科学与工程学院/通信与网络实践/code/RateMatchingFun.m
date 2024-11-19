function [rmdata,rmlen]=RateMatchingFun(codedata,Channel_type, Nir, C, Cm,direction, module_type, RVidx, Nl, G,Km,Kp)
for k=1:C
    if(k<=Cm)
        info_len = Km;%K+
    else
        info_len = Kp;%K_
    end
    [temp_data,rmlen(k)] = RateMatching(codedata(3*(k-1)+1:3*k,1:info_len+4), Channel_type, Nir, C, direction, module_type, RVidx, Nl, G, k-1);
    rmdata(k,1:rmlen(k)) = temp_data;    
end