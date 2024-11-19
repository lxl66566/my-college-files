function out =genFredata(inputdata)
% 产生频域数据

nfft=2048;
nulsym = 7;
start =1;
half =600;
total =1200;
out = zeros(14,2048);

for(iii=1:2*nulsym)
    %端口0，符号iii
    tmpdata=[inputdata(iii,(half+1):total),zeros(1,(nfft-total)),inputdata(iii,1:half)];
%     iffttmpdata = ifft(tmpdata,2048);
%     fftmpdata = fft(iffttmpdata,2048);
%     tail = start+nfft-1;
%     out([start:tail]) =tmpdata([1:nfft]);      
%     start = tail+1;   
     out(iii,1:nfft)=tmpdata;
end