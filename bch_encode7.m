%g(X)=x8+ x7+ x6+ x4+1 (15,7), t=2
function y=bch_encode7(messageMatrix)
generator=[1; 0; 0; 0; 1; 0; 1; 1; 1];
y = mod(conv2(messageMatrix, generator),2);
end

