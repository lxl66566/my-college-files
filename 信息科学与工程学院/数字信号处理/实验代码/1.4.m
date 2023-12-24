close all
clear

[x, fs] = audioread('../audio/canon.wav');

function y = ex(input, fs, i)
    y = downsample(input, i);
    filename = strcat('../audio/ex', int2str(i), '.wav')
    audiowrite(filename, y, fs);
end

subplot(4, 1, 1); plot(x); title('原始音频');
subplot(4, 1, 2); plot(ex(x, fs, 2)); title('T[x(2n)]');
subplot(4, 1, 3); plot(ex(x, fs, 4)); title('T[x(4n)]');
subplot(4, 1, 4); plot(ex(x, fs, 8)); title('T[x(8n)]');
