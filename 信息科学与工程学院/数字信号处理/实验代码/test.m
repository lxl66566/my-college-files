% 假设有 x 和 y 数组
x = linspace(0, 10, 100);
y = sin(x) + 0.5 * randn(size(x));

% 使用 findpeaks 函数查找峰值
[peaks, locations] = findpeaks(y, x); % Adjust the threshold as needed

% 画出原始数据和峰值点
figure;
plot(x, y, 'b-', locations, peaks, 'ro');
title('查找峰值');
xlabel('x');
ylabel('y');
legend('原始数据', '峰值点');

% 输出峰值点的 x 和 y 数组
disp('峰值点的 x 坐标数组:');
disp(locations);
disp('峰值点的 y 坐标数组:');
disp(peaks);
