%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cdblk_concate  Code block concatenation
% C: Code block number
% Info_data: data of each code block, C rows
% data_len: length of each code block, C rows 1 column
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = TDLTE_Cdblk_concate1(C, Info_data, data_len)

    k = 0;

    for i = 1:C
        len = data_len(i);
        output(k + 1:k + len) = Info_data(i, 1:len);
        k = k + len;
    end

end
