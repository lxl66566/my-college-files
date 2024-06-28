% 前置：5.1
close all
Frame_Num = 100;
% 定义标准节拍和初始化实际节拍和误差
hold on;
N = 42;
ideal_Beat_T = [1 1 1 1 1 1 2 1 1 1 1 1 1 2 1 1 1 1 1 1 2 1 1 1 1 1 1 2 1 1 1 1 1 1 2 1 1 1 1 1 1 2];
Real_Beat_T = [];

% 计算实际节拍和误差
for i = 1:N - 1
    Real_Beat_T = [Real_Beat_T (peakx_filtered_2(i + 1) - peakx_filtered_2(i)) * Frame_Num / Fs * 69/60];
end

%归一化
ideal_Beat_T = normalize(ideal_Beat_T, "range");
Real_Beat_T = normalize(Real_Beat_T, "range");
Err_Beat_T = Real_Beat_T - ideal_Beat_T(1:end - 1);

% 绘制图表
subplot(2, 1, 1);
plot(1:N - 1, Real_Beat_T, 'bo');
hold on;
plot(1:N - 1, ideal_Beat_T(1:N - 1), 'r*');
grid on;
title('理论节拍（红）与实际节拍（蓝）');

subplot(212);
plot(1:N - 1, Err_Beat_T, 'bx');
grid on;
title('误差率');
