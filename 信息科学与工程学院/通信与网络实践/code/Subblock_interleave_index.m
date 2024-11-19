%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subblock_interleave subfunction of RateMatch according 3gpp 36212
% Info_data: the input data for subblock interleave
% intl_mode: 0 for turbo coded transport channel d0 and d1 branch
%            1 for turbo coded transport channel d2 branch
%            2 for convolutional coded tansport channel
% Note: input data must be 1 stream.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Output = Subblock_interleave_index(Info_data, intl_mode)
if (intl_mode  == 0)||(intl_mode == 1)
    Col_intl = [0, 16, 8, 24, 4, 20, 12, 28, 2, 18, 10, 26, 6, 22, 14, 30, 1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, 27, 7, 23, 15, 31];
    Col_intl = Col_intl + 1;
else
    Col_intl = [1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, 27, 7, 23, 15, 31, 0, 16, 8, 24, 4, 20, 12, 28, 2, 18, 10, 26, 6, 22, 14, 30];
    Col_intl = Col_intl + 1;
end    
        
Col_len = 32;
len_info = length(Info_data);
Row = ceil(len_info/Col_len);      
F = Row*Col_len - len_info;
Temp_info = ones(1,Row*Col_len)*2;
        
Temp_info(1,F+1:Row*Col_len) = Info_data;

a=zeros(1,length(Temp_info));%%TEST
m=1;

switch intl_mode
    case 0  % for Turbo coded transport channel d0 and d1 branch
        First_mat = reshape(Temp_info, Col_len, Row);
        Output = zeros(1,Row*Col_len);
        for k=1:Col_len
            Output(1,(k-1)*Row+1:k*Row) = First_mat(Col_intl(k),:);
        end
        
    case 1 %for Turbo coded transport channel d2 branch
        Output = zeros(1,Row*Col_len);
        for k=1:Col_len*Row
            temp1 = floor((k-1)/Row)+1;
            temp2 = Col_len*mod((k-1),Row);
            temp3 = Col_intl(temp1)+temp2;
            temp4 = mod(temp3,Row*Col_len)+1;
            a(1,m) = temp4;
            m = m+1;
            Output(1,k) = Temp_info(1,temp4);
        end
        
    case 2 % for Convolutional coded transport channel
        First_mat = reshape(Temp_info, Col_len, Row);
        Output = zeros(1,Row*Col_len);
        for k=1:Col_len
            Output(1,(k-1)*Row+1:k*Row) = First_mat(Col_intl(k),:);
        end
end
end


        
        