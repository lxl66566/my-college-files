function out = TDLTE_fftantdata(inputdata)

    % 时域数据FFT变换成频域数据
    % 该函数将输入的时域数据通过快速傅里叶变换（FFT）转换为频域数据。
    % 输入参数:
    %   inputdata - 输入的时域数据，通常是一个包含多个符号的信号。
    % 输出参数:
    %   out - 转换后的频域数据，与输入数据的长度相同。

    % 定义常量
    nrbul = 100; % 未使用，可能是遗留代码或占位符
    nfft = 2048; % FFT点数，即每个符号的采样点数
    nulsym = 7; % 符号数量
    start = 1; % 输出数组的起始索引

    % 循环处理每个符号
    for (iii = 1:2 * nulsym)

        % 提取当前符号的时域数据
        tmpdata = inputdata((iii - 1) * nfft + 1:iii * nfft);

        % 对当前符号的时域数据进行FFT变换
        fftdata = fft(tmpdata, 2048);

        % 计算当前符号的频域数据在输出数组中的位置
        tail = start + nfft - 1;

        % 将FFT变换后的频域数据存储到输出数组中
        out([start:tail]) = fftdata([1:nfft]);

        % 更新输出数组的起始索引
        start = tail + 1;

    end

end
