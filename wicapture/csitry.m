%parameter
iwave = 2;   L=iwave;
derad = pi/180;      %+*+-  % deg -> rad
radeg = 180/pi;
U=4;
Nsub=30;%subcarrier
fdelta=312.5e3;%delta f
fmiddle=5e9;
c=3e8;%light speed
twpi = 2*pi;
snr = 25;               % input SNR (dB)
lambda = c/fmiddle;              %lambda，f=5GHz

%transmitter
tkelm = 3;               % number of t'line
tdd = 0.026;               % transmitter space
td=0:tdd:(tkelm-1)*tdd;     % transmitter array td
%receiver
rkelm = 3;               % number of r'line
rdd = 0.026;               % r space
rd=0:rdd:(rkelm-1)*rdd;     % r array td

%(x,y)=([xmin,xmax],[ymin,ymax])
%N positions(x,y)
xmax=0.01;xmin=-0.01;xlen=xmax-xmin;
ymax=0.01;ymin=-0.01;ylen=ymax-ymin;
N=20;%6ms间隔
position=zeros(N,2);%N个（x,y）位置信息，
deltan0=zeros(N-1,2);
x0=-0.005;y0=-0.04;
position(1,1)=x0;position(1,2)=y0;
for t=2:N
    position(t,1)=xlen*(t-1)/N+x0;
    position(t,2)=ylen*(t-1)/N+y0;
    deltan0(t-1,:)=position(t,:)-position(t-1,:);
end
tof=zeros(iwave,N,U);%tof
for i=1:iwave
    for t=1:N
        if i==1
            tof(i,t,1)=sqrt((position(t,1)-2.5)^2+(position(t,2)-1.23)^2)/c;
            tof(i,t,2)=sqrt((position(t,1)-2.5)^2+(position(t,2)+1.23)^2)/c;
            tof(i,t,3)=sqrt((position(t,1)+2.5)^2+(position(t,2)+1.23)^2)/c;
            tof(i,t,4)=sqrt((position(t,1)+2.5)^2+(position(t,2)-1.23)^2)/c;
        end
        if i==2
            tof(i,t,1)=sqrt((position(t,1)-2.5)^2+(6-position(t,2)-1.23)^2)/c;
            tof(i,t,2)=sqrt((position(t,1)-2.5)^2+(6-position(t,2)+1.23)^2)/c;
            tof(i,t,3)=sqrt((position(t,1)+2.5)^2+(6-position(t,2)+1.23)^2)/c;
            tof(i,t,4)=sqrt((position(t,1)+2.5)^2+(6-position(t,2)-1.23)^2)/c;
        end
    end
end  
 %5*6room,each Corner(2.5,1.23),reflector in y=1.23
 %L*(Nsub*N)*U attenuation matrix
F0=zeros(L,1,U);
for u=1:U
    A=2*pi*rand(iwave,1);
    F0(1,1,u)=exp(-1i*A(1,:));%L*1,path1
    F0(2,1,u)=1*exp(-1i*A(2,:));%L*1,path2
%     F0(1,1,u)=1;%L*1,path1
%     F0(2,1,u)=1;%L*1,path2
end
% F attenuation M,different P

% Hadd= CSI  
Hadd=zeros(tkelm*rkelm,N*Nsub,U);
D00=zeros(L,L,N,U);D00(1,1,:,:)=1;D00(2,2,:,:)=1;
F00=zeros(L,Nsub,N,U);
for t=1:N
    x=position(t,1);
    y=position(t,2);
    %     x=0;y=0;
    thetat=zeros(1,2,4);
    thetar=zeros(1,2,4);
    
    temp1=0.5*pi-atan((y-1.23)/(x-2.5));
    temp2=0.5*pi-atan((1.23-y)/(x-2.5));
    thetat(:,:,1)=[temp1 temp2];
    
    temp1=0.5*pi+atan((y+1.23)/(2.5-x));
    temp2=0.5*pi+atan((1.23*3-y)/(2.5-x));
    thetat(:,:,2)=[temp1 temp2];
    
    temp1=0.5*pi+atan((y+1.23)/(x+2.5));
    temp2=0.5*pi+atan((1.23*3-y)/(x+2.5));
    thetat(:,:,3)=[temp1 temp2];
    
    temp1=0.5*pi-atan((1.23-y)/(x+2.5));
    temp2=0.5*pi-atan((y-1.23)/(x+2.5));
    thetat(:,:,4)=[temp1 temp2];
    
    thetar=thetat;
    A=zeros(tkelm*rkelm,L,4);%9*L steering vector
    H=zeros(tkelm*rkelm,Nsub,U);
    
    %     Hadd=zeros(tkelm*rkelm,1,4);
    for u=1:U%APj
        for q=1:L%pathq
            tempt=thetat(1,q,u);
            rtheta=[sin(tempt),cos(tempt)];
            if t>1
                D00(q,q,t,u)=D00(q,q,t-1,u)*exp(-2i*pi*(rtheta*deltan0(t-1,:)')/lambda);
            end
            for r=1:rkelm
                tempr=thetar(1,q,u);
                
                A((r-1)*tkelm+1:r*tkelm,q,u)=exp(-1i*twpi*rdd*(r-1)*cos(tempr)/lambda)*exp(-1i*twpi*td'*cos(tempt)/lambda);%3*1
            end
        end
        F00(:,1,t,u)=D00(:,:,t,u)*F0(:,1,u);
        %F different sub
        
        for j=2:Nsub
            for l=1:L
                F00(l,j,t,u)=F00(l,1,t,u)*exp(-1i*2*pi*fdelta*tof(l,t,u)*(j-1));
            end
        end
        
        H(:,:,u)=A(:,:,u)*F00(:,:,t,u);
        Hadd(:,(t-1)*Nsub+1:t*Nsub,u)=H(:,:,u);
%         Hadd(:,t,j)=Hadd(:,t)*exp(-1i*twpi*rand());%add niup
    end
end

% Hadd1=Hadd;
for u=1:U
    Hadd(:,:,u)=awgn(Hadd(:,:,u),snr,'measured');%add noise
%     Hadd1(:,:,u)=awgn(Hadd(:,:,u),snr,'measured');%add noise,
%     for t=1:N
%         %             Hadd1(:,(t-1)*Nsub+1:t*Nsub,u)=Hadd1(:,(t-1)*Nsub+1:t*Nsub,u)*exp(-1i*twpi*rand());%add niup
%     end
end
Hadd1=Hadd;

% plot(100*position(:,1),100*position(:,2),'b');
% xlabel(' x/cm');
% ylabel('y/cm');
% title('blue=real,red=est');
theta3=thetat*radeg;%true
theta3r=thetar*radeg;%true