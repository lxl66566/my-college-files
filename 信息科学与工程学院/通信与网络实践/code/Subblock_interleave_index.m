%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subblock_interleave_index - 子块交织函数，根据3GPP 36.212标准进行速率匹配
%
% 输入参数:
%   Info_data - 输入数据，用于子块交织
%   intl_mode - 交织模式：
%               0 - 用于Turbo编码传输信道的d0和d1分支
%               1 - 用于Turbo编码传输信道的d2分支
%               2 - 用于卷积编码传输信道
% 注意: 输入数据必须为单一流。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Output = Subblock_interleave_index(Info_data, intl_mode)

    % 定义列交织模式
    if (intl_mode == 0) || (intl_mode == 1)
        Col_intl = [0, 16, 8, 24, 4, 20, 12, 28, 2, 18, 10, 26, 6, 22, 14, 30, 1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, 27, 7, 23, 15, 31];
        Col_intl = Col_intl + 1; % 转换为1-based索引
    else
        Col_intl = [1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, 27, 7, 23, 15, 31, 0, 16, 8, 24, 4, 20, 12, 28, 2, 18, 10, 26, 6, 22, 14, 30];
        Col_intl = Col_intl + 1; % 转换为1-based索引
    end

    Col_len = 32; % 列数
    len_info = length(Info_data); % 输入数据长度
    Row = ceil(len_info / Col_len); % 计算行数
    F = Row * Col_len - len_info; % 计算填充的虚拟比特数
    Temp_info = ones(1, Row * Col_len) * 2; % 初始化临时信息矩阵

    % 填充虚拟比特
    Temp_info(1, F + 1:Row * Col_len) = Info_data;

    a = zeros(1, length(Temp_info)); % 用于测试的辅助数组
    m = 1; % 辅助变量

    switch intl_mode
        case 0% 用于Turbo编码传输信道的d0和d1分支
            First_mat = reshape(Temp_info, Col_len, Row); % 将数据重塑为矩阵
            Output = zeros(1, Row * Col_len); % 初始化输出矩阵

            % 进行列交织
            for k = 1:Col_len
                Output(1, (k - 1) * Row + 1:k * Row) = First_mat(Col_intl(k), :);
            end

        case 1% 用于Turbo编码传输信道的d2分支
            Output = zeros(1, Row * Col_len); % 初始化输出矩阵

            % 进行列交织
            for k = 1:Col_len * Row
                temp1 = floor((k - 1) / Row) + 1;
                temp2 = Col_len * mod((k - 1), Row);
                temp3 = Col_intl(temp1) + temp2;
                temp4 = mod(temp3, Row * Col_len) + 1;
                a(1, m) = temp4; % 用于测试的辅助数组
                m = m + 1;
                Output(1, k) = Temp_info(1, temp4);
            end

        case 2% 用于卷积编码传输信道
            First_mat = reshape(Temp_info, Col_len, Row); % 将数据重塑为矩阵
            Output = zeros(1, Row * Col_len); % 初始化输出矩阵

            % 进行列交织
            for k = 1:Col_len
                Output(1, (k - 1) * Row + 1:k * Row) = First_mat(Col_intl(k), :);
            end

    end

end
