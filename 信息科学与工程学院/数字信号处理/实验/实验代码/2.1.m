nx=0:199;
xn=sin(0.1*pi*nx)+cos(0.5*pi*nx);
hn=0.25*ones(1,4);
nh=0:3;
yn=conv(xn,hn);
ny=nx(1)+nh(1):nx(end)+nh(end);
subplot(4,1,1);stem(ny,yn);

xk=fft(xn,203);
subplot(4,1,2);plot(abs(xk));

hk=fft(hn,203);
subplot(4,1,3);plot(abs(hk));

yk=xk.*hk;
yn=ifft(yk);
subplot(4,1,4);stem(yn);