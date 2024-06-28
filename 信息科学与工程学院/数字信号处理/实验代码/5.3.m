% 干净执行
close all
clear
% 画短时傅里叶谱图
[music, Fs] = audioread('../audio/M1_i1.wav');
music = music(:, 1) ./ max(music(:, 1));
F0 = 1; % 观察谱间隔暂定1 Hz
test_Num = 400; % 画谱图的临时帧长
frame_N = floor(length(music) / test_Num); % 帧数
frame_t = (0:frame_N - 1) * test_Num / Fs; % 谱图横坐标单位调为时间(s)
fft_N = Fs / F0; % 每一帧FFT的点数，暂设为44100点
frame_f = (0:floor(fft_N - 1)) * F0; % 谱图纵坐标单位为Hz
frame_A = zeros(fft_N, frame_N); % frame_A记录某一帧的某一频率处的值，后面用颜色显示

% 计算短时傅里叶谱图
for i = 1:frame_N
    % 每一帧400点，均乘400点哈明窗后，做44100点FFT
    start_idx = (i - 1) * test_Num + 1;
    end_idx = i * test_Num;
    fft_result = fft(music(start_idx:end_idx) .* hamming(test_Num), fft_N);
    frame_A(:, i) = abs(fft_result);
end

% 绘制短时傅里叶谱图
figure(5); subplot(211);
imagesc(frame_t, frame_f, frame_A);
axis xy;
M_T = ceil(length(music) / Fs);
axis([0 M_T 0 2000]);
