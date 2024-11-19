function out = TDLTE_Deremap(inputdata)
% ½â×ÊÔ´Ó³Éä
nrbul =100;
nfft =2048;
nulsym =7;
start =1;
half = nrbul*6;
total = nrbul*12;
for(iii=1:2*nulsym)
        
    fftout = inputdata((iii-1)*nfft+1:iii*nfft);
    out(iii,start:total) = [fftout((nfft-half+1):nfft),fftout(1:half)];
       
end