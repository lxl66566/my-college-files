%% 2.双极性数据
data = 2 * randint(1, len) - 1; %通过`2*randint(1,len)-1`将其转换为-1或1的双极性数据
NRZ_data_b = zeros(1, len * sample_num); %双极性非归零

for n = 1:len
    NRZ_data_b(1, (n - 1) * sample_num + 1:n * sample_num) = data(n);
end

RZ_data_b = zeros(1, len * sample_num); %双极性归零

for n = 1:len
    RZ_data_b(1, (n - 1) * sample_num + 1:n * sample_num - sample_num / 2) = data(n);
end
