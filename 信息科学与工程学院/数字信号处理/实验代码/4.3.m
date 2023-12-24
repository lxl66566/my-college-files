close all
clear
% octave 没有 remezord
f = [0.3 0.4 0.6 0.7]; m = [1 0 1];
rp = 0.5; rs = 60;
dat1 = (10^(rp / 20) - 1) / (10^(rp / 20) + 1); dat2 = 10^(-rs / 20);
rip = [dat1 dat2 dat1];
[M, fo, mo, wo] = remezord(f, m, rip);
hn = remez(M, fo, mo, wo);
[H, w] = freqz(hn, 1);
subplot(2, 1, 1); stem(0:M, hn); title('脉冲响应');
subplot(2, 1, 2); plot(w / pi, 20 * log10(abs(H))); title('幅频响应');
