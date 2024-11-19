function decodeout = TDLTE_de_turboCode(coded_data,C,Kp)
for r = 1:C
      info_len = Kp;
     % decodeout = turbo_decode(coded_data1((3*(r-1)+1):3*r,1:(info_len+4)),info_len,16);
     decodeout(r,:) = deCdblk_turboCode(coded_data((3*(r-1)+1):3*r,1:(info_len+4)));
end