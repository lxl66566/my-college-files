function out = scramblefun(pusch_coding_bit,vrb_num,qm,subframeno,ue_index,cellid)
% º”»≈

bit_len = vrb_num*12*12*qm;
cinit = ue_index*(2^14)+subframeno*512+cellid;

NC = 1600;
lenx = NC+bit_len-31;

x1 = zeros(1,31); 
x1(1)=1;
for(iii = 1:31)    
    x2(iii) = mod(cinit,2);
    cinit = floor(cinit/2);
end

for(iii = 1:lenx)
    x1(iii+31) = xor(x1(iii+3),x1(iii));
    temp = x2(iii+3)+x2(iii+2)+x2(iii+1)+x2(iii);
    x2(iii+31) = mod(temp,2);
end
for(iii = 1:bit_len)
    temp = x1(iii+NC)+x2(iii+NC);
    scrambit(iii) = mod(temp,2);
end

 for(kkk=1:bit_len)
    out(kkk) = double(xor(scrambit(kkk),pusch_coding_bit(kkk)));
 end