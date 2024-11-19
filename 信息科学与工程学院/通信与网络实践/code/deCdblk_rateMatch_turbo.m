%
%function data_o = F_DeRateMatch_tc( d_i,len, rv_idx, Link_type, N_IR, C, punch_pos,LTE_NULL )
%
%created by YangWei in 2008-4-3
%
%len represents the length of data before Rate Matching (or the length of
%data after DeRateMatching, it is the length of data input into Turbo Coding  );
%
%
function data_o = deCdblk_rateMatch_turbo( d_i,E,coded_data_len, rv_idx, Link_type, N_IR)
%F_DERATEMATCH_TC Summary of this function goes here
%  Detailed explanation goes here

C_TC_sub = 32;%constant
R_TC_sub = floor(coded_data_len/C_TC_sub)+1;
K_pi = C_TC_sub*R_TC_sub;
F = K_pi - coded_data_len;
K_w = 3*K_pi;

col_index = [0, 16, 8, 24, 4, 20, 12, 28, 2, 18, 10, 26, 6, 22, 14, 30, 1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, 27, 7, 23, 15, 31];
col = col_index + 1;
col1 = col + 1;
col1(1,32) = 1;

switch Link_type
    case 0          %uplink
        N_cb=K_w;   
    case 1          %downlink
        N_IR = C*K_w;         % Modified here on May 7 2008
        N_cb=min(floor(N_IR/C),K_w);
    otherwise
        disp('Link type error!');
end
k0=R_TC_sub*( 2*(floor(N_cb/8/R_TC_sub)+1)*rv_idx+2);
%1.生成虚拟环形buffer
LTE_NULL = 0.11111;
temp_y(1,1:F) = LTE_NULL;
temp_y(1,(F+1):K_pi) = rand(1,coded_data_len);

temp_y1 = reshape(temp_y,C_TC_sub,R_TC_sub);
   %行列置换
for ii = 1:32
    temp_v1(1,((ii-1)*R_TC_sub+1):ii*R_TC_sub) = temp_y1(col(ii),:);
end

for ii = 1:31
    temp_v3(1,((ii-1)*R_TC_sub+1):ii*R_TC_sub) = temp_y1(col1(ii),:);
end
temp_v3(1,(31*R_TC_sub+1):32*R_TC_sub) = [temp_y1(1,2:R_TC_sub) temp_y1(1,1)];%最后一行不同处理

temp_w = zeros(1,K_w);
temp_w(1,1:K_pi) = temp_v1;
for k = 1:K_pi
    temp_w(1,K_pi+2*k-1) = temp_v1(k);
    temp_w(1,K_pi+2*k) = temp_v3(k);
end
   %计算填充比特位置

null_pos = zeros(1,3*F);
null_pos = find(temp_w==LTE_NULL);

%%2.比特重排和填充

%De puncture
 w_o(1:K_w)=LTE_NULL;
% for jj = 1:3*F
%     w_o(1,null_pos(jj)) = LTE_NULL;
% end

unpun_pos=setdiff(1:K_w,null_pos);%非填充比特位置

E_pos=[unpun_pos(find(unpun_pos>k0)),unpun_pos(find(unpun_pos<=k0))];
if (K_w<E)
    temp_len = length(E_pos);
    w_o(E_pos(1:temp_len))=d_i(1:temp_len);
else
    temp_len = E;
    w_o(E_pos(1:temp_len))=d_i(1:temp_len);
%     w_o(E_pos(E+1:length(E_pos)))= randi([0,1],1,length(E_pos)-E);
    w_o(E_pos(E+1:length(E_pos)))=0.5;

end



% if N_cb<K_w
%     w_o(N_cb+1:K_w)=LTE_NULL; %make up the bits that are discarded.
% end
v1=w_o(1:K_pi);
v2=w_o(K_pi+1:2:K_w);
v3=w_o(K_pi+2:2:K_w);

d1=F_DeSub_inter_tc(v1,coded_data_len,1);
d2=F_DeSub_inter_tc(v2,coded_data_len,2);
d3=F_DeSub_inter_tc(v3,coded_data_len,3);

data_o(1,:) = d1;
data_o(2,:) = d2;
data_o(3,:) = d3;
