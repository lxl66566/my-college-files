close all
clear
fs = 1/0.02;
r = 6;
x = 0:1 / fs:r;
xn = 2 * (x >= 0 & x < 5);
value = xn(xn > 0);
b = 0.02; a = [1 -0.9802];
figure 1; stem(xn); title('x(n)');
figure 2; freqz(0.02, [1 -0.9802]);
yn = filter(b, a, value);
figure 3; plot(yn); title('yn');
