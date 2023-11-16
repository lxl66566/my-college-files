fs = 50;
r = 6;
x = 0:1 / fs:r;
y = 2 * (x >= 0 & x < 5);

subplot(3, 1, 1); stem(y); title('x(n)');
subplot(3, 1, 2);
freqz(0.02, [1 -0.9802]);
