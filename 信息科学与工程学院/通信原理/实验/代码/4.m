%% 3.带通滤波器
[y5] = FM_bandpass(y4, Fc, fs, F);
[n1] = FM_bandpass(y3, Fc, fs, F);

%% 4.解调
%% 4.1微分
dt = 1 / fs;
y6 = diff(y5) ./ dt;
n2 = diff(n1) ./ dt;

%% 4.2包络检波
y7 = abs(hilbert(y6));
n3 = abs(hilbert(n2));

%% 4.3低通滤波
[Y] = FM_lowpass(y7, fs, F);
[N] = FM_lowpass(n3, fs, F);
zero = (max(Y) + min(Y)) / 2;
zero_n = (max(N) + min(N)) / 2;
Y = Y - zero; %去除直流
N = N - zero_n;
%恢复解调信号幅度
Y = Y / (max(Y)) * (max(y3));
N = N / (max(N)) * (max(y3));

input_signal_power = mean(y3.^2); % 已调信号平均功率
input_noise_power = mean((y4 - y3).^2); % 解调器输入噪声平均功率
input_snr = input_signal_power / input_noise_power; % 输入信噪比

output_signal_power = mean(Y.^2); % 解调器输出有用信号平均功率
output_noise_power = mean((N - Y).^2); % 解调器输出噪声平均功率
output_snr = output_signal_power / output_noise_power; % 输出信噪比
G = output_snr / input_snr; % 制度增益G

% 输出制度增益G
disp(['制度增益G = ', num2str(G)]);
disp(['输入信噪比 = ', num2str(input_snr)]);
disp(['输出信噪比 = ', num2str(output_snr)]);
