function f = de_scramble(recScrambleBit,ue_index,iSubFrame,cellID)
% 功能：解扰 扰码序列对应比特为0，则不改变软信息量的符号，如果对于比特为1，改变软信息量的符号
% 输入：
%      recScrambleBit：解解调后的软信息，作为解扰的输入
%                 iCW：第iCW个码字
%                RNTI：小区特定加扰参数
%           iSubFrame：子帧号
%              cellID：小区ID
% 输出：       
%                   f：解扰后的软信息
%  ===========================================================
ns = iSubFrame*2;                  % 偶数时隙号
Nc = 1600;                         % 恒定常数




nBit = size(recScrambleBit,2);     %下行传输码字数,每码字比特数
nPN = nBit;                             %PN序列长度等于每码字比特数

% % =========== pseudo-random 序列生成 ================================
% % 生成公式为c(n) = (x1(n+Nc)+x2(n+Nc))mod 2，先求x1和x2

x1 = zeros(1,nPN+Nc);
x2 = zeros(1,nPN+Nc);

x1(1,1:31) = bitget(1,1:31);

% PUSCH 加扰初始化
    if mod(ns,2) == 0                            %每个subframe开始时初始化
        c_init = ue_index*(2^14)+iSubFrame*512+cellID;
        x2(1:31) = bitget(c_init,1:31);
    end


for n = 1:nPN+Nc-31
    x1(1,n+31) = mod((x1(n+3)+x1(n)),2);
    x2(n+31) = mod((x2(n+3)+x2(n+2)+x2(n+1)+x2(n)),2);
end


c = mod((x1(1+Nc:end)+x2(1+Nc:end)),2); %扰码 0 1 序列
%c = -1*(c*2-ones(size(c))); % 将0转为1 1转为-1 通过对应位相乘实现解扰
%f = c.*recScrambleBit;
f = mod((c+recScrambleBit),2);