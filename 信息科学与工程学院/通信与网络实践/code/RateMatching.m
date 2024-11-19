% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Info_data-----Information data input to Rate Matching module
%               the input data must have 3 streams.
% Channel_type------0 for turbo coded transport channel, 
%                   1 for convolutional coded transport channel.
% Nir-----Soft buffer size
%----Parameter list below is Only used for turbo coded channel
% C ---- code block number
% direction ----- 0 for downlink, 1 for uplink
% module_type ----- 1 for QPSK, 2 for 16QAM, 3 for 64QAM
% RVidx ----- redundancy version number(0/1/2/3)
% Nl ----- transmission layer 1~1layer 2~2/4layer (1/2)
% G ----- total number of bits available for the transmission of one transport channel
% r ----- rth coded block input to rate matching module(begin with 0 according to 3gpp)
% output: data bit after ratematching
% out_len: data length after ratematching

function [Output,out_len] = RateMatching(Info_data, Channel_type, Nir, C, direction, module_type, RVidx, Nl, G, r)

global OUPUT_FILE; %output file name
global PRINT_FLAG;%0:not print the result;1:output

%%%%%%%%%%%%%%%Subblock interleaving%%%%%%%%%%%%%%%%%%%%
if Channel_type==0 %for turbo code transport channel
    temp1 = Subblock_interleave_index(Info_data(1,:),0);
    temp2 = Subblock_interleave_index(Info_data(2,:),0);
    temp3 = Subblock_interleave_index(Info_data(3,:),1);
else  % for convolutional code transport channel
    temp1 = Subblock_interleave_index(Info_data(1,:),2);
    temp2 = Subblock_interleave_index(Info_data(2,:),2);
    temp3 = Subblock_interleave_index(Info_data(3,:),2);
end    
Kii = length(temp1);
Kw = 3*Kii;

if (PRINT_FLAG ~= 0)
    fid=fopen(OUPUT_FILE,'a');
    fprintf(fid,'\n\n\n Subblock %ld interleave begin: \n',r);
    fprintf(fid,'\n Kii is: %ld, Kw is: %ld\n',Kii,Kw);
    for  j = 1:3 
        if (j == 1)
            fprintf(fid,'\n system bits interleaving out : %ld\n',Kii);
            temp_data = temp1;
        end
        if (j == 2)
            fprintf(fid,'\n\n parity 1 bits interleaving out : %ld\n',Kii);
            temp_data = temp2;
        end
        if (j == 3)
            fprintf(fid,'\n\n parity 2 bits interleaving out : %ld\n',Kii);
            temp_data = temp3;
        end
        for i=1:Kii
            fprintf(fid,'%1d',temp_data(i));
            if mod(i,50) == 0
                fprintf(fid,'  ');
                fprintf(fid,strcat(num2str(i-49), '--', num2str(i)));
                fprintf(fid,'\n');
            end
        end
        fprintf(fid,'\n');
    end
    fclose(fid); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%bit collection%%%%%%%%%%%%%%%%
w = zeros(1,Kw);
w(1,1:Kii) = temp1;
if (Channel_type == 0) %bit collection for Turbo code
    for k = 1:Kii
        w(1,Kii+2*k-1) = temp2(k);
        w(1,Kii+2*k) = temp3(k);
    end
else  %bit collection for convolutional code
    w(1,(Kii+1):(2*Kii)) = temp2;
    w(1,(2*Kii+1):(3*Kii)) = temp3;
end

if (PRINT_FLAG ~= 0)
    fid=fopen(OUPUT_FILE,'a');
    fprintf(fid,'\n\n\n Subblock bit collection : %ld \n',Kw);
    temp_data = w;
    for i=1:Kw
        fprintf(fid,'%1d',temp_data(i));
        if mod(i,50) == 0
            fprintf(fid,'  ');
            fprintf(fid,strcat(num2str(i-49), '--', num2str(i)));
            fprintf(fid,'\n');
        end
    end
    fprintf(fid,'\n');
    fclose(fid);
end
%%%%%%%%%%%%%%%%%%%Rate match%%%%%%%%%%%%%%%%%%%%%%%%%
switch Channel_type
    case 0 % Turbo coded transport channel
        if (direction == 0) %downlink
            Ncb = min([floor(Nir/C), Kw]);
        else                %uplink
            Ncb = Kw;
        end
        Qm = module_type*2;
        Gpie = G/(Nl*Qm);
        Gama = mod(Gpie,C);
        if (r<C-Gama)
            E = Nl*Qm*floor(Gpie/C);
        else
            E = Nl*Qm*ceil(Gpie/C);
        end
        Rsub = Kii/32; % Row number for Turbo code transport channel
        k0 = Rsub*(2*ceil(Ncb/(8*Rsub))*RVidx+2);
        k = 1;
        j = 0;
        while (k<E+1)
            if (w(1,mod(k0+j,Ncb)+1)<2) % bit value > 1 means NULL
                Output(k) = w(1,mod(k0+j,Ncb)+1);
                k = k+1;
            end
            j = j+1;
        end
        
        if (PRINT_FLAG ~= 0)
            fid=fopen(OUPUT_FILE,'a');
            fprintf(fid,'\n\n Rate match para of subblock %ld: ',r);
            fprintf(fid,'\n Ncb :%ld; K0: %ld; total output bits : %ld \n\n',Ncb,k0,E);
            for k=1:E
                fprintf(fid,'%1d',Output(k));
                if mod(k,50) == 0
                    fprintf(fid,'  ');
                    fprintf(fid,strcat(num2str(k-49), '--', num2str(k)));
                    fprintf(fid,'\n');
                end
            end
            fprintf(fid,'\n');
            temp_data = bin2str(Output, 4);
            fprintf(fid, '\n Rate match data in HEX :');
            temp_length = length(temp_data);
            for i=1:temp_length 
                if (mod(i-1,48)==0)
                    fprintf(fid, '\n');
                end
                fprintf(fid, '%s',temp_data(i));
            end
            fclose(fid);
        end
        
    case 1 % Convolutional coded transport channel
        E = Nir;
        k = 1;
        j = 0;
        while (k<E+1)
            if(w(1,mod(j,Kw)+1)<2)
                Output(k) = w(1,mod(j,Kw)+1);
                k = k+1;
            end
            j = j+1;
        end

        if (PRINT_FLAG ~= 0)
            fid=fopen(OUPUT_FILE,'a');
            fprintf(fid,'\n\n Rate match data out:\n');
            for k=1:E
                fprintf(fid,'%1d',Output(k));
                if mod(k,50) == 0
                    fprintf(fid,'  ');
                    fprintf(fid,strcat(num2str(k-49), '--', num2str(k)));
                    fprintf(fid,'\n');
                end
            end

            fprintf(fid,'\n');
            temp_data = bin2str(Output, 4);
            fprintf(fid, '\n Rate match data in HEX :');
            temp_length = length(temp_data);
            for i=1:temp_length 
                if (mod(i-1,12)==0)
                    fprintf(fid, '\n');
                end
                fprintf(fid, '%s',temp_data(i));
            end
            fclose(fid); 
        end
end
out_len = E;
