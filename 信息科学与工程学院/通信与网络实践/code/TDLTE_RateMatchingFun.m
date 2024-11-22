function [rmdata, rmlen] = TDLTE_RateMatchingFun(codedata, Channel_type, Nir, C, Cm, direction, module_type, RVidx, Nl, G, Km, Kp)
    % TDLTE_RateMatchingFun - 进行LTE下行链路传输块的速率匹配
    %
    % 输入参数:
    %   codedata - 输入的编码数据矩阵，大小为 (3C x (Km + 4)) 或 (3C x (Kp + 4))
    %   Channel_type - 信道类型，例如 'PDSCH' 或 'PUSCH'
    %   Nir - 速率匹配后的目标比特数
    %   C - 传输块的数量
    %   Cm - 包含K+的传输块数量
    %   direction - 速率匹配的方向，'forward' 或 'backward'
    %   module_type - 模块类型，例如 'Turbo' 或 'LDPC'
    %   RVidx - 冗余版本索引
    %   Nl - 层数
    %   G - 总比特数
    %   Km - 包含K+的传输块的比特数
    %   Kp - 包含K_的传输块的比特数
    %
    % 输出参数:
    %   rmdata - 速率匹配后的数据矩阵，大小为 (C x max(rmlen))
    %   rmlen - 每个传输块速率匹配后的长度向量，大小为 (1 x C)

    % 初始化输出矩阵和长度向量
    rmdata = zeros(C, max(rmlen));
    rmlen = zeros(1, C);

    % 对每个传输块进行速率匹配
    for k = 1:C

        % 确定当前传输块的比特数
        if (k <= Cm)
            info_len = Km; % 包含K+的传输块
        else
            info_len = Kp; % 包含K_的传输块
        end

        % 调用RateMatching函数进行速率匹配
        [temp_data, rmlen(k)] = RateMatching(codedata(3 * (k - 1) + 1:3 * k, 1:info_len + 4), Channel_type, Nir, C, direction, module_type, RVidx, Nl, G, k - 1);

        % 将速率匹配后的数据存储到输出矩阵中
        rmdata(k, 1:rmlen(k)) = temp_data;
    end

end
