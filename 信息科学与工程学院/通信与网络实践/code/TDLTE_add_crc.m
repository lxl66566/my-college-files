function [crc_data] = TDLTE_add_crc(info_data)
    c = info_data;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%student code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 生成CRC，
    % 功能：以校验多项式为除数的多项式除。计算24位crc,得到校验二进制校验数组p
    % 输入：
    %      info_data ：需要进行CRC校验的信息
    % 输出：
    %     crc_data ： 添加 进行CRC校验的校验位（由低位到高位排列 ） 后的数据
    %
    %  Author:	zzk
    %  Date:		2010-06-20
    %  ===========================================================

    L = 24;
    p = zeros(1, L); % 24 位校验位
    lenD = length(c);
    G = [1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1]; % 生成多项式，由低位到高位
    DataCRC1 = [c, zeros(1, L)];

    for i = 1:lenD

        if DataCRC1(i) == 1

            for j = (1:length(G))
                %%%%%%%%%%%%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % task: 数据 与 生成多项式每位数据异或
                DataCRC1(i + j - 1) = bitxor(DataCRC1(i + j - 1), G(j)); % 数据 与 生成多项式每位数据异或

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end

        end

    end

    for k = 1:L
        p(k) = DataCRC1(lenD + k);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    crc_24 = p;

    crc_data = [info_data, crc_24];
end
