function out = fftantdata(inputdata)
% 时域数据FFT变换成频域数据
nrbul =100;
nfft =2048;
nulsym =7;
start =1;

for(iii=1:2*nulsym)
        
    tmpdata = inputdata((iii-1)*nfft+1:iii*nfft);
    fftdata = fft(tmpdata,2048);
     tail = start+nfft-1;
    out([start:tail]) =fftdata([1:nfft]);      
    start = tail+1;   
       
end