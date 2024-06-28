%%---------------------------Student Program2-----------------------------%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%较难%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  LabName:           DPSK调制解调实验
% %  Task:              1.生成长度为10的信源bit[1,0,0,1,1,0,0,1,1,0]，载波频
% %                      率1228800，进行DPSK调制，加入信噪比为10dB的噪声并使用
% %                      差分相干解调法解调
% %                     2.统计误码数,绘制调制解调过程的波形，将基带信号和已调
% %                         信号分别输出到示波器
% %  Programming tips:  1.解调：
% %                       1.1带通滤波：滤除除已调信号外的噪声信号
% %                       1.2延迟：将带通滤波器后信号向后延迟 TB
% %                          延迟后信号第一个TB内的值用0代替，去掉带通滤波后
% %                          信号最后一个TB内的值
% %                       1.3相乘器：带通滤波器后信号与延迟后信号相乘
% %                       1.4低通滤波：取出低频分量，得到解调信号
% %                       1.5抽样判决：将低通滤波后的值与0比较，小于则判为1，
% %                           否则判为0（进行取反操作）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------Student Program2 End-------------------------%%

% main

[dpsk_bp, dpsk_delay, dpsk_sin, dpsk_sin_lp, choupan] = DPSK_Demodulation(dpsk, Fc, sample_num, Rb, fs);

% 图例自己改！

% DPSK_Demodulation.m

function [dpsk_bp, dpsk_delay, dpsk_sin, dpsk_sin_lp, choupan] = DPSK_Demodulation(dpsk, Fc, sample_num, Rb, fs)
    len = length(dpsk) / sample_num; %码元长度
    dpsk_bp = DPSK_cheby_filter(dpsk, Fc, fs, Rb); %带通滤波
    %添加一个 Ts 的延迟器
    dpsk_delay = [zeros(1, sample_num) dpsk_bp];
    dpsk_delay = dpsk_delay(1:end - sample_num);
    dpsk_sin = dpsk_bp .* dpsk_delay; %乘法器
    %% 低通滤波
    dpsk_sin_lp = DPSK_lowpass(dpsk_sin, fs, Rb); %低通滤波
    %% 抽样判决
    choupan1 = DPSK_sample_judge(dpsk_sin_lp, sample_num); %抽样判决

    for i = 1:len%样点序号
        choupan((i - 1) * sample_num + 1:i * sample_num) = choupan1(i); %将码元序列转化成波形
    end

end

% DPSK_sample_judge.m
% 抽样判决反过来，>0 改 <0
