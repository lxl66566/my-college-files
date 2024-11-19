%Source_data_gen
% Generate the source data for Processing
% bk_num: data block number
% bk_size: each data block size
% frame_num: data frame number
% data_type: 0 for rand type data; 1 for PN9 type data; 9 for file
%              input data
% file_name: user for data_type 9 only.

function output = TDLTE_Source_data_gen(frame_num, bk_num, bk_size, data_type, file_name)
% 产生随机信号信源
switch data_type
    case 0
        output = ceil(rand(bk_num,bk_size,frame_num)-0.5);
    case 1
        PN9=ones(1,9);
        for i=10:511
           PN9(i)=mod(PN9(i-9)+PN9(i-5),2);
        end
        output = zeros(bk_num, bk_size, frame_num);
        for i=1:frame_num
            for j=1:bk_num
                for k=1:bk_size
                    output(j,k,i)=PN9(1,mod((i-1)*bk_num*(j-1)*bk_size+k-1,511)+1);
                end
            end
        end
    case 9
end
