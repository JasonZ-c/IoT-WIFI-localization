U=4;L=2;N=20;M=20;%PARAMETER
%delta
D = zeros(L,L,U,N-1); %存放target’s displacement
% aodest111=aodest*pi/180;
% deltan=zeros(2,1,N);
% positionest=zeros(2,N);positionest(1,1)=x0;positionest(2,1)=y0;
for index=1:N-1%N-1
%     times=int32(index/M)+1;
%     R=Rall(:,:,times);
    for u=1:U%凸优化用F1,F2求D
        
        %Obtain change in complex attenuation between pth and (p + 1)th packets by solving 10
        F1=Fnew(:,(index-1)*Nsub+1:index*Nsub,u);
        F2=Fnew(:,index*Nsub+1:(index+1)*Nsub,u);
        
        cvx_begin
        variable x(L,L)  complex diagonal
        minimize( norm( x*F1 -F2, 2 ) )	%目标函数
        cvx_end
        
        D(:,:,u,index)=x;
        disp("循环求出D");
    end
end