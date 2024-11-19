function coded_data = de_rateMatch_turbo(rm_data,C,Kp,E)
for r = 1:C
     coded_data_len = Kp+4;
     %%解速率匹配   
    coded_data((3*(r-1)+1):3*r,1:coded_data_len) = deCdblk_rateMatch_turbo( rm_data(r,1:E(r)),E(r),coded_data_len, 0, 0, 800000);
     %Turbo译码  coded_data为子码块解速结果
end