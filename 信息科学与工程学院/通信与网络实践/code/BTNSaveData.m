function BTNSaveData(filename,data,varName)

%信源
if  strcmp(varName,'info_data')
	info_data=data;
	save(filename,'info_data');
end

%加CRC
if strcmp(varName,'crc_data')
	crc_data=data;
	save(filename,'crc_data');
end


%码块分段
if strcmp(varName,'cdblkseg_data')
	cdblkseg_data=data;
	save(filename,'cdblkseg_data');
end

%turbo编码
if strcmp(varName,'coded_data')
	coded_data=data;
	save(filename,'coded_data');
end

%速率匹配
if strcmp(varName,'rm_data')
	rm_data=data;
	save(filename,'rm_data');
end

%级联
if strcmp(varName,'ccbc_data')
	ccbc_data=data;
	save(filename,'ccbc_data');
end

%交织
if strcmp(varName,'interleaver_data')
	interleaver_data=data;
	save(filename,'interleaver_data');
end

%加扰数据
if strcmp(varName,'scramble_data')
	scramble_data=data;
	save(filename,'scramble_data');
end


%调制
if strcmp(varName,'mod_data')
	mod_data=data;
	save(filename,'mod_data');
end

%导频1
if strcmp(varName,'rs_slot1')
	rs_slot1=data;
	save(filename,'rs_slot1');
end

%导频2
if strcmp(varName,'rs_slot2')
	rs_slot2=data;
	save(filename,'rs_slot2');
end

%资源映射
if strcmp(varName,'remapdata')
	remapdata=data;
	save(filename,'remapdata');
end

%OFDM
if strcmp(varName,'antdata')
	antdata=data;
	save(filename,'antdata');
end

%RF I
if strcmp(varName,'RF_I')
	RF_I=data;
	save(filename,'RF_I');
end

%RF Q
if strcmp(varName,'RF_Q')
	RF_Q=data;
	save(filename,'RF_Q');
end

%时域转频域
if strcmp(varName,'fftdata')
	fftdata=data;
	save(filename,'fftdata');
end

%解资源映射
if strcmp(varName,'freqdata')
	freqdata=data;
	save(filename,'freqdata');
end

%解调
if strcmp(varName,'pusch_bs')
	pusch_bs=data;
	save(filename,'pusch_bs');
end

%解扰
if strcmp(varName,'interleave_data1')
	interleave_data1=data;
	save(filename,'interleave_data1');
end

%揭交织
if strcmp(varName,'cdblk_concate_data')
	cdblk_concate_data=data;
	save(filename,'cdblk_concate_data');
end

%估计
if strcmp(varName,'equfredata')
	equfredata=data;
	save(filename,'equfredata');
end

%解级联
if strcmp(varName,'rm_data')
	rm_data=data;
	save(filename,'rm_data');
end

%解速率匹配
if strcmp(varName,'coded_data')
	coded_data=data;
	save(filename,'coded_data');
end

%解Turbo
if strcmp(varName,'cdblkseg_data')
	cdblkseg_data=data;
	save(filename,'cdblkseg_data');
end

%解crc
if strcmp(varName,'tb_data')
	tb_data=data;
	save(filename,'tb_data');
else

end
end