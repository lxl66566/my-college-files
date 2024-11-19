function [ulsch_coding,ack_coding,ri_coding,cqi_coding] = de_interleave(data_in,mod_type,G,ack_coded_symbol,ri_coded_symbol,cqi_coded_symbol)
Qm = mod_type*2;
datain_len = length(data_in);
data_row = datain_len/(12*Qm);

ack_ri_rem = [0,1,1,1;0,0,1,1;0,0,0,1;0,0,0,0];
ri_row = fix(ri_coded_symbol/4) + ack_ri_rem(1:4,mod(ri_coded_symbol,4)+1);%有RI的列：1,10,7,4
ack_row = fix(ack_coded_symbol/4) + ack_ri_rem(1:4,mod(ack_coded_symbol,4)+1);%有ACK的列：2,9,8,3
uci_row = ri_row(1);

ack_coding = zeros(1,ack_coded_symbol*Qm);
ri_coding =zeros(1,ri_coded_symbol*Qm);
cqi_coding = zeros(1,1:cqi_coded_symbol*Qm);
temp_data = zeros(data_row,12*Qm);
nn = 1;
%将数据放入行列交织器
for ii = 1:12
    for mm = 1:data_row
        temp_data(mm,((ii-1)*Qm+1):(ii*Qm)) = data_in(1,nn:(nn + Qm - 1));
        nn = nn + Qm;
    end
end
%还原交织数据(无UCI的行)
data_row1 = data_row - uci_row;
for jj = 1:(data_row - uci_row)
    temp_ulsch_coding(1,((jj-1)*12*Qm+1):jj*12*Qm) = temp_data(jj,:);
end


%有ri的行 收集PUSCH数据，如果有CQI的话 就是CQI+PUSCH
k= data_row1*12*Qm;
d = 1;
m = 1;
ri_row_now = ri_row;
for i=(data_row-uci_row+1):data_row
    for j=1:12
         if((j==2)&&(i==(data_row - ri_row_now(1)+1)))
                ri_row_now(1) = ri_row_now(1)-1;
                continue;
         elseif((j==11)&&(i==(data_row - ri_row_now(2)+1)))
                ri_row_now(2) = ri_row_now(2)-1;
                continue;
         elseif((j==8)&&(i==(data_row - ri_row_now(3)+1)))
                ri_row_now(3) = ri_row_now(3)-1;
                continue;
         elseif((j==5)&&(i==(data_row - ri_row_now(4)+1)))
                ri_row_now(4) = ri_row_now(4)-1;
                continue;
         else
             for mmm=1:Qm     
                temp_ulsch_coding(k+1) = temp_data(i,(j-1)*Qm+mmm);
                k = k + 1;
             end
             d=mod(d,12*Qm);
  
         end              
    end
end
%解数据复用
cqi_coding = temp_ulsch_coding(1:cqi_coded_symbol*Qm);
ulsch_coding = temp_ulsch_coding((cqi_coded_symbol*Qm+1):G);

%ACK编码比特提取
mm = 1;
kk = 1;
%四个符号上都有的部分(即符号数能被4整除的部分)
for mm = 1:ack_row(4)
    kk = data_row - mm + 1;
    ack_coding(1,((mm-1)*4*Qm+1):mm*4*Qm) = [temp_data(kk,(2*Qm+1):3*Qm) temp_data(kk,(9*Qm+1):10*Qm) temp_data(kk,(8*Qm+1):9*Qm) temp_data(kk,(3*Qm+1):4*Qm)];
end
%不是四个符号上都有的部分(即符号数被4整除的余数部分)
N = ack_row(4)*4*Qm;
if((ack_row(3)-ack_row(4))>0)
    kk = data_row - ack_row(3)+1;
    ack_coding(1,(N+1):(N+3*Qm)) = [temp_data(kk,(2*Qm+1):3*Qm) temp_data(kk,(10*Qm+1):10*Qm) temp_data(kk,(7*Qm+1):8*Qm)];
elseif((ack_row(2)-ack_row(4))>0)
    kk = data_row - ack_row(2)+1;
    ack_coding(1,(N+1):(N+2*Qm)) = [temp_data(kk,(2*Qm+1):3*Qm) temp_data(kk,(10*Qm+1):10*Qm)];
elseif((ack_row(1)-ack_row(4))>0)
    kk = data_row - ack_row(1)+1;
    ack_coding(1,(N+1):(N+Qm)) = [temp_data(kk,(2*Qm+1):3*Qm)];
end 

%收集RI编码比特
mm = 1;
kk = 1;
%四个符号上都有的部分(即符号数能被4整除的部分)
for mm = 1:ri_row(4)
    kk = data_row - mm + 1;
    ri_coding(1,((mm-1)*4*Qm+1):mm*4*Qm) = [temp_data(kk,(Qm+1):2*Qm) temp_data(kk,(10*Qm+1):11*Qm) temp_data(kk,(7*Qm+1):8*Qm) temp_data(kk,(4*Qm+1):5*Qm)];
end
%不是四个符号上都有的部分(即符号数被4整除的余数部分)
N = ri_row(4)*4*Qm;
if((ri_row(3)-ri_row(4))>0)
    kk = data_row - ri_row(3)+1;
    ri_coding(1,(N+1):(N+3*Qm)) = [temp_data(kk,(Qm+1):2*Qm) temp_data(kk,(10*Qm+1):11*Qm) temp_data(kk,(7*Qm+1):8*Qm)];
elseif((ri_row(2)-ri_row(4))>0)
    kk = data_row - ri_row(2)+1;
    ri_coding(1,(N+1):(N+2*Qm)) = [temp_data(kk,(Qm+1):2*Qm) temp_data(kk,(10*Qm+1):11*Qm)];
elseif((ri_row(1)-ri_row(4))>0)
    kk = data_row - ri_row(1)+1;
    ri_coding(1,(N+1):(N+Qm)) = [temp_data(kk,(Qm+1):2*Qm)];
end 



end









