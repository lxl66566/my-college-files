function out =remap(moddata,rs_slot1,rs_slot2,rbnum,rbstart)
% 资源映射

start=1;
carry_len = rbnum*12;
rs_station = 4;
nulsym = 7;
vrb_num = rbnum;
out = zeros(14,1200);
 for(kkk=0:rbnum-1)
        prb_slot1(kkk+1) = rbstart+kkk;
        prb_slot2(kkk+1) = rbstart+kkk;
 end
 
 for(iii=1:nulsym)  %每个符号分别处理
    if(iii == rs_station)  %导频映射
        for(kkk =1:vrb_num)
            out(iii,[prb_slot1(kkk)*12+1:(prb_slot1(kkk)*12+12)]) = rs_slot1(((kkk-1)*12+1):kkk*12);
        end
        continue;
    end
    tail = start+carry_len-1;
    %决定是否用fft,选择用还是不用
%     dft_out = fft(pusch_d([start:tail]),carry_len)/sqrt(carry_len); % add sqrt(carry_len) for power consistent by maoxuewei@20090228;
     dft_out = moddata(start:tail);
    start =tail+1;
    %物理资源映射    
    for(kkk =1:vrb_num)
        out(iii,[prb_slot1(kkk)*12+1:(prb_slot1(kkk)*12+12)]) = dft_out(((kkk-1)*12+1):kkk*12);
    end
end
for(iii=nulsym+1:2*nulsym)  %每个符号分别处理
    if(iii == rs_station+nulsym)        %导频映射
        for(kkk =1:vrb_num)
            out(iii,[prb_slot2(kkk)*12+1:(prb_slot2(kkk)*12+12)]) = rs_slot2(((kkk-1)*12+1):kkk*12);
        end
        continue;
    end
    tail = start+carry_len-1;
%     dft_out = fft(pusch_d([start:tail]),carry_len)/sqrt(carry_len); % add sqrt(carry_len) for power consistent;
    dft_out = moddata(start:tail);
    start =tail+1;
    %物理资源映射    
    for(kkk =1:vrb_num)
        out(iii,[prb_slot2(kkk)*12+1:(prb_slot2(kkk)*12+12)]) = dft_out(((kkk-1)*12+1):kkk*12);
    end
end

