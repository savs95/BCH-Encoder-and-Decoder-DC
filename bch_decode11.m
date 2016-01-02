function y=bch_decode11(received)
numberBlocks = size(received,2);
generator = [1;1;0;0;1];
H1 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1; 1 1 0 0; 0 1 1 0; 0 0 1 1; 1 1 0 1; 1 0 1 0; 0 1 0 1; 1 1 1 0;0 1 1 1; 1 1 1 1; 1 0 1 1; 1 0 0 1];
%syndrome vector
syndrome = mod(received'*H1, 2);
%finding location in matrix and that will be equal to error location as by
%peterson's algo A1 = S1. and solution is (1/Beta)
[~, errorLoc] = ismember(syndrome, H1, 'rows');
%errorLoc gives position it matches in H1 matrix
for i = 1:numberBlocks
    if(errorLoc(i) > 0)
		received(errorLoc(i), i) = 1 - received(errorLoc(i), i);
    end
end

decodedMessage = [];
for i = 1:numberBlocks
	decodedMessage = [decodedMessage, mod(deconv(received(:,i), generator),2)];
end	
y=decodedMessage;
end