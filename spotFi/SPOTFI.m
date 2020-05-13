L=1;
load csis.mat;
aoaest=zeros(61,L);
for packet=1:N
    N=1;U=1;
    sCSI=zeros(Nsub,Nsub+2,U,N);
    X=zeros(3,30);
    for i=1:3
        for j=1:Nsub
            X(i,j)=csis(packet,1,i,j);
        end
    end
    for i=1:15
        for j=1:16
            sCSI(i,j)=X(1,i+j-1);
            sCSI(i+15,j)=X(2,i+j-1);
            sCSI(i,j+16)=X(2,i+j-1);
            sCSI(i+15,j+16)=X(3,i+j-1);
        end
    end
    X1=sCSI;
    Rxx=X1*X1'/N;
    [EV,D]=eig(Rxx);
    En=EV(:,1:30 -L);%noise space
    % lambda=0.06;
    x=0:0.5:180;
    y=0:1e-8:5e-7;
    [x_new,y_new]=meshgrid(x,y);

    SP=zeros(51,361);
    % 构造矩阵 z(a,b),下标为整型
    for a=1:1:361
        phimr=derad*x(a);
        for b=1:1:51
            tof=y(b);
            as=zeros(30,1);%steering v=30*1
            for r=1:2
                for k=1:15
                    as((r-1)*15+k,1)=exp(-1i*twpi*rdd*(r-1)*cos(phimr)/lambda)*exp(-1i*twpi*fdelta*tof*(k-1));%30*1
                end
            end
            SP(b,a)=1/(as(:)'*(En*En')*as(:));
        end
    end
    z=db(abs(SP));
    % 画图
    mesh(x,y,z);
    xlabel('aoa/degree');
    ylabel('tof/s');
    title('music spectrum 5th packet');



    %find peak
    peaks=[];toflocs=[];aoalocs=[];
    for tof1 = (1+1):(51-1)
        for aoa1=(1+1):(361-1)
            if z(tof1,aoa1)>z(tof1-1,aoa1)&&z(tof1,aoa1)>z(tof1-1,aoa1-1)
                if z(tof1,aoa1)>z(tof1+1,aoa1)&&z(tof1,aoa1)>z(tof1,aoa1+1)&&z(tof1,aoa1)>z(tof1+1,aoa1+1)
                    if z(tof1,aoa1)>z(tof1+1,aoa1-1)&&z(tof1,aoa1)>z(tof1-1,aoa1+1)&&z(tof1,aoa1)>z(tof1,aoa1-1)
                        peaks=[peaks z(tof1,aoa1)];
                        toflocs=[toflocs tof1];
                        aoalocs=[aoalocs aoa1];
                    end
                end
            end
        end
    end
    aoalocs=aoalocs/2;
    toflocs=1e-8*toflocs;
    if length(peaks)>=L
        [npeaks,ind]=sort(-peaks);
        naoal=[];ntl=[];
        for i=1:L
            naoal=[naoal aoalocs(ind(i))];
            ntl=[ntl toflocs(ind(i))];
        end
    else
        disp("less than L");
    end
    aoaest(packet,:)=naoal(1:L);
    disp(packet);
end
