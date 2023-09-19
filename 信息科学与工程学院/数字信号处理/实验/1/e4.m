close all
clear
[x, fs] = audioread('./wav/canon.wav');
f = size(x)(1);
y = zeros(f,2);
o = n = 8;
while n < f
  y(n,1) = x(n,1);
  y(n,2) = x(n,2);
  n += o;
end
audiowrite('./wav/test.wav', y, fs);