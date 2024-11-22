function decodeout = TDLTE_de_turboCode(coded_data, C, Kp)
    % TDLTE_de_turboCode - 对LTE下行链路传输块进行Turbo码解码
    %
    % 输入参数:
    %   coded_data - 输入的编码数据矩阵，大小为 (3C x (Kp + 4))
    %   C - 传输块的数量
    %   Kp - 每个传输块的比特数
    %
    % 输出参数:
    %   decodeout - 解码后的数据矩阵，大小为 (C x Kp)

    % 对每个传输块进行Turbo码解码
    for r = 1:C
        info_len = Kp; % 每个传输块的比特数
        % 调用deCdblk_turboCode函数进行解码
        decodeout(r, :) = deCdblk_turboCode(coded_data((3 * (r - 1) + 1):3 * r, 1:(info_len + 4)));
    end

end
