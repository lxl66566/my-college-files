% 前置：5.1, 5.3（非干净执行，需要修改 5.3）
% 关闭所有图窗，开始索引设为第一个峰值对应的帧数
close all;
starti = peakx_filtered_2(1) * Frame_Num;

% 设置测试信号的长度
test_N = 400;

% 提取测试信号
i = starti:starti + test_N;
test_music = music(i);

% 绘制测试信号时域波形
subplot(331);
plot(test_music);
title('实际长度：400点');

% 计算测试信号的FFT并绘制矩形窗谱图（44100点FFT）
test_music_FFT = fft(test_music, 44100);
subplot(334);
stem(abs(test_music_FFT) / max(abs(test_music_FFT)));
title('矩形窗谱图，44100点FFT');
axis([0 1000 0 1]);

% 计算测试信号的FFT并绘制哈明窗谱图（44100点FFT）
test_music_FFT = fft(test_music .* hamming(length(test_music)), 44100);
subplot(337);
stem(abs(test_music_FFT) / max(abs(test_music_FFT)));
title('哈明窗谱图，44100点FFT');
axis([0 1000 0 1]);
