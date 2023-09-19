close all
clear
[x, fs] = audioread('./wav/good.wav');
f = size(x)(1);
r = 4000;
y = zeros(f,1);
for n = r+1 : f
    y(n) = 0.5 * x(n-r);
end
y = x + y;
audiowrite('./wav/new_good.wav', y, fs);