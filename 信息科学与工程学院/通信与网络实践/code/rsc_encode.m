function [output,tail_bits]=rsc_encode(x,data_length)
m=3;
k=4;
g=[1 0 1 1;1 1 0 1];

%data_length=length(x);
total_length=data_length+m;

output=zeros(1,data_length);
tail_bits=zeros(1,6);
state=zeros(1,3);

for i=1:total_length
   if i<=data_length
      temp=rem([x(i) state]*g(1,:)',2);
      output(i)=rem([temp state]*g(2,:)',2);
      state=[temp state(1,1:2)];
   else
      tail_bits(2*(i-data_length)-1)=rem(state*g(1,2:k)',2);
      tail_bits(2*(i-data_length))=rem(state*g(2,2:k)',2);
      state=[0 state(1,1:2)];
   end
end
      
      
 
