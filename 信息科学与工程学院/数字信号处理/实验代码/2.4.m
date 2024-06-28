close all
clear
global index
index = 0;
keyset = {220, 246.94, 261.63, 293.66, 329.63, 349.23, 392}
valueset = {'la-', 'ci-', 'do', 're', 'mi', 'fa', 'so'}

global myMap
myMap = containers.Map(keyset, valueset);

function closestKey = fin_closestKey(targetNumber)
    % ...
end

function detectNotes(y, fs, filename)
    global index
    global myMap
    N = length(y);
    f = (0:N - 1) * (fs / N);
    Y = fft(y);
    N = length(f(f < 800));
    f = f(1:N);
    Y = abs(Y(1:N));

    figure(2);
    subplot(4, 1, index);
    plot(f, Y);
    title(['频谱图 - ' filename]); xlabel('频率 (Hz)'); ylabel('幅度');

    [peaky, peakx] = findpeaks(Y);
    _filter = peaky > 0.9 * max(Y);
    peakx_filtered = peakx(_filter);
    peaky_filtered = peaky(_filter);
    peakx_filtered = f(peakx_filtered);

    % disp(peakx_filtered)
    % disp(peaky_filtered)

    % disp(['在 ' filename ' 中识别到的音符：']);
    % for i = 1:length(peakx_filtered)
    %     detected_notes = fin_closestKey(peakx_filtered(i));
    %     disp(myMap(detected_notes));
    % end

end

function process(file)
    global index
    index = index + 1;
    [x, fs] = audioread(file);

    figure(1);
    subplot(4, 1, index);
    plot(x);
    title(['test' int2str(index)]);

    [~, name, ~] = fileparts(file);
    detectNotes(x, fs, name);
end

process('../audio/test1.wav');
process('../audio/test2.wav');
process('../audio/test3.wav');
process('../audio/test4.wav');
