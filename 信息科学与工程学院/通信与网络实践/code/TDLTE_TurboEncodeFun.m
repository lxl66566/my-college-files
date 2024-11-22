function coded_data = TDLTE_TurboEncodeFun(C, cdblksegdata, Cm, Km, Kp, F)
    % 该函数用于对输入的数据块进行Turbo编码。
    %
    % 输入参数:
    % C: 数据块的数量。
    % cdblksegdata: 输入的数据块矩阵，每一行代表一个数据块。
    % Cm: 包含 K+ 长度数据块的数量。
    % Km: K- 长度，即较长的数据块长度。
    % Kp: K+ 长度，即较短的数据块长度。
    % F: 填充长度，用于指示 NULL 填充。
    %
    % 输出参数:
    % coded_data: 编码后的数据矩阵，每一行代表一个编码后的数据块。

    % 初始化编码后的数据矩阵
    % coded_data = zeros(3*C, Cp+4);

    % 对每个数据块进行Turbo编码
    for k = 1:C

        % 确定当前数据块的信息长度
        if (k <= Cm)
            info_len = Km; % K- 长度
        else
            info_len = Kp; % K+ 长度
        end

        % 对当前数据块进行Turbo编码
        coded_data(3 * (k - 1) + 1:3 * k, 1:info_len + 4) = Turbo_encoder1(cdblksegdata(k, :), info_len);

        % 如果是第一个数据块，并且需要填充
        if (k == 1)

            if F > 0
                % 填充 "2" 表示 NULL
                coded_data(1:2, 1:F) = 2 * ones(2, F);
            end

        end

    end

end
