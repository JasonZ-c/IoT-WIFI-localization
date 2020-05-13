% dposition=zeros(N,1);
% for i=1:N
%     dposition(i,1)=sqrt((position1(i,1)-positionest(1,i))^2+(position1(i,2)-positionest(2,i))^2);
% end
dposition1=zeros(N,1);
for i=1:N
    dposition1(i,1)=sqrt((position1(i,1)-positionest(1,i))^2+(position1(i,2)-positionest(2,i))^2);
end
[aaa]=Cdf(dposition,dposition1);
% [aaa1]=Cdf(dposition1);

function [middle]=Cdf(x,x1)
%     %Cumulative Distribution Function (CDF
    n=length(x);
    n1=length(x1);
    [y,index]=sort(x);
    [y1,index1]=sort(x1);
    for i=1:n
        index(i)=i/n;
    end
    y=log(100*y)/log(10);
    y1=log(100*y1)/log(10);
%     y=100*y;
    plot(y,index,'b');
    hold on;
    plot(y1,index,'r');
    xlabel('log(position error)/cm');
    ylabel('precent');
    title('CDF blue=fixed; red=without fixing');
    middle=y(int32(n/2));
end