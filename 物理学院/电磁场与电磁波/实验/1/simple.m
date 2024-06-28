% 简单迭代法加速收敛因子与收敛次数
clear;
hx = 201;
hy = 101;
v1 = ones(hy, hx);
v1(hy, :) = ones(1, hx) * 100;
v1(1, :) = zeros(1, hx);

for i = 1:hy;
    v1(i, 1) = 0;
    v1(i, hx) = 0;
end

v1
v2 = v1;
maxt = 1;
t = 0;
k = 0;

while (maxt > 1e-5)
    k = k + 1;
    maxt = 0;

    for i = 2:hy - 1

        for j = 2:hx - 1
            v2(i, j) = (v1(i, j + 1) + v1(i + 1, j) + v1(i - 1, j) + v1(i, j - 1)) / 4;
            t = abs(v2(i, j) - v1(i, j));

            if (t > maxt) maxt = t;
            end

        end

    end

    v1 = v2;
end

v2
x = (0:1:hx - 1) / 10;
y = (0:1:hy - 1) / 10;
CS = contour(x, y, v2, 10)
clabel(CS)
v2
k
maxt
% 24561
