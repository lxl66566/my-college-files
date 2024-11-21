function out = TDLTE_modfun(inputdata, prbnum, modutype)
    % TDLTE_modfun 函数用于根据输入数据、PRB数量和调制类型进行调制
    % 输入参数：
    %   inputdata - 输入的二进制数据
    %   prbnum - PRB（物理资源块）数量
    %   modutype - 调制类型（1: QPSK, 2: 16QAM, 3: 64QAM）
    % 输出参数：
    %   out - 调制后的复数符号

    % 初始化调制表
    temp = 1 / (2^0.5);
    QPSK_table = temp * [(1 + 1i), (1 - 1i), (-1 + 1i), (-1 - 1i)]; % QPSK调制表
    temp = 1 / (10^0.5);
    QAM16_table = temp * [(1 + 1i), (1 + 3j), (3 + 1i), (3 + 3j), (1 - 1i), (1 - 3j), (3 - 1i), (3 - 3j), ...
                        (-1 + 1i), (-1 + 3j), (-3 + 1i), (-3 + 3j), (-1 - 1i), (-1 - 3j), (-3 - 1i), (-3 - 3j)]; % 16QAM调制表
    temp = 1 / (42^0.5);
    QAM64_table = temp * [(3 + 3j), (3 + 1i), (1 + 3j), (1 + 1i), (3 + 5j), (3 + 7j), (1 + 5j), (1 + 7j), ...
                        (5 + 3j), (5 + 1i), (7 + 3j), (7 + 1i), (5 + 5j), (5 + 7j), (7 + 5j), (7 + 7j), ...
                        (3 - 3j), (3 - 1i), (1 - 3j), (1 - 1i), (3 - 5j), (3 - 7j), (1 - 5j), (1 - 7j), ...
                        (5 - 3j), (5 - 1i), (7 - 3j), (7 - 1i), (5 - 5j), (5 - 7j), (7 - 5j), (7 - 7j), ...
                        (-3 + 3j), (-3 + 1i), (-1 + 3j), (-1 + 1i), (-3 + 5j), (-3 + 7j), (-1 + 5j), (-1 + 7j), ...
                        (-5 + 3j), (-5 + 1i), (-7 + 3j), (-7 + 1i), (-5 + 5j), (-5 + 7j), (-7 + 5j), (-7 + 7j), ...
                        (-3 - 3j), (-3 - 1i), (-1 - 3j), (-1 - 1i), (-3 - 5j), (-3 - 7j), (-1 - 5j), (-1 - 7j), ...
                        (-5 - 3j), (-5 - 1i), (-7 - 3j), (-7 - 1i), (-5 - 5j), (-5 - 7j), (-7 - 5j), (-7 - 7j)]; % 64QAM调制表

    % 计算符号长度
    symbol_len = 12 * 12 * prbnum;

    % 根据调制类型进行调制
    if (modutype == 1)% QPSK

        for (kkk = 1:symbol_len)
            temp = inputdata(2 * kkk - 1) * 2 + inputdata(2 * kkk) + 1; % 计算索引
            out(kkk) = QPSK_table(temp); % 根据索引获取QPSK符号
        end

    elseif (modutype == 2)% 16QAM

        for (kkk = 1:symbol_len)
            temp = inputdata(4 * kkk - 3) * 8 + inputdata(4 * kkk - 2) * 4 + inputdata(4 * kkk - 1) * 2 + inputdata(4 * kkk) + 1; % 计算索引
            out(kkk) = QAM16_table(temp); % 根据索引获取16QAM符号
        end

    else % 64QAM

        for (kkk = 1:symbol_len)
            temp = inputdata(6 * kkk - 5) * 32 + inputdata(6 * kkk - 4) * 16 + inputdata(6 * kkk - 3) * 8 ...
                + inputdata(6 * kkk - 2) * 4 + inputdata(6 * kkk - 1) * 2 + inputdata(6 * kkk) + 1; % 计算索引
            out(kkk) = QAM64_table(temp); % 根据索引获取64QAM符号
        end

    end

end
