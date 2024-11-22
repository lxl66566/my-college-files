function out = TDLTE_scramblefun(pusch_coding_bit, vrb_num, qm, subframeno, ue_index, cellid)
    % 该函数用于对输入的PUSCH编码比特进行加扰处理。
    %
    % 输入参数:
    % pusch_coding_bit: 输入的PUSCH编码比特序列，长度为 vrb_num * 12 * 12 * qm。
    % vrb_num: 虚拟资源块（VRB）的数量。
    % qm: 调制阶数，例如 QPSK 对应 qm=2，16QAM 对应 qm=4。
    % subframeno: 子帧编号，范围为 0 到 9。
    % ue_index: UE（用户设备）的索引。
    % cellid: 小区ID。
    %
    % 输出参数:
    % out: 加扰后的比特序列，长度与输入的 pusch_coding_bit 相同。

    % 计算比特序列的长度
    bit_len = vrb_num * 12 * 12 * qm;

    % 初始化加扰序列的初始值 cinit
    cinit = ue_index * (2^14) + subframeno * 512 + cellid;

    % 定义常量 NC
    NC = 1600;

    % 计算加扰序列的总长度
    lenx = NC + bit_len - 31;

    % 初始化 x1 序列，长度为 31，第一个元素为 1
    x1 = zeros(1, 31);
    x1(1) = 1;

    % 初始化 x2 序列，长度为 31，元素为 cinit 的二进制表示
    for (iii = 1:31)
        x2(iii) = mod(cinit, 2);
        cinit = floor(cinit / 2);
    end

    % 生成 x1 和 x2 序列
    for (iii = 1:lenx)
        x1(iii + 31) = xor(x1(iii + 3), x1(iii));
        temp = x2(iii + 3) + x2(iii + 2) + x2(iii + 1) + x2(iii);
        x2(iii + 31) = mod(temp, 2);
    end

    % 生成加扰比特序列
    for (iii = 1:bit_len)
        temp = x1(iii + NC) + x2(iii + NC);
        scrambit(iii) = mod(temp, 2);
    end

    % 对输入的 PUSCH 编码比特进行加扰
    for (kkk = 1:bit_len)
        out(kkk) = double(xor(scrambit(kkk), pusch_coding_bit(kkk)));
    end

end
