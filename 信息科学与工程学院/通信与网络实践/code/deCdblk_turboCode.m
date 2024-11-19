function decodedBit = deCdblk_turboCode(preDecodeBit)
% turbo 解码函数。对输入的三流比特进行尾比特还原，再进行Turbo译码
% 输入：preDecodeBit：译码器输入的软信息
%       SNRdB:信噪比 单位dB
% 输出：decodedBit：解码后的二进制序列
%  ==========================================================
% global LTE_par

% 编码生成器
g = [ 1 0 1 1;
      1 1 0 1 ];
K = size(g,2); 
m = K - 1;

decodeAlg = 2;%LTE_par.UE_par.decodeAlg;       % 解码算法 1：Max-Log-Map算法 2：Log-Map 
niter = 20;%LTE_par.UE_par.niter;               % turbo译码迭代次数

preDecodeBit = preDecodeBit*4 -2;

lenTotal = length(preDecodeBit);            % 变换后信息比特加尾比特长度
lenInfo = lenTotal-4;                       % 信息比特长度
lenTotal = lenTotal-1;                      % turbo输出附加3个尾比特后长度
REC1 = zeros(1,2*lenTotal);                 % 接收端解码器 REC 1输入
REC2 = zeros(1,2*lenTotal);                 % 接收端解码器 REC 2输入

tailBit = preDecodeBit(:,end-K+1:end);
% disp('接收端收到尾比特')
% disp(tailBit)
tailBit([1 4 2 5 3 6 7 10 8 11 9 12]) = tailBit;
tailBit = reshape(tailBit,3,4);
% disp('接收端还原尾比特')
% disp(tailBit)

sysBit = [preDecodeBit(1,1:lenInfo),transpose(tailBit(:,1))];
parityBit = [preDecodeBit(2,1:lenInfo),transpose(tailBit(:,2))];

% 接收端解码器 REC 1输入 系统比特和校验比特交叉放置
REC1(1:2:end) = sysBit;
REC1(2:2:end) = parityBit;

alphaInternal = internal_leaver_par(lenInfo);    % turbo 内交织表
temp = preDecodeBit(alphaInternal);
sysBit = [temp,transpose(tailBit(:,3))];
parityBit = [preDecodeBit(3,1:lenInfo),transpose(tailBit(:,4))];

% 接收端解码器 REC 2输入 系统比特和校验比特交叉放置
REC2(1:2:end) = zeros(size(sysBit));
REC2(2:2:end) = parityBit;

SISO1_APP = zeros(1,lenInfo);

% 迭代译码
for iter = 1:niter
    % 第一个译码器
    SISO1_output = LTE_rx_siso_decode(SISO1_APP,REC1,g,0,decodeAlg);
    % 第二个译码器
    SISO2_APP = SISO1_output-SISO1_APP;
    SISO2_APP = SISO2_APP(alphaInternal);

    SISO2_output = LTE_rx_siso_decode(SISO2_APP,REC2,g,0,decodeAlg);
    SISO1_APP = SISO2_output-SISO2_APP;
    SISO1_APP(alphaInternal) = SISO1_APP;
    
end



decodedBit(alphaInternal) = (sign(SISO2_output)+1)/2;
