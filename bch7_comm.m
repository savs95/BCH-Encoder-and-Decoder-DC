%Audio compression using discrete cosine transforms.

%pkg load signal   #To use dct, load this library.
[y,fs,nbits]=wavread('tada.wav');
% take the mono waveform
y1=y(:,1);
%sound(y1,fs)

N=512; %FFT size
L=length(y1); % length of sequence
M=150; %Number samples kept will be 2M+1
start = N/2 + 1-M;
end1 = N/2 + 1+M;

K=ceil(L/N); % Number of blocks to be processed.
numK = K;
y1=[y1; zeros(K*N-L , 1)]; %append zeros to make the vector length a multiple of N

%----------------Audio Compression-------------------%
y1 = reshape(y1 , N , K);
Y2 = dct(y1);
Y3 = Y2(1:(end1-start+1) , :);
transmitvec = Y3(:);
n=0;m=7;
a=transmitvec;
d2b = [ fix(rem(fix(a)*pow2(-(n-1):0),2)), fix(rem( rem(a,1)*pow2(1:m),2))];
d2b = d2b';    
transmitted=bch_encode7(d2b);
received = bsc_apoorv(transmitted,0.001); #Change probability of error here
answer1 = bch_decode7(received);
answer1 = answer1';
d2b = answer1;
b2d = d2b*pow2(n-1:-1:-m).';
P=2*M+1;
zeroA = floor((N-P)/2);
answer= [];
Y4 = reshape(b2d,P,K);
Y5 = [Y4; zeros(zeroA+1,size(Y4,2));zeros(zeroA, size(Y4,2));];
Y5 = idct(Y5);
answer = Y5(:);
sound(answer,fs)
