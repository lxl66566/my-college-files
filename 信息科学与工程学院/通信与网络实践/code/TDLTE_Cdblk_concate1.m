%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cdblk_concate  Code block concatenation
% C: Code block number
% Info_data: data of each code block, C rows
% data_len: length of each code block, C rows 1 column
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = TDLTE_Cdblk_concate1(C,Info_data,data_len)

k=0;
for i=1:C
    len = data_len(i);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Student code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% task:利用并行码块数据Info_data完成码块级联
% 提示：1、取并行码块数据Info_data的i个码块数据，将其值给output数据的第(k+1:k+len)位置。
%      2、更新k的位置值。
    output(k+1:k+len) = ;
    k =   ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end