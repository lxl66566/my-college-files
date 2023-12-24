close all
clear
hold on;

% 读取音频并处理（双声道转单声道）
[music, Fs] = audioread('../audio/star_69.wav');
music = music(:, 1) ./ max(music(:, 1));
subplot(411); plot(music);
time = length(music) / Fs;

% 计算包络
Frame_Num = 70;
envelope1 = [];

for i = 1:floor(length(music) / Frame_Num) - 1
    temp = music((i - 1) * Frame_Num +1:i * Frame_Num);
    envelope1 = [envelope1 max(temp) - min(temp)];
end

% 中值滤波
envelope1 = medfilt1(envelope1, 30);
envelope1 = envelope1 ./ max(envelope1);
envelope1_extend = repelem(envelope1, Frame_Num);
subplot(412);
plot(envelope1_extend);

% 寻找峰值
[peaky, peakx] = findpeaks(envelope1_extend);
_filter = peaky > 0.38;
peakx_filtered = peakx(_filter);
peaky_filtered = peaky(_filter);
subplot(413); plot(peakx_filtered, peaky_filtered, 'o');

% 过滤峰值。函数的作用是在检测到峰值后对其后的 step 长度切片，在每个切片中只保留值最大的一个峰值点
function [out_x, out_y] = x_fil(peak_x, peak_y, step)
    assert(length(peak_x) == length(peak_y));
    out_x = [];
    out_y = [];
    _start = peak_x(1);
    _maxy = peak_y(1);
    _maxx = _start;

    for i = 1:length(peak_x)

        if (peak_x(i) - _start) <= step

            if (peak_y(i) > _maxy)
                _maxy = peak_y(i);
                _maxx = peak_x(i);
            end

        else
            out_x = [out_x, _maxx];
            out_y = [out_y, _maxy];
            _start = peak_x(i);
            _maxy = peak_y(i);
            _maxx = _start;
        end

    end

    out_x = [out_x, _maxx];
    out_y = [out_y, _maxy];

end

[peakx_filtered_2, peaky_filtered_2] = x_fil(peakx_filtered, peaky_filtered, 30000);
subplot(414); plot(peakx_filtered_2, peaky_filtered_2, 'o');
