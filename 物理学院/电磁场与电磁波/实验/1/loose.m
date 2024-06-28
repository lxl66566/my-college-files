% 超松弛迭代法
clear;
hx = 201;
hy = 101;
c = hx - 1;
d = hy - 1;

% 计算最佳收敛因子与迭代次数
% w=2-pi*sqrt(2/c^2+2/d^2);
% 因为是单个数值，需要去掉 for 循环

% 填表
w = linspace(1.9, 1.98, 9);

for wi = w

    A1 = ones(hy, hx);
    A1(hy, :) = ones(1, hx) * 100;
    A1(1, :) = zeros(1, hx);

    for i = 1:hy;
        A1(i, 1) = 0;
        A1(i, hx) = 0;
    end

    A2 = A1;
    maxt = 1;
    k = 0;

    while (maxt > 1e-5)
        k = k + 1;
        maxt = 0;

        for i = 2:hy - 1

            for j = 2:hx - 1;
                A2(i, j) = A1(i, j) + (A1(i, j + 1) + A1(i + 1, j) + A2(i - 1, j) + A2(i, j - 1) - 4 * A1(i, j)) * wi / 4;
                t = abs(A2(i, j) - A1(i, j));

                if (t > maxt)
                    maxt = t;
                end

            end

        end

        A1 = A2;
    end

    wi
    k
end

%x=(0:1:hx-1)/hx;
%y=(0:1:hy-1)/hy;
%CS = contour(x,y,A2,10)
%clabel(CS);
%A2
%k
%w
%maxt
