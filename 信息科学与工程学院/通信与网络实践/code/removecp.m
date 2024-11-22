% removecp: 该函数用于移除OFDM符号中的循环前缀（CP）。循环前缀是OFDM系统中用于对抗多径效应的前缀部分，但在接收端需要移除以恢复原始数据。
function output = removecp(input)
    % removecp - 移除OFDM符号中的循环前缀（CP）
    %
    % 输入参数:
    %   input - 包含循环前缀的输入信号，大小为 (1 x (2048 * 14 + 160 + 144 * 13))
    %
    % 输出参数:
    %   output - 移除循环前缀后的信号，大小为 (1 x 2048 * 14)

    symnum = 14; % 一个子帧为14个符号

    start = 1; % 初始化起始位置
    output = zeros(1, 2048 * 14); % 初始化输出信号

    for ii = 1:symnum
        % 根据符号位置确定循环前缀的长度
        if ((1 == ii) || (8 == ii))% 第1和第8个符号的CP长度为160
            start = start + 160; % 跳过160个循环前缀样本
            tail = start + 2048 - 1; % 计算有效符号的结束位置
            output(1, (ii - 1) * 2048 + 1:ii * 2048) = input(start:tail); % 提取有效符号并存储到输出中
            start = tail + 1; % 更新起始位置
        else % 其他符号的CP长度为144
            start = start + 144; % 跳过144个循环前缀样本
            tail = start + 2048 - 1; % 计算有效符号的结束位置
            output(1, (ii - 1) * 2048 + 1:ii * 2048) = input(start:tail); % 提取有效符号并存储到输出中
            start = tail + 1; % 更新起始位置
        end

    end

end
