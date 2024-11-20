function out = TDLTE_genFredata(inputdata)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%student code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 产生频域数据

    nfft = 2048; % 表示 FFT（快速傅里叶变换）的长度，这里设置为 2048。
    nulsym = 7; % 表示空符号的数量，这里设置为 7。
    start = 1; % 表示起始位置，这里设置为 1。
    half = 600;
    total = 1200; % 表示数据的总长度，这里设置为 1200。
    out = zeros(14, 2048); % 初始化一个 14 行 2048 列的零矩阵，用于存储生成的频域数据。

    % for (iii = 1:2 * nulsym)：循环从 1 到 2 * nulsym，即从 1 到 14。从 inputdata 的第 iii 行中提取数据，并将数据分成两部分：
    %     inputdata(iii, (half + 1):total)：提取第 iii 行的第 601 到 1200 个元素。
    %     zeros(1, (nfft - total))：生成一个长度为 nfft - total（即 848）的零向量。
    %     inputdata(iii, 1:half)：提取第 iii 行的第 1 到 600 个元素。
    %     将这三部分数据拼接成一个长度为 2048 的向量 tmpdata。
    %     out(iii, 1:nfft) = tmpdata; ：将生成的 tmpdata 存储到 out 矩阵的第 iii 行。

    for (iii = 1:2 * nulsym)
        %端口0，符号iii
        tmpdata = [inputdata(iii, (half + 1):total), zeros(1, (nfft - total)), inputdata(iii, 1:half)];
        %     iffttmpdata = ifft(tmpdata,2048);
        %     fftmpdata = fft(iffttmpdata,2048);
        %     tail = start+nfft-1;
        %     out([start:tail]) =tmpdata([1:nfft]);
        %     start = tail+1;
        out(iii, 1:nfft) = tmpdata;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
