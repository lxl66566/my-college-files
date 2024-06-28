x = [0:0.1:1];
yi = [9 9.9 10.8 12 13.8 16.0 19.9 25.7 34 58.1 109];
yirmax = yi / 150
subplot(2,1,1)
plot(x,yirmax)
hold on
xb = [0.1:0.2:0.9];
yb = [32.9 36.6 41.5 48.7 57.5];
ybrmax = yb / 107.1
plot(xb,ybrmax)
subplot(2,1,2)
x(end) = 0.98;
u = [0 0.18 0.46 0.71 0.94 1.2 1.49 1.76 2.14 2.75 3];
urmax = u / 3
plot(x,urmax)
hold on
ub = [0 0.22 0.56 0.86 1.04 1.44 1.76 2.08 2.42 2.78 3];
ubrmax = ub / 3
plot(x,ubrmax)