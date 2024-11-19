% Turbo_Encoder turbo coding acoording to 3GPP 36212 for LTE only
% 2 subfunction included (rsc_encode interleave)
% 1 stream input 3 stream data output
% tail bits arranged
function poutput=Turbo_encoder1(input,data_length)

%g=[1 0 1 1;1 1 0 1];
%data_length=length(input);
poutput = zeros(3,data_length+4);

[parity1,tail_bits1]=rsc_encode(input,data_length);
alpha=interleave(data_length,input);
[parity2,tail_bits2]=rsc_encode(alpha,data_length);

poutput(1,1:data_length) = input;
poutput(2,1:data_length) = parity1;
poutput(3,1:data_length) = parity2;

poutput(1,data_length+1) = tail_bits1(1,1);
poutput(2,data_length+1) = tail_bits1(1,2);
poutput(3,data_length+1) = tail_bits1(1,3);
poutput(1,data_length+2) = tail_bits1(1,4);
poutput(2,data_length+2) = tail_bits1(1,5);
poutput(3,data_length+2) = tail_bits1(1,6);
poutput(1,data_length+3) = tail_bits2(1,1);
poutput(2,data_length+3) = tail_bits2(1,2);
poutput(3,data_length+3) = tail_bits2(1,3);
poutput(1,data_length+4) = tail_bits2(1,4);
poutput(2,data_length+4) = tail_bits2(1,5);
poutput(3,data_length+4) = tail_bits2(1,6);