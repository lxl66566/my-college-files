% 该函数的主要目的是将输入的频域数据转换为时域数据，并将这些时域数据按顺序填充到一个预定义长度的输出数组中。
function out = TDLTE_genantdata(inputdata)
    % 产生天线时域数据

    % 参数定义
    nfft = 2048; % FFT点数，用于将频域数据转换为时域数据
    nulsym = 7; % 符号数，表示输入数据的符号数量
    start = 1; % 输出数据的起始位置
    out = zeros(1, 28672); % 初始化输出数据，长度为28672

    % 循环处理每个符号
    for (iii = 1:2 * nulsym)
        tmpdata = inputdata(iii, :); % 获取当前符号的频域数据
        ifftdata = ifft(tmpdata, 2048); % 对当前符号进行IFFT，转换为时域数据
        tail = start + nfft - 1; % 计算当前符号时域数据的结束位置
        out([start:tail]) = ifftdata([1:nfft]); % 将时域数据填充到输出数组中
        start = tail + 1; % 更新起始位置，为下一个符号做准备
    end

end
