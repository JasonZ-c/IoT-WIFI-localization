% run csitry.m
disp("MUSIC");
run smooth.m
% L=1; lambda=0.06;
N=1;U=4;
aoaest=zeros(N,L,U);
aodest=zeros(N,L,U);
for packet=1:N
    for u=1:U
        X1=aaa(:,:,u);
        Rxx=X1*X1'/N;%X1=60*64
        [EV,D]=eig(Rxx);
        En=EV(:,1:30 -L);%noise space
        aor=50:1:170;
        aot=50:1:170;
        y=0.08*1e-7:0.05*1e-8:0.3*1e-7;
    %     [x_new,y_new]=meshgrid(aor,aot);

        SP=zeros(45,121,121);
        % 构造矩阵 z(a,b),下标为整型
        for a=1:1:121
            phimr=derad*aor(a);
            for c=1:1:121
                phimt=derad*aot(c);
                for b=1:1:45
                    tof123=y(b);
                    as=zeros(15*2*2,1);%steering v=30*1
                    for r=1:2
                        for t=1:2
                            for k=1:15
                                as((r-1)*30+(t-1)*15+k,1)=exp(-1i*twpi*tdd*(t-1)*cos(phimt)/lambda)*exp(-1i*twpi*rdd*(r-1)*cos(phimr)/lambda)*exp(-1i*twpi*fdelta*tof123*(k-1));%60*1
                            end
                        end
                    end
                    SP(b,a,c)=1/(as(:)'*(En*En')*as(:));
    %                 disp(b);
                end
    %             disp(c);
            end
            disp(a);
        end
        z=db(abs(SP));
    %     % 画图
    %     mesh(aor,y,z);
    %     xlabel('aoa/degree');
    %     ylabel('tof/s');
    %     title('music spectrum 5th packet');



        %find peak
        peaks=[];toflocs=[];aoalocs=[];aodlocs=[];
        for tof1 = (1+1):(45-1)
            for aoa1=(1+1):(121-1)
                for aod1=(1+1):(121-1)
                    if z(tof1,aoa1,aod1)>z(tof1-1,aoa1,aod1)&&z(tof1,aoa1,aod1)>z(tof1,aoa1,aod1-1)&&z(tof1,aoa1,aod1)>z(tof1,aoa1-1,aod1)
                        if z(tof1,aoa1,aod1)>z(tof1-1,aoa1-1,aod1)&&z(tof1,aoa1,aod1)>z(tof1,aoa1-1,aod1-1)&&z(tof1,aoa1,aod1)>z(tof1-1,aoa1,aod1-1)
                            if z(tof1,aoa1,aod1)>z(tof1+1,aoa1,aod1)&&z(tof1,aoa1,aod1)>z(tof1,aoa1,aod1+1)&&z(tof1,aoa1,aod1)>z(tof1,aoa1+1,aod1)
                                if z(tof1,aoa1,aod1)>z(tof1+1,aoa1+1,aod1)&&z(tof1,aoa1,aod1)>z(tof1+1,aoa1,aod1+1)&&z(tof1,aoa1,aod1)>z(tof1,aoa1+1,aod1+1)
                                    if z(tof1,aoa1,aod1)>z(tof1+1,aoa1+1,aod1+1)&&z(tof1,aoa1,aod1)>z(tof1-1,aoa1-1,aod1-1)
                                        peaks=[peaks z(tof1,aoa1,aod1)];
                                        toflocs=[toflocs tof1];
                                        aoalocs=[aoalocs aoa1];
                                        aodlocs=[aodlocs aod1];
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        aoalocs=50+1*aoalocs;
        aodlocs=50+1*aodlocs;
    %     toflocs=1e-8*toflocs;
        toflocs=0.08*1e-7+toflocs*0.05*1e-8;
        if length(peaks)>=L
            [npeaks,ind]=sort(-peaks);
            naoal=[];ntl=[];naodl=[];
            for i=1:L
                while(i>1&&abs(aoalocs(ind(i-1))-aoalocs(ind(i)))<5)
                    aoalocs([i])=[];
                    aodlocs([i])=[];
                end%删除误差
                naoal=[naoal aoalocs(ind(i))];
                naodl=[naodl aoalocs(ind(i))];
                ntl=[ntl toflocs(ind(i))];
            end
        else
            disp("less than L");break;
        end
        aoaest(packet,:,u)=naoal(1:L);
        aodest(packet,:,u)=naodl(1:L);
        disp('AP1');
    end
end
for u=1:U
    aoaest(1,:,u)=sort(aoaest(1,:,u));
end%rearrange the range of aoa,aod