function p = crc24a(c)
% 功能：以校验多项式为除数的多项式除。计算24位crc,得到校验二进制校验数组p
% 输入：
%      c：需要进行CRC校验的信息
% 输出：
%      p：进行CRC校验的校验位，由低位到高位排列
%  
%  Author:	zzk
%  Date:		2010-06-20
%  ===========================================================
L = 24;
p = zeros(1,L); % 24 位校验位
lenD = length(c);
G=[1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1]; % 生成多项式，由低位到高位
DataCRC1=[c,zeros(1,L)];
for i= 1:lenD
    if DataCRC1(i)==1
        for j=(1:length(G))
            DataCRC1(i+j-1)=xor(DataCRC1(i+j-1),G(j));
        end
    end
end
for k= 1:L
    p(k)=DataCRC1(lenD+k);
end