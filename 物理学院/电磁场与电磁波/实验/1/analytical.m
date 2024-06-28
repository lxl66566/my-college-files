# 解析法代码
clear;
v0 = 100;
a = 2;
b = 1;
[x, y] = meshgrid(0:0.05:a, 0:0.01:b);
v1 = 0;
nnnnn = 200;
p = 0;

if (nnnnn == 1)
    nnn = 1;
else
    nnn = [1:2:2 * (nnnnn -1)];
end

for nnnn = 1:length(nnn)
    % k = 4 * 100/pi;
    n = nnn(nnnn);
    v = 4 * v0 / pi * sinh(n * pi * y / a) .* sin(n * pi * x / a) ./ (n * sinh(n * pi * b / a));
    v = v + v1;
    v1 = v;
    p = p + 1;
end

CS = contour(x, y, v, 10);
clabel(CS);
