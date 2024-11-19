function outdemod = TDLTE_de_mod_dsp(moddata,qm)
d1 = 1/sqrt(10);  %16QAM的归一化因子
d2 = 1/sqrt(42);  %64QAM的归一化因子
[row,colo] = size(moddata);
start =1;
for(jjj =1:row)
    tail =start+colo-1;
    moddatatmp(start:tail) = moddata(jjj,:);
    start = tail+1;
end
realdata = real(moddatatmp);
imagedata = imag(moddatatmp);
len = length(moddatatmp);
switch qm
    case 2    %QPSK 硬解调
        for(iii=1:len)
            if(realdata(iii)>0)
                outdemod(2*(iii-1)+1) = 0;
            else
                outdemod(2*(iii-1)+1) = 1;
            end
            if(imagedata(iii)>0)
                outdemod(2*(iii-1)+2) = 0;
            else
                outdemod(2*(iii-1)+2) = 1;
            end
        end
    case 4   %16QAM 硬解调
        for(iii=1:len)
             tmpdata1 = 2*d1 - abs(realdata(iii)); 
             tmpdata2 = 2*d1 - abs(imagedata(iii));
            if(realdata(iii)>0)
                outdemod(4*(iii-1)+1) = 0;
            else
                outdemod(4*(iii-1)+1) = 1;
            end
            if(imagedata(iii)>0)
                outdemod(4*(iii-1)+2) = 0;
            else
                outdemod(4*(iii-1)+2) = 1;
            end
            if(tmpdata1>0)
                outdemod(4*(iii-1)+3) = 0;
            else
                outdemod(4*(iii-1)+3) = 1;
            end
            if(tmpdata2>0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 参考前面三个码的解调，对第四位码outdemod(4*(iii-1)+4)幅值，完成16QAM解调
               outdemod(4*(iii-1)+4) = 0; % 请补充完整 第四位码的解调 判定
            else
               outdemod(4*(iii-1)+4) = 1; % 请补充完整
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        end
        
    case 6  %64QAM 硬解调
         for(iii=1:len)
             tmpdata1 = 4*d2 - abs(realdata(iii)); 
             tmpdata2 = 4*d2 - abs(imagedata(iii));
             tmpdata3 = 2*d2 -abs(tmpdata1);
             tmpdata4 = 2*d2 -abs(tmpdata2);
            if(realdata(iii)>0)
                outdemod(6*(iii-1)+1) = 0;
            else
                outdemod(6*(iii-1)+1) = 1;
            end
            if(imagedata(iii)>0)
                outdemod(6*(iii-1)+2) = 0;
            else
                outdemod(6*(iii-1)+2) = 1;
            end
            if(tmpdata1>0)
                outdemod(6*(iii-1)+3) = 0;
            else
                outdemod(6*(iii-1)+3) = 1;
            end
            if(tmpdata2>0)
                outdemod(6*(iii-1)+4) = 0;
            else
                outdemod(6*(iii-1)+4) = 1;
            end
            if(tmpdata3>0)
                outdemod(6*(iii-1)+5) = 0;
            else
                outdemod(6*(iii-1)+5) = 1;
            end
            if(tmpdata4>0)
                outdemod(6*(iii-1)+6) = 0;
            else
                outdemod(6*(iii-1)+6) = 1;
            end
        end      
end