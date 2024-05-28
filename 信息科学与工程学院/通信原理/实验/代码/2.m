function outData = PCM_13Decode(inputData)
    n = length(inputData);
    outData = zeros(1, n / 8);
    MM = zeros(1, 8);
    q_values = [1, 1, 2, 4, 8, 16, 32, 64]; % 映射数组
    a_values = [0, 16, 32, 64, 128, 256, 512, 1024];

    for kk = 1:n / 8
        MM(1:8) = inputData(1, (kk - 1) * 8 + 1:kk * 8); % 取得8位PCM码
        temp = MM(2) * 2^2 + MM(3) * 2 + MM(4); % 将8位PCM码的第2~4位二进制数转化为10进制（三位二进制转十进制）
        %用于判断抽样值在哪个段落内
        q = q_values(temp + 1);
        a = a_values(temp + 1);
        A = MM(5) * 2^3 + MM(6) * 2^2 + MM(7) * 2 + MM(8); % 8位PCM码的第5~8位二进制数转化为10进制
        R = (a + A * q + q / 2) / 2048; %取量化间隔中点值进行译码

        if MM(1) == 0%判断极性
            R=-R;
        end

        outData(1, kk) = R; %译码后数据
    end

end

decodedData = PCM_13Decode(a13_moddata);

figure
plot(decodedData);
title('译码还原后的语音波形图');

writeData = [decodedData; decodedData]';

audiowrite('decoded.wav', writeData, sampleVal);
