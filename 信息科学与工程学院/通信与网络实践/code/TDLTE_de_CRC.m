function [tb_data, crc_flag] = TDLTE_de_CRC(decodeout, C)
    % TDLTE_de_CRC - 对解码后的数据进行CRC校验和去除CRC
    %
    % 输入参数:
    %   decodeout - 解码后的数据矩阵，大小为 (C x (K + 24))
    %   C - 传输块的数量
    %
    % 输出参数:
    %   tb_data - 去除CRC后的传输块数据，大小为 (1 x (K - 24))
    %   crc_flag - CRC校验标志符，0表示校验通过，1表示校验失败

    temp_len = 1; % 初始化临时长度

    for r = 1:C
        %% 子块CRC校验
        if (C > 1)
            check_out(1, r) = CRC_check(decodeout(r, :), 2); % 对每个子块进行CRC校验
            % 去除子块CRC，解码块分割
            sub_cw = decodeout(r, 1:(length(decodeout) - 24)); % 去除子块CRC
            temp_tb_data(1, temp_len:(temp_len + length(sub_cw) - 1)) = sub_cw; % 存储去除CRC后的子块数据
            temp_len = temp_len + length(sub_cw); % 更新临时长度
        else
            temp_tb_data = decodeout; % 如果只有一个传输块，直接使用解码后的数据
        end

    end

    %% 传输块CRC校验
    crc_flag = CRC_check(temp_tb_data, 1); % 对传输块进行CRC校验，返回校验标志符

    % 去除传输块CRC
    tb_data = temp_tb_data(1, 1:(length(temp_tb_data) - 24)); % 去除传输块CRC
end
