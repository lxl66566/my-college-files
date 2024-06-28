wp = [0.3, 0.7];
ws = [0.2, 0.8];
rp = 0.5; rs = 50;
fs = 100;

[n, Wn] = buttord(wp, ws, rp, rs);
[b, a] = butter(n, Wn);
[H, w] = freqz(b, a);
subplot(2, 2, 1);
plot(w * fs / (2 * pi), abs(H)); grid; title('butter');

[n, Wn] = cheb1ord(wp, ws, rp, rs);
[b, a] = cheby1(n, rp, Wn);
[H, w] = freqz(b, a);
subplot(2, 2, 2);
plot(w * fs / (2 * pi), abs(H)); grid; title('cheby1');

[n, Wn] = cheb2ord(wp, ws, rp, rs);
[b, a] = cheby2(n, rs, Wn);
[H, w] = freqz(b, a);
subplot(2, 2, 3);
plot(w * fs / (2 * pi), abs(H)); grid; title('cheby2');

[n, Wn] = ellipord(wp, ws, rp, rs);
[b, a] = ellip(n, rp, rs, Wn);
[H, w] = freqz(b, a);
subplot(2, 2, 4);
plot(w * fs / (2 * pi), abs(H)); grid; title('ellip');
