%
%function outbit= F_CRC(inbit,CRCNo,blocklen,len,mod_24)
%
%this function accomplishes the CRC attachment in the required channel
%
%inbit is the input bits
%
%blocklen is the length of every block needs a CRC attachment
%
%len is the total length of input data
%
%mod_24 is the mode of CRC Generator, 1 for G_CRC24A and 2 for G_CRC24B
%
function out= CRC_check(inbit,CRC_type)
Generator=zeros(1,25);
tempCRC=zeros(1,24); %bits in register
	
Sfttemp=0;
Intemp=0; %input bit in this moment
pre=0;
temppre=0;

% if(mod(len,blocklen)~=0)
%       disp('error,input length must be multiple of blocklength');
% end
% blocknum=len/blocklen;


switch CRC_type          %define the CRC generator
    case 1          %CRC24a
                    %g(D)=D^24+D^23++D^18+D^17+D^14+D^11+D^10+D^7+D^6+D^5++D^4+D^3+D^1+1;
                    CRCNo = 24;
                    Generator=[1,1,0,1,1,1,1,1,0,0,1,1,0,0,1,0,0,1,1,0,0,0,0,1,1];
    case 2          %CRC24b
                    %g(D)=D^24+D^23+D^6+D^5+D^1+1;
                    CRCNo = 24;
                    Generator=[1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1];
			
	case 3         %CRC16
            CRCNo = 16;
			Generator(17)=1;          %g(D)=D^16+D^12+D^5+1;
			Generator(13)=1;
			Generator(6)=1;
			Generator(1)=1;
    case 4
             disp('CRC generator type is worng' );
end

    	
blocklen = length(inbit);
	tempCRC=zeros(1,24);
%     tempbit(1+i*(blocklen+24):i*(blocklen+CRCNo)+blocklen)=inbit(1+i*blocklen:(i+1)*blocklen);%前几位为系统比特；
    
    for j=1:blocklen   
		Intemp=inbit(j);
		pre=tempCRC(1:23);
		Sfttemp=mod((Intemp+tempCRC(CRCNo)),2); %将最高位与信息位做模2加之后写入最低位，并作模2加的信号与各个位相加；
		tempCRC(1)=Sfttemp;
        tempCRC(2:24)=mod(pre+Sfttemp*Generator(2:24),2);
    end   
	if (tempCRC == (zeros(1,CRCNo)))
        out = 1;%crc校验正确
    else
        out = 0;
    end

