close all
clear

M = 61;
alpha = (M - 1) / 2;
k = 0:M - 1;
wk = (2 * pi / M) * k;
Hrs = [ones(1, 10), 0.594, 0.109, zeros(1, 7), 0.109, 0.594, ones(1, 20), 0.594, 0.109, zeros(1, 7), 0.109, 0.594, ones(1, 9)];
k1 = 0:floor((M - 1) / 2);
k2 = floor((M - 1) / 2) + 1:M - 1;
angH = [-alpha * 2 * pi / M * k1, alpha * 2 * pi / M * (M - k2)];
H = Hrs .* exp(1j * angH);
h = real(ifft(H, M));
[Ha, w] = freqz(h, 1);

subplot(2, 1, 1);
stem(k, h);
axis([-1, M, -0.1, 0.3]);
title('脉冲响应');
grid;

subplot(2, 1, 2);
plot(w / pi, 20 * log10(abs(Ha)));
axis([0, 1, -60, 10]);
title('幅频响应');
grid;
