twpi=2*pi;
U=4;L=2;N=20;M=20;%recaculate MUSIC results every M packets
MUSICtimes=int32(N/M)+1;
Hnew=zeros(9,N*Nsub,U);
Fnew=zeros(L,N*Nsub,U);
Rall=zeros(U*(L-1),2,MUSICtimes);
for times = 1:MUSICtimes
    U=4;L=2;N=20;M=20;%PARAMETER
    %1st antenna of Receiver, 1st packet of all 30 subcarriers
    % load Hadd.mat;
    load aodest.mat;
    load aoaest.mat;
    % load position.mat;
    K=N-(times-1)*M;%how many packets
    if(K>M)
        K=M;
    end
    if(K==0)
        break;
    end
    startPacket=M*(times-1)+1;
%     Hnew=zeros(9,N*Nsub,U);
%     Haddtemp=zeros(9,K*Nsub,U);
    for i=1:9
        for n=startPacket:startPacket+K-1
            for u=1:U
                Hnew(i,(n-1)*Nsub+1:n*Nsub,u)=Hadd(i,(n-1)*Nsub+1:n*Nsub,u);
            end
        end
    end
    Haddtemp=Hnew(:,(startPacket-1)*Nsub+1:(startPacket+K-1)*Nsub,:);
%     run MUSIC.m
    U=4;L=2;N=20;M=20;%PARAMETER
    %steering vector Anew
    Anew=zeros(3*3,L,U);
    A1new=zeros(3*3,L,U);%for debug usage
    for u=1:U
        for l=1:L
            if l==1%music角度顺序不一致
                tempt=aodest(1,2,u)*pi/180;tempt1=theta3(1,1,u)*derad;
                tempr=aoaest(1,2,u)*pi/180;tempr1=theta3r(1,1,u)*derad;
            else
                tempt=aodest(1,1,u)*pi/180;tempt1=theta3(1,2,u)*derad;
                tempr=aoaest(1,1,u)*pi/180;tempr1=theta3r(1,2,u)*derad;
            end

            for r=1:rkelm
                Anew((r-1)*tkelm+1:r*tkelm,l,u)=exp(-1i*twpi*rdd*(r-1)*cos(tempr)/lambda)*exp(-1i*twpi*td'*cos(tempt)/lambda);%3*1
                A1new((r-1)*tkelm+1:r*tkelm,l,u)=exp(-1i*twpi*rdd*(r-1)*cos(tempr1)/lambda)*exp(-1i*twpi*td'*cos(tempt1)/lambda);%3*1
            end
        end
    end

    %F
    Fnew11=zeros(L,K*Nsub,U);

    for u=1:U
        if DEBUG
            Fnew11(:,:,u)=A1new(:,:,u)\Hnew(:,:,u);%inv(A)*H,L*N
        else
            Fnew11(:,:,u)=Anew(:,:,u)\Hnew(:,:,u);%inv(A)*H,L*N
        end
    %     cvx_begin
    %     variable xx(L,N*Nsub)  complex
    %     minimize( norm( Hnew(:,:,u) -A1new(:,:,u)*xx,2 ) )	%目标函数
    %     cvx_end
    %     
    %     Fnew(:,:,u)=xx;
    end
    Fnew(:,(startPacket-1)*Nsub+1:(startPacket+K-1)*Nsub,:)=Fnew11;
    if DEBUG
        theta33=theta3*derad;
    else
        theta33=aodest*derad;
    end
    R11=zeros(U*(L-1),2);
    for u=1:U
        for k=1:L-1
            %disp(u);disp(k);
            R11(k+(u-1)*(L-1),1)=-twpi*(cos(theta33(1,k+1,u))-cos(theta33(1,1,u)))/lambda;
            R11(k+(u-1)*(L-1),2)=-twpi*(sin(theta33(1,k+1,u))-sin(theta33(1,1,u)))/lambda;%正负号由于music算出来的path顺序不对故反
        end
    end
    Rall(:,:,times)=R11;
end