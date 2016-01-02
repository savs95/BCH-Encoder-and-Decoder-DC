function y=bsc_apoorv(input,p)
temp=rand(size(input));
%display(temp);
temp=(temp<=p);
%display(temp);
temp=input-temp;
received=(temp ~= 0);
y=received;
end
