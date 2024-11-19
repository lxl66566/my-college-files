function outequfredata = equal(freqdata,slot0lschannel,slot1lschannel,numsym,rbnum,rbstart,cptype)
% 单天线接收时 信道均衡

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
    for(kkk = 1:scnum)
        outdata(kkk) = tmpfredata(kkk)/slot0lschannel(kkk);
    end
    outequfredata(jjj,(start:start+scnum-1)) = outdata(1:scnum);
    jjj = jjj+1;
end
for(iii=numsym+1:2*numsym)  %每个符号分别处理，时隙1的7个符号
    if(iii == (rs_station+numsym))  %导频不处理
        continue;
    end
    tmpfredata = freqdata(iii,scstart:(scstart+scnum-1));
    for(kkk = 1:scnum)
        outdata(kkk) = tmpfredata(kkk)/slot1lschannel(kkk);
    end
    outequfredata(jjj,(start:start+scnum-1)) = outdata(1:scnum);
    jjj = jjj+1;
end


