function [tb_data,crc_flag] = de_CRC(decodeout,C)
% decodeout: 解turbo编码后数据
%C:  the number of size  Kp+Km sequence

temp_len = 1;
 for r = 1:C     
     %%子块CRC校验
     if(C>1)
        check_out(1,r) = CRC_check(decodeout(r,:),2);
        %去子块CRC 解码块分割
        sub_cw = decodeout(r,1:(length(decodeout)-24));
        temp_tb_data(1,temp_len:(temp_len + length(sub_cw) - 1)) = sub_cw;
        temp_len = temp_len + length(sub_cw);
     else
         temp_tb_data = decodeout;
     end
 end
 
 %%传输块CRC校验
 crc_flag = CRC_check(temp_tb_data,1);%校验标志符

 %去传输块CRC
 tb_data = temp_tb_data(1,1:(length(temp_tb_data)-24));