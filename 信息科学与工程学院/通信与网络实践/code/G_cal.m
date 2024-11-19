%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subframe_type; %1:RX; 2:TX; 3:GP
% rmlength_cal    calculate the total length the REs allocated
% CP_type    : 0:normal cp, 1:ext cp
% CFI        : 1~3, for pdsch,not for pusch 
% subframe_num        : subframe number 0~9
% prb_start  : start position of prbs allocated 1~100
% prb_num       : number of prbs allocated, prb_start+prb_num should less or equal to 100 
% mod_type   : modulation type 1:QPSK;2:16QAM;3:64QAM 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function G = G_cal(subframe_type,CP_type,CFI,subframe_num,prb_num,module_type,mimo_type)

global NSYMBOL_DWPTS; % number of OFDM symbols in DwPTS
global CCH_mimo_type;
global NRBDL;

p_table = zeros(1,100); 
G = 0;
%module_type=3;
Qm = module_type *2;
CCH_mimo_type=1;
NRBDL=100;
switch(subframe_type)
    case 1  % RX subframe  对于基站来说是上行
        if (CP_type == 0)
            G = 12*12*prb_num*Qm;%每个时隙有一个导频符号，故一个上行子帧分给导频的资源有2个符号即2*12个RE
        else
            G = 12*10*prb_num*Qm;               
        end
    case 2  % TX subframe   下行
        if (CP_type == 0) %normal CP
        for i=1:NRBDL          % shq 2010.6.18
                if (CCH_mimo_type == 1)%两天线传输
                   p_table(1,i) = (14 - CFI)*12 - 12; % 2 antenna RS   2天线时每个PRB要减去12个RE（导频）                   
                else                   %单天线
                   p_table(1,i) = (14 - CFI)*12 -8;
                end
                if((mimo_type == 6)||(mimo_type == 7))  %tm7/8 ，有UE专用参考信号
                   p_table(1,i) = p_table(1,i) -12; 
                end      
        end      
        
        if (subframe_num == 0) % sunframe 0 have PBCH and SSS（辅同步信号）子帧0存在PBCH    
           for i=48:53%%%%%PBCH占据的RE个数：常规CP时――它占据一个子帧中的8，9，10，11列，共48个RE
                      %%%%%%%%%%%%%%%%%%%%%扩展CP时――它占据一个子帧的7，8，9，10列，共48个RE
                      %%%%%%%%%%%%%%%%%%%%%常规CP时――SSS占据一个子帧的第6列，共12个RE
                      %%%%%%%%%%%%%%%%%%%%%因为Tx为2时，子帧中的第8列上存在4个参考信号，所以要减去56
                      %%%%%%%%%%%%%%%%%%%%%因为Tx为1时，子帧中的第8列上存在2个参考信号，所以要减去56
               if((mimo_type == 6)||(mimo_type == 7))
                   p_table(1,i) = p_table(1,i) - 56 + 3;
               else
                   p_table(1,i) =  p_table(1,i) - 56;%减去辅同步的1个符号和PBCH的4个符号（5*12=60）其中有一个符号上包括了4个导频(cell_rs)，由于之前减过12个导频了，因此60-4=56
               end            
           end    
        else
           if(subframe_num == 5) % sunframe 5 have SSS  
               for i=48:53
                   p_table(1,i) =  p_table(1,i) - 9;
               end  
           end    
        end       
        else
            disp('Not normal CP type!');
        end
        for i = 1:prb_num
            G = G + p_table(1,i)*Qm;
        end
        
    case 3       %特殊子帧
        if (CP_type == 0) %normal CP
            for i=1:100
                if(NSYMBOL_DWPTS > 11) 
                    p_table(1,i) = (NSYMBOL_DWPTS - CFI)*12 - 12; % 2 antenna RS  
                else
                    if(NSYMBOL_DWPTS > 7) %Dwpts:Gp:Uwpts=10:1:1
                        p_table(1,i) = (NSYMBOL_DWPTS - CFI)*12 - 8; % 2 antenna RS  
                        if(mimo_type == 7)  %tm8 ，有UE专用参考信号  
                            p_table(1,i) = p_table(1,i) -12; 
                        end  
                        if(mimo_type == 6)  %tm7 ，有UE专用参考信号  
                            p_table(1,i) = p_table(1,i) -9; %NSYMBOL_DWPTS=10，有三列UE导频：3*3=9
                        end   
                    else
                        if(NSYMBOL_DWPTS > 4)
                            p_table(1,i) = (NSYMBOL_DWPTS - CFI)*12 - 4; % 2 antenna RS 
                        end
                    end 
                end
            end           
            for i=48:53  %%%%  DwPTS中存在的主同步信号在中间6个PRB中所占RE数目：1*12
               p_table(1,i) =  p_table(1,i) - 12+3;
            end
   
        else
            disp('Not normal CP type!');
        end
        for i = 1:prb_num
            G = G + p_table(1,i)*Qm;
        end  
    otherwise
        disp('Wrong ');
end
