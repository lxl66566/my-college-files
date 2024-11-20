function out = TDLTE_genantdata(inputdata)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%student code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 产生天线时域数据

    nfft = 2048;
    nulsym = 7;
    start = 1;
    half = 600;
    total = 1200;
    out = zeros(1, 28672);

    for (iii = 1:2 * nulsym)
        %端口0，符号iii
        %     tmpdata=[inputdata(iii,(half+1):total),zeros(1,(nfft-total)),inputdata(iii,1:half)];
        tmpdata = inputdata(iii, :);
        ifftdata = ifft(tmpdata, 2048);
        tail = start + nfft - 1;
        out([start:tail]) = ifftdata([1:nfft]);
        start = tail + 1;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
