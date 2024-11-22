function outequfredata = TDLTE_equal(freqdata, slot0lschannel, slot1lschannel, numsym, rbnum, rbstart, cptype)
    % TDLTE_equal - 进行LTE下行链路频域均�
    %
    % 输入参数:
    %   freqdata - 频域数据矩阵，大小为 (2 * numsym x (12 * rbnum))
    %   slot0lschannel - 时隙0的信道估计矩阵，大小为 (1 x (12 * rbnum))
    %   slot1lschannel - 时隙1的信道估计矩阵，大小为 (1 x (12 * rbnum))
    %   numsym - 每个时隙的符号数
    %   rbnum - 资源块数量
    %   rbstart - 起始资源块索引
    %   cptype - 导频类型：0 - 类型0，1 - 类型1
    %
    % 输出参数:
    %   outequfredata - 均衡后的频域数据矩阵，大小为 ((2 * numsym - 2) x (12 * rbnum))

    % 初始化变量
    start = 1;
    scnum = 12 * rbnum; % 子载波数量
    scstart = 12 * rbstart + 1; % 起始子载波索引

    % 根据导频类型确定导频位置
    if (cptype == 0)
        rs_station = 4; % 类型0的导频位置
    else
        rs_station = 3; % 类型1的导频位置
    end

    jjj = 1; % 辅助变量

    % 处理时隙0的符号
    for (iii = 1:numsym)

        if (iii == rs_station)% 导频符号不处理
            continue;
        end

        tmpfredata = freqdata(iii, scstart:(scstart + scnum - 1)); % 提取当前符号的频域数据

        for (kkk = 1:scnum)
            outdata(kkk) = tmpfredata(kkk) / slot0lschannel(kkk); % 进行频域均�
        end

        outequfredata(jjj, (start:start + scnum - 1)) = outdata(1:scnum); % 存储均衡后的数据
        jjj = jjj + 1; % 更新辅助变量
    end

    % 处理时隙1的符号
    for (iii = numsym + 1:2 * numsym)

        if (iii == (rs_station + numsym))% 导频符号不处理
            continue;
        end

        tmpfredata = freqdata(iii, scstart:(scstart + scnum - 1)); % 提取当前符号的频域数据

        for (kkk = 1:scnum)
            outdata(kkk) = tmpfredata(kkk) / slot1lschannel(kkk); % 进行频域均�
        end

        outequfredata(jjj, (start:start + scnum - 1)) = outdata(1:scnum); % 存储均衡后的数据
        jjj = jjj + 1; % 更新辅助变量
    end

end
