close all
clear
wp = [0.3 * pi, 0.7 * pi];
ws = [0.4 * pi, ws2 = 0.6 * pi];
tr_width = 0.1 * pi;
M = ceil(6.6 * pi / tr_width);
wc = (wp + ws) ./ 2;
h = fir1(M, wc / pi, 'stop', hamming(M + 1));
[H, w] = freqz(h, 1);
subplot(2, 1, 1); stem(0:M, h); title('脉冲响应');
subplot(2, 1, 2); plot(w / pi, 20 * log10(abs(H))); title('幅频响应');
grid on;
