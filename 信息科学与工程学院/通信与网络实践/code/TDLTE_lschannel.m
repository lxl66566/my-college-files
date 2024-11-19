function [slot0_ls,slot1_ls] = TDLTE_lschannel(fredata,rbnum,rbstart,subframeno,cellid,deltass,ndmrs1,cyc_shift)
  
% 天线接收时的信道估计

printlschannelflag = 1; % 打印信道估计导频母码
    symbol_index_slot0 = 3;  % 每个时隙的符号3为导频,从0开始
    symbol_index_slot1 = 3;
   slotno = subframeno*2;
   [rs_slot1,rs_local_slot1] = TDLTE_pusch_rs_gen(rbnum,0,0,slotno,cellid,deltass,ndmrs1,cyc_shift,symbol_index_slot0);
   [rs_slot2,rs_local_slot2] = TDLTE_pusch_rs_gen(rbnum,0,0,slotno+1,cellid,deltass,ndmrs1,cyc_shift,symbol_index_slot1);
   scnum = 12*rbnum;
   scstart = 12*rbstart+1;
   rs0fredata = fredata(4,scstart:(scstart+scnum-1));
   rs1fredata = fredata(11,scstart:(scstart+scnum-1));
   TestRecRsfredata = rs0fredata;
   TestRsdata = rs_slot1;
   for(iii = 1:scnum)
       slot0_ls(iii) = rs0fredata(iii)/rs_slot1(iii);
       slot1_ls(iii) = rs1fredata(iii)/rs_slot2(iii);
   end
   if(printlschannelflag)
%       name = 'localrsdata.dat';
%       lendata = length(rs_local_slot1);
%         type = 0;
%       printIQ( lendata ,rs_local_slot1 ,name ,type );   %1为定标类型 1：Q14定标 64QAM  0：Q15定标 16QAM 
   end
   
   