function [crc_data] = TDLTE_add_crc(info_data)
    % 输入参数：info_data - 需要添加CRC校验的信息数据
    % 输出参数：crc_data - 添加了CRC校验码的信息数据

    c = info_data; % 将输入的信息数据赋值给变量 c
    L = 24; % 定义CRC校验码的长度为24位
    p = zeros(1, L); % 初始化一个长度为24的零向量，用于存储校验位
    lenD = length(c); % 获取输入信息数据的长度
    G = [1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1]; % 定义生成多项式，由低位到高位
    DataCRC1 = [c, zeros(1, L)]; % 将信息数据与24个零位拼接，形成新的数据序列

    for i = 1:lenD
        % 遍历信息数据的每一位
        if DataCRC1(i) == 1
            % 如果当前位为1，则进行一次二进制除法
            for j = 1:length(G)
                % 对生成多项式的每一位进行异或运算
                DataCRC1(i + j - 1) = bitxor(DataCRC1(i + j - 1), G(j));
            end

        end

    end

    for k = 1:L
        % 提取计算得到的CRC校验码
        p(k) = DataCRC1(lenD + k);
    end

    crc_24 = p; % 将校验位赋值给crc_24
    crc_data = [info_data, crc_24]; % 将原始信息数据与CRC校验码拼接，形成最终的输出数据
end
