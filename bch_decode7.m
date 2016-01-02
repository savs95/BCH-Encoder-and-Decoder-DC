function y=bch_decode7(received)
generator=[1; 0; 0; 0; 1; 0; 1; 1; 1];
numberBlocks = size(received,2);
H1 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1; 1 1 0 0; 0 1 1 0; 0 0 1 1; 1 1 0 1; 1 0 1 0; 0 1 0 1; 1 1 1 0; 0 1 1 1; 1 1 1 1; 1 0 1 1; 1 0 0 1];
% Converts H1 from alpha to alpha^3
H3 = H1(mod(3*(0:14), 15)+1,:);
%finding syndrome
S1 = mod(received'*H1, 2);
S3 = mod(received'*H3, 2);
%finding row number
[~, s1Pow] = ismember(S1,H1,'rows');
[~, s3Pow] = ismember(S3,H1,'rows');
%sigma1 = s1
sigma1 = S1;
sigma2 = [];
%computing sigma2
for i = 1:numberBlocks
    %get the actual powers of s1 and s3
    pows1 = s1Pow(i)-1; pows3 = s3Pow(i)-1;
    s1_mod = 15-pows1;
    s1_temp = mod(3*pows1+s1_mod,15);
    s3_temp = mod(pows3+s1_mod,15);
    if s1Pow(i) ~= 0 && s3Pow(i) ~= 0
        val = mod(H1(s1_temp+1,:)+H1(s3_temp+1,:),2);
        sigma2 = [sigma2;val];
    elseif s1Pow(i) ~= 0
        val = H1(s1_temp+1,:);
        sigma2 = [sigma2;val];
    else
        sigma2=[sigma2;[0 0 0 0]];
    end
end
%finding respective powers of sigma1 and sigma2
[~,sigma1power] = ismember(sigma1,H1,'rows');
[~, sigma2power] = ismember(sigma2,H1,'rows');

%finding solutions now by brute force
for k = 1:numberBlocks
    for j = 1:15
        % Two roots case
        if(sigma1power(k) ~= 0 && sigma2power(k) ~= 0)
            p = sigma1power(k)-1; q = sigma2power(k)-1;
            t1 = mod(p+j-1, 15); t2 = mod(q+2*(j-1), 15);
            val = mod(H1(1,:) + H1(t1+1,:) + H1(t2+1,:), 2);
            % checking and fixing
            if(val == [0 0 0 0])
                pos = mod(15-(j-1), 15)+1;
                received(pos, k) = 1 - received(pos, k);
            end
            % One root case and fixing
        elseif(sigma1power(k) ~= 0)
            received(sigma1power(k), k) = 1 - received(sigma1power(k), k);
            break;
            % Zero root case
        else
            break;
        end
    end
end
y = [];
for k = 1:numberBlocks
    y=[y,deconv(received(:,k),generator)];
end
y = mod(y,2);


end