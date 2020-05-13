N=1;U=1;
sCSI=zeros(Nsub,Nsub+2,U,N);
X=zeros(3,30);
for i=1:3
    for j=1:Nsub
        X(i,j)=csis(1,1,i,j);
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

length(csis(1,:,1,1))