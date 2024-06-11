%%---------------------------Student Program---------------------------%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  LabName:             HDB3编译码实验
%  Task:                根据例程HDB3编码后的数据encode_hdb3，进行HDB3反变换,
%                       打印出数据源波形和HDB3解码后数据波形，示波器通道1输出数据源波形，通道2输出HDB3解码后数据波形

% % Task:              1.根据例程产生的HDB3编码数据encode_hdb3，进行HDB3
% %                      反变换，并将变换前的数据和变换后的数据分别用CH1、CH2输
% %                      出用示波器观察信号
% %                    2.绘制编码数据，HDB3译码数据，并将编码数据和HDB3译码
% %                      数据分别输出到CH1、CH2，用示波器观察波形
% % Programming tips:  1.数据源：指根据例程产生的HDB3编码数据作为数据源
% %                    2.HDB3译码：
% %                     2.1步骤1，还原成AMI码。只需要找出所有的V码就可以消除所
% %                        有的V码与B码
% %                        1）特殊情况：序列的第4比特是第一个V码，即原始序列的前
% %                        四位都是0
% %                        2）找出所有V码，消去所有V码与B码
% %                           如果有一个非0比特，与其前面的非0比特极性相同，那
% %                           么它必然是V吗，v码及其前面的三个比特都为0
% %                           即，从序列第五位开始，序列为~1, 0, 0, ~1
% %                           或~1, 0，0, 0, ~1
% %                     2.2步骤2，还原成原码
% %                       去掉符号，若值不等于0则赋为1
% %                    3.过采样：过采样编码数据和译码后的数据，将码元转换为波形
% %                      显示
% %                    4.输出波形
% %                      绘制出过采样后数据源和编码后数据波形图
% %                      示波器CH1通道输出过采样后编码数据波形
% %                      示波器CH2通道输出过采样后HDB3译码后的数据波形
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------Student Program End-----------------------%%

% 1. HDB3译码
% 1.1 步骤1，还原成AMI码。只需要找出所有的V码就可以消除所有的V码与B码
decode_ami = encode_hdb3;

for i = 4:length(decode_ami)

    if encode_hdb3(i) ~= 0 && encode_hdb3(i - 1) == 0 && encode_hdb3(i - 2) == 0 && (encode_hdb3(i - 3) == 0 || encode_hdb3(i) == encode_hdb3(i - 3))
        decode_ami(i - 3:i) = 0;
    end

end

% 1.2 步骤2，还原成原码
decode_hdb3 = decode_ami;
decode_hdb3(decode_hdb3 ~= 0) = 1;

% 2. 过采样
decode_data_s = zeros(1, len * sample_num);

for n = 1:len
    decode_data_s(1, (n - 1) * sample_num + 1:n * sample_num) = decode_hdb3(1, n);
end

% 3. 输出波形
figure
subplot(211)
plot(t, source_data_s); xlabel('时间(s)'); ylabel('幅值(v)');
title('数据源波形'); ylim([-1.2, 1.2]);
subplot(212)
plot(t, decode_data_s); xlabel('时间(s)'); ylabel('幅值(v)');
title('HDB3译码后数据波形'); ylim([-1.2, 1.2]);
