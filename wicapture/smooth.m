%for 9*30 csi to (4*15)*(4*16)
%4*4*+(15*16)
%for sub=30,t=3,r=3 only
Nsmooth=1;
[aaa]=csismooth(Haddtemp,U,1);
function [sCSI]=csismooth(X,U,Nsmooth)
%Npackets, UAPs
sCSI=zeros(4*15,4*16,U,Nsmooth);%edit
Nsub=30;%subcarriers
for p=1:Nsmooth
    for u=1:U%edit
        for i=1:15
            for j=1:16
                for r=1:3
                    for t=1:3
                        switch r
                            case{1}%block 1
                                if t<=2
                                    sCSI(i,(t-1)*16+j,u,p)=X((r-1)*3+t,(p-1)*Nsub+i+j-1,u);
                                else
                                    sCSI((t-2)*15+i,(t-2)*16+j,u,p)=X((r-1)*3+t,(p-1)*Nsub+i+j-1,u);
                                end
                                sCSI(15+i,j,u,p)=sCSI(i,16+j,u,p);
                            case{2}%block 2
                                if t<=2
                                    sCSI(i,(t-1)*16+j+32,u,p)=X((r-1)*3+t,(p-1)*Nsub+i+j-1,u);
                                else
                                    sCSI((t-2)*15+i,(t-2)*16+j+32,u,p)=X((r-1)*3+t,(p-1)*Nsub+i+j-1,u);
                                end
                                sCSI(15+i,j+32,u,p)=sCSI(i,16+j+32,u,p);
                                for ii=1:30%block 3
                                    for jj=1:32
                                        sCSI(ii+30,jj,u,p)=sCSI(ii,jj+32,u,p);
                                    end
                                end
                            case{3}%block 4
                                if t<=2
                                    sCSI(30+i,(t-1)*16+j+32,u,p)=X((r-1)*3+t,(p-1)*Nsub+i+j-1,u);
                                else
                                    sCSI(30+(t-2)*15+i,(t-2)*16+j+32,u,p)=X((r-1)*3+t,(p-1)*Nsub+i+j-1,u);
                                end
                                sCSI(30+15+i,j+32,u,p)=sCSI(i,16+j+32,u,p);
                        end
                    end
                end
            end
        end
        disp(u);
    end
    disp(p);
end
end