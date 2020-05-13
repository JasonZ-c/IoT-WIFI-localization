%parameter，packet=1
iwave = 2;   L=iwave;
derad = pi/180;        % deg -> rad
radeg = 180/pi;
U=4;
Nsub=30;%subcarrier
fdelta=4*312.5e3;%delta f
fmiddle=5.31e9;
c=3e8;%light speed
lambda=c/fmiddle;
twpi = 2*pi;
snr = 10;               % input SNR (dB)
%lambda = 0.06;              %lambda，f=5GHz
%receiver
rkelm = 3;               % number of r'line
rdd = lambda/2;               % r space
rd=0:rdd:(rkelm-1)*rdd;     % r array td
tof=[7e-8,16e-8];
theta = [40 20];  %待估计角度为10 30 60
A=exp(-1i*twpi*rd.'*cos(theta*derad)/lambda);%3*2
% S=randn(iwave,n);%2*n
B=2*pi*rand(iwave,1);
S=zeros(iwave,Nsub);
S(:,1)=exp(-1i*B);
for j=1:Nsub
    S(1,j)=S(1,1)*exp(-1i*2*pi*fdelta*tof(1)*(j-1));
    S(2,j)=S(2,1)*exp(-1i*2*pi*fdelta*tof(2)*(j-1));
end
S(2,:)=S(2,:)*1;%2与1能量比
X=A*S;
% X=awgn(X,snr,'measured');