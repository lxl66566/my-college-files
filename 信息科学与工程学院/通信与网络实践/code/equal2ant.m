function outequfredata = equal2ant(freqdata,freqdataant1,slot0lschannel,slot0lschannelant1,slot1lschannel,slot1lschannelant1,numsym,rbnum,rbstart,cptype)
% 双天线接收时 信道均衡
start =1;
scnum = 12*rbnum;
scstart = 12*rbstart+1;
if(cptype == 0)
    rs_station = 4;
else
    rs_station = 3;
end
jjj = 1;
for(iii=1:numsym)  %每个符号分别处理,时隙0的7个符号
    if(iii == rs_station)  %导频不处理
        continue;
    end
    tmpfredata = freqdata(iii,scstart:(scstart+scnum-1));
    tmpfredata1 = freqdataant1(iii,scstart:(scstart+scnum-1));
    for(kkk = 1:scnum)
%         outdata(kkk) = tmpfredata(kkk)/slot0lschannel(kkk);
%        temp1 =  tmpfredata(kkk)*conj(slot0lschannel(kkk))+ tmpfredata1*conj(slot0lschannelant1(kkk));
%        temp2 =  slot0lschannel(kkk)*conj(slot0lschannel(kkk))+slot0lschannelant1(kkk)*conj(slot0lschannelant1(kkk));
%        temp = temp1/temp2;
%        outdata(kkk) = temp1(kkk)/temp2(kkk);
       outdata(kkk) = (tmpfredata(kkk)*conj(slot0lschannel(kkk))+ tmpfredata1(kkk)*conj(slot0lschannelant1(kkk)))/(slot0lschannel(kkk)*conj(slot0lschannel(kkk))+slot0lschannelant1(kkk)*conj(slot0lschannelant1(kkk)));
    end
    outequfredata(jjj,(start:start+scnum-1)) = outdata(1:scnum);
    jjj = jjj+1;
end
for(iii=numsym+1:2*numsym)  %每个符号分别处理，时隙1的7个符号
    if(iii == (rs_station+numsym))  %导频不处理
        continue;
    end
    tmpfredata = freqdata(iii,scstart:(scstart+scnum-1));
    tmpfredata1 = freqdataant1(iii,scstart:(scstart+scnum-1));
    for(kkk = 1:scnum)
%         outdata(kkk) = tmpfredata(kkk)/slot1lschannel(kkk);
%         temp1(kkk) =  tmpfredata(kkk)*conj(slot1lschannel(kkk))+ tmpfredata1*conj(slot1lschannelant1(kkk));
%         temp2(kkk) = slot1lschannel(kkk)*conj(slot1lschannel(kkk))+slot1lschannelant1(kkk)*conj(slot1lschannelant1(kkk));
%         outdata(kkk) = temp1(kkk)/temp2(kkk);
     outdata(kkk) = (tmpfredata(kkk)*conj(slot1lschannel(kkk))+ tmpfredata1(kkk)*conj(slot1lschannelant1(kkk)))/(slot1lschannel(kkk)*conj(slot1lschannel(kkk))+slot1lschannelant1(kkk)*conj(slot1lschannelant1(kkk)));
    end
    outequfredata(jjj,(start:start+scnum-1)) = outdata(1:scnum);
    jjj = jjj+1;
end