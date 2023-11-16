n=0:199;
a=[1 1 1];
b=[1 0.9 0.81];
[z,p,k]=tf2zp(b,a);
subplot(2,2,1);zplane(z,p);
