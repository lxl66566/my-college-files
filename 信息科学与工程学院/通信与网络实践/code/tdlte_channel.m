function [  addnoisedata ] = TDLTE_channel( rfflag,antdata,recant,txantnum,txindex,addnoiseflag,pcip,xsrpip )
%  信道
% 选择虚拟远程 使用真实射频，选择虚拟仿真 可添加30dB信噪比的噪声或不添加噪声

if (rfflag) % 选择 虚拟远程
     addnoisedata = OFDM_RFLoopback_1ant(antdata,recant,txantnum,txindex,pcip,xsrpip);
    
else %选择虚拟仿真
    if(addnoiseflag==1)
    addnoisedata = addawgndnoise(antdata);  % 30db信噪比
    else
    addnoisedata=antdata;
    end
end

end

