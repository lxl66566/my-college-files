%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tbsize  :   number of bits of TB
%ul_sch_para = struct('init_symbol_num',{},'symbol_num',{},'init_prb_num',{},'prb_num',{},... 
%                     'cqi_length',{},'cqi_offset',{},'ri_length',{},'ri_offset',{},...
%                     'ack_length',{},'ack_offset',{});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function E = E_cal(G,C,module_type,Nl)
Qm = module_type*2;
Gpie = G/(Nl*Qm);
Gama = mod(Gpie,C);
 for r = 1:C
     if (r<C-Gama+1)
         E(r) = Nl*Qm*floor(Gpie/C);
     else
         E(r) = Nl*Qm*ceil(Gpie/C);
     end
 end

