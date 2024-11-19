clc;
clear;
close all

tbsize = 57336;    % tbsize  :   number of bits of TB  比特数据长度  1000-10000
module_type = 3;   %        1: QPSK; 2:16QAM; 3:64QAM 调制方式选择
addnoiseflag =1; %1:添加噪声  0：不添加噪声
rbstart = 0; % 资源映射 码元起始电平
rfflag = 0;         %1:虚拟远程  0：虚拟仿真 ，注：虚拟仿真实验不显示此参数

%% 硬件参数

% rfflag=1，虚拟远程时以下参数才显示
antnum =1;      %接收天线数目 1：单天线接收  2:2天线接收
txantnum =1;    %发射天线数目 1：单天线发射 2:2天线发射
recant = 0;     %单天线接收，0：天线0接收 1：天线1接收
txindex = 0;    %单天线发射，0：天线0发射 1：天线1发射

prb_num = 100;  % 分配的prb数 : number of prbs allocated, prb_start+prb_num should less or equal to 100 

Qm = module_type*2;
UL_subframe_num = 2; %  子帧类型 subframe_type; %1:RX; 2:TX; 3:GP
ue_index = 60;
cellid = 0; % cellid 定位

% antnum =1; %接收天线数目 1：单天线接收  2:2天线接收

%% 速率匹配使用参数

Channel_type =0; % Channel_type------0 for turbo coded transport channel, 
                 %                   1 for convolutional coded transport channel.
Nir =0;  % Nir-----Soft buffer size
direction =1; % direction ----- 0 for downlink, 1 for uplink
RVidx =0; % RVidx ----- redundancy version number(0/1/2/3)
Nl =1; % Nl ----- transmission layer 1~1layer 2~2/4layer (1/2)
G=12*12*prb_num*Qm; % G ----- total number of bits available for the transmission of one transport channel
mimo_type = 1; %  multiple-in multiple-out;MIMO 

cfi=1;  % CFI  Control Format Indicator	控制格式指示 
        % : 1~3, for pdsch,not for pusch  用于pdsch，不适用于pusch
        %     Physical Downlink Shared Channel -- 物理下行共享信道
        %     Physical Uplink Shared Channel．PUSCH  上行物理共享信道    
% 
cp_type = 0; % CP_type    : 0:normal cp, 1:ext cp

G = G_cal(1,cp_type,cfi,UL_subframe_num,prb_num,module_type,mimo_type);%计算每个传输块所能发送的全部比特数                          
[C, Cp, Kp, Cm, Km, F]  = cdblk_para_cal(tbsize);
E= E_cal(G,C,module_type,Nl);%计算每个子码块的速率匹配后的输出长数 

%信源产生
info_data = TDLTE_Source_data_gen(1, 1, tbsize, 1, 0);
%dlmwrite('.\data\Source.dat',info_data,'delimiter','\n','precision',1);

% CRC添加
% % crc_data = CRC_attach(info_data,24,0); 
% crc_24 = crc24a(info_data);
% crc_data =[info_data,crc_24];
[ crc_data ] = TDLTE_add_crc(info_data );

%码块分割
[Cp, Kp, Cm, Km, F, cdblkseg_data,C] = TDLTE_Cdblk_seg1(crc_data);
 
% 
coded_data = zeros(3*C,Cp+4);
rm_data = zeros(C,3*Cp+12);

%Turbo编码
coded_data = TDLTE_TurboEncodeFun(C,cdblkseg_data,Cm,Km,Kp,F);

%子块交织和速率匹配
[rm_data,rm_len] = TDLTE_RateMatchingFun(coded_data,Channel_type, Nir, C, Cm,direction, module_type, RVidx, Nl, G,Km,Kp);

%码块级联
ccbc_data = TDLTE_Cdblk_concate1(C,rm_data,rm_len);

%信道交织
interleaver_data = TDLTE_interleaver(ccbc_data,prb_num,Qm);

%加扰
scramble_data = TDLTE_scramblefun(interleaver_data,prb_num,Qm,UL_subframe_num,ue_index,cellid);

%调制
mod_data = TDLTE_modfun(scramble_data,prb_num,module_type);

% figure(101)
% plot(real(mod_data),imag(mod_data),'*');
% title('调制后信号星座图')

%两个时隙导频信号产生
[rs_slot1,rs_local_slot1] = TDLTE_pusch_rs_gen(prb_num,0,0,2*UL_subframe_num,cellid,0,0,0,3);
[rs_slot2,rs_local_slot2] = TDLTE_pusch_rs_gen(prb_num,0,0,2*UL_subframe_num+1,cellid,0,0,0,3);

%资源映射
remapdata = TDLTE_remap(mod_data,rs_slot1,rs_slot2,prb_num,rbstart); % 14个符号

%产生频域数据
fredata = TDLTE_genFredata(remapdata);

%产生天线时域数据
antdata = TDLTE_genantdata(fredata);

% 信道 添加噪声


    pcip = '192.168.1.180';
    xsrpip = '192.168.1.166';

[  addnoisedata ] = TDLTE_channel( rfflag,antdata,recant,txantnum,txindex,addnoiseflag,pcip,xsrpip );


% if (rfflag)
%      addnoisedata = OFDM_RFLoopback_1ant(antdata,recant,txantnum,txindex);
%     
% else
%     if(addnoiseflag==1)
%     addnoisedata = addawgndnoise(antdata);  % 30db信噪比
%     else
%     addnoisedata=antdata;
%     end
% end


% 时域数据FFT变换成频域数据
fftdata = TDLTE_fftantdata(addnoisedata);   

% 解资源映射
freqdata = TDLTE_Deremap(fftdata);

if(2==antnum) % 双天线接收时的信道估计
    freqdataant1 = freqdata;  %将天线0的频域数据直接复制给天线1
    
    %计算天线1的时隙0和时隙1的信道估计值
    [slot0_lschannelant1,slot1_lschannelant1] = TDLTE_lschannel(freqdataant1,prb_num,rbstart,UL_subframe_num,cellid,0,0,0);
end


%信道估计 
[slot0_lschannel,slot1_lschannel] = TDLTE_lschannel(freqdata,prb_num,rbstart,UL_subframe_num,cellid,0,0,0);

if(2==antnum)
    equfredata = TDLTE_equal2ant(freqdata,freqdataant1,slot0_lschannel,slot0_lschannelant1,slot1_lschannel,slot1_lschannelant1,7,prb_num,rbstart,0);
else
    %信道均衡
    equfredata = TDLTE_equal(freqdata,slot0_lschannel,slot1_lschannel,7,prb_num,rbstart,0);   
end

%解调
pusch_bs = TDLTE_de_mod_dsp(equfredata,Qm);
% 
% figure(102)
% plot(real(equfredata),imag(equfredata),'*');
% title('接收端星座图')

%解扰
interleave_data1 = TDLTE_de_scramble(pusch_bs,ue_index,UL_subframe_num,cellid);

%解信道交织
[cdblk_concate_data,cqi_codeout,ri_codeout,ack_codeout] = TDLTE_de_interleave(interleave_data1,module_type,G,0,0,0);

%解码块级联
rm_data = TDLTE_de_cdblk_concate(cdblk_concate_data,C,E);


%解速率匹配
coded_data = TDLTE_de_rateMatch_turbo(rm_data,C,Kp,E);


%解turbo编码
cdblkseg_data = TDLTE_de_turboCode(coded_data,C,Kp);


%传输块CRC校验
[tb_data,crc_flag] = TDLTE_de_CRC(cdblkseg_data,C);


%% 波形显示
figure(101)
plot(real(mod_data),imag(mod_data),'*');
title('调制后信号星座图')

figure(102)
plot(real(equfredata),imag(equfredata),'*');
title('接收端星座图')

figure(103)
plot(info_data )
title('信源')

figure(104)
plot(crc_data)
title('添加crc后数据')

figure(105)
plot(ccbc_data);
title('码块级联 ')
% plot(cdblkseg_data(1,:))
% hold on
% [m,n]=size(cdblkseg_data);
% for i=2:1:m
%     plot(cdblkseg_data(i,:))
% end
% hold off;
% title('码块分割')

figure(106)
plot(interleaver_data,'b')
plot(scramble_data,'g')
title('信道交织 加扰后信号')
legend('信道交织','加扰后信号')
 

figure(107)
plot(antdata,'b')
hold on; 
plot(addnoisedata,'r')
hold off;
title('发射端天线时域数据, 接收端天线数据')

figure(108)
plot(interleave_data1 ,'r');
hold on
plot(cdblk_concate_data,'b')
% plot(scramble_data,'g')
title('解扰，解信道交织')
legend('解扰','解信道交织')
hold off;

figure(109)
plot(tb_data)
title('CRC校验后数据')

error_num=sum(xor(info_data ,tb_data))



