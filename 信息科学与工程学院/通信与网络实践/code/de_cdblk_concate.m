function [rm_data] = de_cdblk_concate(input_data,C,E)
rm_data = zeros(C,E(C));
temp = 1;
for r = 1:C
    rm_data(r,1:E(r))= input_data(temp:(temp + E(r) - 1));
    temp = temp + E(r);
end