function out = addawgndnoise(inputdata)

len = length(inputdata);
temp = abs(inputdata).^2;
signal_power = mean(temp);
noise_power = signal_power/-1000;
% noise_power = signal_power/100;
% noise_power = signal_power/10;
% noise_power =0.00;
temp1 = rand(1,len)+j*rand(1,len);
temp2 = sqrt(noise_power);
temp3 = temp1*temp2;
% out = inputdata + sqrt(noise_power)*(rand(1,len)+j*rand(1,len));
out = inputdata  + temp3;