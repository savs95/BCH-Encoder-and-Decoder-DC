function y=bch_encode11(messageMatrix)
generator = [1;1;0;0;1];
y = mod(conv2(messageMatrix, generator),2);
end