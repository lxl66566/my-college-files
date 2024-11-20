%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tbsize  :   number of bits of TB
%ul_sch_para = struct('init_symbol_num',{},'symbol_num',{},'init_prb_num',{},'prb_num',{},...
    %                     'cqi_length',{},'cqi_offset',{},'ri_length',{},'ri_offset',{},...
    %                     'ack_length',{},'ack_offset',{});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C, Cp, Kp, Cm, Km, F] = cdblk_para_cal(tbsize)

    K = [40 48 56 64 72 80 88 96 104 112 120 128 136 144 152 ...
            160 168 176 184 192 200 208 216 224 232 240 248 256 ...
            264 272 280 288 296 304 312 320 328 336 344 352 360 ...
            368 376 384 392 400 408 416 424 432 440 448 456 464 ...
            472 480 488 496 504 512 528 544 560 576 592 608 624 ...
            640 656 672 688 704 720 736 752 768 784 800 816 832 ...
            848 864 880 896 912 928 944 960 976 992 1008 1024 ...
            1056 1088 1120 1152 1184 1216 1248 1280 1312 1344 ...
            1376 1408 1440 1472 1504 1536 1568 1600 1632 1664 ...
            1696 1728 1760 1792 1824 1856 1888 1920 1952 1984 ...
            2016 2048 2112 2176 2240 2304 2368 2432 2496 2560 ...
            2624 2688 2752 2816 2880 2944 3008 3072 3136 3200 ...
            3264 3328 3392 3456 3520 3584 3648 3712 3776 3840 ...
            3904 3968 4032 4096 4160 4224 4288 4352 4416 4480 ...
            4544 4608 4672 4736 4800 4864 4928 4992 5056 5120 ...
            5184 5248 5312 5376 5440 5504 5568 5632 5696 5760 ...
            5824 5888 5952 6016 6080 6144];

    Z = 6144;
    Info_len = tbsize + 24;

    if (Info_len <= Z)
        L = 0; % CRC add length euqal to 0, No CRC should be add
        C = 1; % only one code block;
        Bt = Info_len; % the length is equal to the input length after code block segment function
    else
        L = 24; %CRC add lenth equal to 24 CRC should be added
        C = ceil(Info_len / (Z - L)); % code block number after code block segment
        Bt = Info_len + C * L; % the total length after code block segment
    end

    i = 1;

    while (K(i) * C < Bt)
        i = i + 1;
    end

    Kp = K(i);

    if (C == 1)% only one block
        Cp = 1;
        Km = 0;
        Cm = 0;
    else % more than one block, should be divided into two kinds of length.
        Km = K(i - 1);
        deltaK = Kp - Km;
        Cm = floor((C * Kp - Bt) / deltaK);
        Cp = C - Cm;
    end

    F = Cp * Kp + Cm * Km - Bt;
end
