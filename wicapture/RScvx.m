% U=4;L=2;N=3;
% N=14;
twpi=2*pi;
% theta33=theta3*derad;
theta33=aodest*derad;
deltan=zeros(2,1,N);
% positionest=zeros(2,N);positionest(1,1)=x0;positionest(2,1)=y0;
for index=1:N-1
    %Form R using Eq. 12 and ~s using Eq. 11
    %             R=zeros(U*(L-1),2);
    %             for u=1:U
    %                 for k=1:L-1
    %                     %disp(u);disp(k);
    %                     R(k+(u-1)*(L-1),1)=twpi*(cos(theta33(1,k+1,u))-cos(theta33(1,1,u)))/lambda;
    %                     R(k+(u-1)*(L-1),2)=twpi*(sin(theta33(1,k+1,u))-sin(theta33(1,1,u)))/lambda;%正负号由于music算出来的path顺序不对故反
    %                 end
    %             end
    times=floor(index/M)+1;
    R=Rall(:,:,times);
    
    s=zeros(U*(L-1),1);
    for u=1:U
        for k=1:L-1
            s(k+(u-1)*(L-1),1)=-1i*log(D(k+1,k+1,u,index)/D(1,1,u,index));%正负号
        end
    end
    
    %delta cvx
    cvx_begin
    variable delta(L,1)
    minimize( norm( R * delta - s, 2 ) )	%目标函数
    cvx_end
    
    %sum up
    deltan(:,1,index)=delta(:,1);
    %             positionest(1,index+1)=positionest(1,index)+deltan(1,1,index);
    %             positionest(2,index+1)=positionest(2,index)+deltan(2,1,index);
end