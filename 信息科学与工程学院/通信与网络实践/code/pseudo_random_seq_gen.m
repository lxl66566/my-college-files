function[out] =pseudo_random_seq_gen(init_value,length)
%generatot pseudo_random_sequence according to Cinit
NC = 1600;
lenx=NC+length-31;

x1=zeros(1,31); x1(1)=1;
for(iii=1:31)    
    x2(iii)=mod(init_value,2);
    init_value=floor(init_value/2);
end

for(iii=1:lenx)
    x1(iii+31)=xor(x1(iii+3),x1(iii));
    temp = x2(iii+3)+x2(iii+2)+x2(iii+1)+x2(iii);
    x2(iii+31)=mod(temp,2);
end
for(iii=1:length)
    temp = x1(iii+NC)+x2(iii+NC);
    out(iii) = mod(temp,2);
end
return