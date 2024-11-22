% pseudo_random_seq_gen: 该函数用于生成伪随机序列。伪随机序列在通信系统中广泛用于扰码、加扰、信道估计等应用。

function [out] = pseudo_random_seq_gen(init_value, length)
    % pseudo_random_seq_gen - 生成伪随机序列
    %
    % 输入参数:
    %   init_value - 初始值，用于生成伪随机序列的种子
    %   length - 生成的伪随机序列的长度
    %
    % 输出参数:
    %   out - 生成的伪随机序列，大小为 (1 x length)

    % 定义常量
    NC = 1600; % 常量，用于生成伪随机序列
    lenx = NC + length - 31; % 计算生成序列的总长度

    % 初始化x1序列
    x1 = zeros(1, 31);
    x1(1) = 1; % x1序列的初始值

    % 初始化x2序列
    x2 = zeros(1, 31);

    for iii = 1:31
        x2(iii) = mod(init_value, 2); % 从初始值中提取x2序列的初始值
        init_value = floor(init_value / 2); % 更新初始值
    end

    % 生成x1和x2序列
    for iii = 1:lenx
        x1(iii + 31) = xor(x1(iii + 3), x1(iii)); % 更新x1序列
        temp = x2(iii + 3) + x2(iii + 2) + x2(iii + 1) + x2(iii); % 计算x2序列的下一个值
        x2(iii + 31) = mod(temp, 2); % 更新x2序列
    end

    % 生成伪随机序列
    for iii = 1:length
        temp = x1(iii + NC) + x2(iii + NC); % 计算伪随机序列的下一个值
        out(iii) = mod(temp, 2); % 更新伪随机序列
    end

end
