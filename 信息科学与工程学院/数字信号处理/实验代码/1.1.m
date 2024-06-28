close all
clear
n = 0:29;
xn = (0.9 .* exp(-0.2 * pi * i)).^n;
s1 = subplot(2, 2, 1); stem(n, real(xn));
title('实部')
s2 = subplot(2, 2, 2); stem(n, imag(xn));
title('虚部')
s3 = subplot(2, 2, 3); stem(n, abs(xn));
title('幅频')
s4 = subplot(2, 2, 4); stem(n, angle(xn));
title('相频')
