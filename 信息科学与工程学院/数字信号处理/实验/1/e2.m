close all
clear

% 11阶滑动平均系统
n = 0:100;
wn = floor(rand(1,101) * 11) - 5;
xn = 10*cos(0.08*pi.*n)+wn;
yn = filter(1/11*ones(1,11),1,xn);

s1 = subplot(5,1,1);plot(n,xn);
title('x(n)');
s2 = subplot(5,1,2);plot(n,yn);
title('y(n)');

% x(n) 的 2 阶差分信号
vn = filter([1,-2,1],1,xn);
s3 = subplot(5,1,3);plot(n,vn);
title('v(n)');

% v 与 w 的相关序列
s4 = subplot(5,1,4);plot(-100:100,xcorr(vn,wn));
title('v(n), w(n) 相关序列');

% v 与随机的相关序列
wn = floor(rand(1,101) * 11) - 5;
s5 = subplot(5,1,5);plot(-100:100,xcorr(vn,wn));
title('v(n) 与其他随机的相关序列');

