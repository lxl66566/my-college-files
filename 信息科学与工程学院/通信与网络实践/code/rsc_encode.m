% rsc_encode: 该函数用于对输入数据进行递归系统卷积编码（RSC）。RSC编码是一种常用的前向纠错编码（信道编码）技术，广泛应用于通信系统中。
function [output, tail_bits] = rsc_encode(x, data_length)
    % rsc_encode - 递归系统卷积编码（RSC）
    %
    % 输入参数:
    %   x - 输入数据向量，大小为 (1 x data_length)
    %   data_length - 输入数据的长度
    %
    % 输出参数:
    %   output - 编码后的数据向量，大小为 (1 x data_length)
    %   tail_bits - 尾比特向量，大小为 (1 x 6)

    m = 3; % 记忆长度
    k = 4; % 生成多项式的长度
    g = [1 0 1 1; 1 1 0 1]; % 生成多项式矩阵

    % 计算总长度（包括尾比特）
    total_length = data_length + m;

    % 初始化输出向量和尾比特向量
    output = zeros(1, data_length);
    tail_bits = zeros(1, 6);

    % 初始化状态寄存器
    state = zeros(1, 3);

    % 遍历每个输入比特
    for i = 1:total_length

        if i <= data_length
            % 计算当前输出比特
            temp = rem([x(i) state] * g(1, :)', 2); % 计算第一个生成多项式的输出
            output(i) = rem([temp state] * g(2, :)', 2); % 计算第二个生成多项式的输出
            state = [temp state(1, 1:2)]; % 更新状态寄存器
        else
            % 计算尾比特
            tail_bits(2 * (i - data_length) - 1) = rem(state * g(1, 2:k)', 2); % 计算第一个生成多项式的尾比特
            tail_bits(2 * (i - data_length)) = rem(state * g(2, 2:k)', 2); % 计算第二个生成多项式的尾比特
            state = [0 state(1, 1:2)]; % 更新状态寄存器
        end

    end

end

% 该函数假设输入数据的格式和长度是固定的，且生成多项式矩阵 g 是预定义的。

% 尾比特用于确保编码器在编码结束时回到零状态，以避免状态寄存器中的残留信息影响后续编码。
