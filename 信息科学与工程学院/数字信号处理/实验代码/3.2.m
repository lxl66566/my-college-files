fs = 10000;
wp = 1500 * 2 / fs;
ws = 2000 * 2 / fs;
rp = 3; rs = 40;

[n, Wn] = buttord(wp, ws, rp, rs);
[b, a] = butter(n, Wn, 'high');
[H, w] = freqz(b, a);
subplot(3, 1, 1); plot(w * fs / (2 * pi), abs(H)); grid; title('butter');

t = 0:1 / fs:1;
f1 = 900;
f2 = 4500;
x = sin(2 * pi * f1 * t) + 0.5 * sin(2 * pi * f2 * t);
y = filter(b, a, x);
subplot(3, 1, 2);
plot(t(1:100), x(1:100));
title('Original Signal'); xlabel('Time (s)'); ylabel('Amplitude');

subplot(3, 1, 3);
plot(t(1:100), y(1:100));
title('Filtered Signal'); xlabel('Time (s)'); ylabel('Amplitude');
