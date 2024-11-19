%****************************************************************
%For LTE standard 3gpp 36212-830
%Info_Data: Input Information bits                             %
% Attach_Length: CRC Attach bits length (24/16/8 can selected) %
% CRC_type: Only for CRC Attach bits length 24, 0 for type A; 1 for type B %
% Output: Information add CRC attach bits                       %
%****************************************************************

function Output = CRC_attach(Info_Data,Attach_Length,CRC_type)
% Copyright 2001 Yeh Heng
% CRC attachment added (24/16/8 attachment bits can select)
% Info_Data=[0 1 1 1 0 1 0 1 0 1 0 0 0 0 1 0 0 0 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1 0 0 0 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 1 0 0 0 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 1 1 0 1 0 0 1 0 1 0 1 0 0 0 0 1 1 1 1 1 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 1 1 0 0 0 1 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];% 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
error_flag = 1;
if Attach_Length==16
   Gener_Ploy = [1 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 1];
   error_flag = 0;
else
    if Attach_Length==8
        Gener_Ploy = [1 1 0 1 1 0 0 1 1];
        error_flag = 0;
    else
        if (Attach_Length==24)
            if (CRC_type==0)
                Gener_Ploy = [1 1 0 1 1 1 1 1 0 0 1 1 0 0 1 0 0 1 1 0 0 0 0 1 1];
            else
                Gener_Ploy = [1 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1];
            end
            error_flag = 0;
        end
    end
end

if error_flag==1
    error('CRC length is not Supported');
    return;
end

Info_Length=length(Info_Data);
Reg_State=zeros(1,Attach_Length);        %存放CRC校验比特
Output=zeros(1,Info_Length+Attach_Length);
   for k=1:Info_Length
      input=mod((Info_Data(k)+Reg_State(Attach_Length)),2);          
      FeedBack_Data=input*Gener_Ploy(1:Attach_Length);                
      Temp_Array=zeros(1,Attach_Length);                              
      Temp_Array(2:Attach_Length)=Reg_State(1:Attach_Length-1);       
      Reg_State(1,:)=mod(Temp_Array(1,:)+FeedBack_Data,2);            
      Output(1,k)=Info_Data(k);
   end
Output(1,Info_Length+(1:Attach_Length))=fliplr(Reg_State(1,1:Attach_Length));   

      