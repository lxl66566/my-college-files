function intleaverdata = interleaver(crcdatain,prb_num,Qm)
symb_length = prb_num*12*Qm;
data_length = prb_num*144*Qm;
data_row = data_length/(12*Qm);
count =1;

% puschtmpdata = zeros(data_row,12*Qm);
% 
% for i=1:data_row
%     puschtmpdata(i,:)=crcdatain((i-1)*12*Qm+1:i*12*Qm);
% end
% for i=1:12
%     for n=1:Qm:symb_length
%         intleaverdata(1,(i-1)*symb_length+n:(i-1)*symb_length+n+Qm-1) = puschtmpdata(ceil(n/Qm),(i-1)*Qm+1:i*Qm);
%     end
% end

for i=1:12
    for j=1:data_row
        index = (j-1)*12*Qm+(i-1)*Qm+1;
        intleaverdata(1,count:count+Qm-1)=crcdatain(1,index:index+Qm-1);
        count=count+Qm;
    end
end
