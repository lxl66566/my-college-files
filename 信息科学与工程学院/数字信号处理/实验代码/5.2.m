% 需要先执行过 5.1
close all
% 假设 music 是原音频的行向量，peakx_filtered_2 是音符的开始点向量
% 1. 取实际长度的 2/3
actual_length_factor = 2/3;
actual_lengths = round(diff([peakx_filtered_2, length(music)]) * actual_length_factor);

% 2. 乘窗函数：在实际取到的音程段上乘以相同点数的窗函数
window = hann(max(actual_lengths));

% 从频域获取音符
function note_symbols = get_note_symbols(fft_frequency, fft_result)
    % 找到前两个幅度最大的频率索引
    [~, sorted_indices] = sort(abs(fft_result), 'descend');
    max_indices = sorted_indices(1:2);

    % 获取对应的频率
    max_frequencies = fft_frequency(max_indices);

    % 使用 A4（钢琴中央C的440Hz）作为参考频率，计算音符符号
    reference_frequency = 440; % 可以根据需要调整
    note_numbers = round(12 * log2(max_frequencies / reference_frequency) + 69);

    % 使用数字谱进行映射（A0是1，C8是88）
    note_symbols = num2str(note_numbers - 20);
end

for i = 1:length(peakx_filtered_2)
    segment = music(peakx_filtered_2(i):(peakx_filtered_2(i) + actual_lengths(i) - 1));
    processed_music = segment .* window'(1:length(segment));

    fft_points = 2^nextpow2(length(segment)); % 选择最接近窗口大小的2的幂次方作为FFT点数
    fft_result = fft(processed_music, fft_points);
    fft_result = abs(fft_result);

    % 计算频率轴
    fft_frequency = (1:fft_points) * Fs / fft_points;
    get_fre = 2000;
    fft_frequency = fft_frequency(1:get_fre);
    fft_result = fft_result(1:get_fre);

    if mod(i - 1, 16) == 0
        figure;
    end

    subplot(4, 4, mod(i - 1, 16) + 1); plot(fft_frequency, fft_result); title(strcat('频谱', int2str(i))); xlabel('频率 (Hz)'); ylabel('幅度'); grid on;
    get_note_symbols(fft_frequency, fft_result)

end
