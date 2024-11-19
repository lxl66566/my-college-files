function d_o = F_DeSub_inter_tc( v_i, len , index)

%F_DESUB_INTER_TC Summary of this function goes here
%  Detailed explanation goes here
Permutation=[0,16,8,24,4,20,12,28,2,18,10,26,6,22,14,30,1,17,9,25,5,21,13,29,3,19,11,27,7,23,15,31];
Permutation=Permutation+1;
reverse_P=Permutation;

C_TC_sub=32;
R_TC_sub=floor(len/C_TC_sub)+1;
y_out_len=C_TC_sub*R_TC_sub;
y_array=zeros(1,y_out_len);
N_D=y_out_len-len;

switch index
    case {1,2}
        y_2=reshape(v_i,R_TC_sub,C_TC_sub);
        y_matrix=y_2(:,reverse_P);
        y2=y_matrix';
        y_array=reshape(y2,1,y_out_len);
    case 3
        k=0:C_TC_sub*R_TC_sub-1;
        temp=floor(k/R_TC_sub)+1;
        Pi_k=Permutation(temp);
        Pi_k=Pi_k+C_TC_sub*mod(k,R_TC_sub);
        Pi_k=Pi_k;
        Pi_k=mod(Pi_k,y_out_len)+1;
        y_array(Pi_k)=v_i;
    otherwise
        disp('error using sub_interleaving');
end%end of switch index
d_o=y_array(N_D+1:y_out_len);