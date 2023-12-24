close all
clear
[x, fs] = audioread('../audio/good.wav');
subplot(2, 1, 1); plot(x); title('原始音频');
f = size(x)(1);
r = 4000;
y = zeros(f, 1);

for n = r + 1:f
    y(n) = 0.5 * x(n - r);
end

y = x + y;
subplot(2, 1, 2); plot(y); title('混响后音频');
audiowrite('../audio/new_good.wav', y, fs);
