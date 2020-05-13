DEBUG=1;
% run csitry.m;
% run wicapture.m;
% run Dcvx.m
% run RScvx.m;
% N=2;

%comparison of position results after optimization
positionest=zeros(2,N);positionest(1,1)=x0;positionest(2,1)=y0;
for index=1:8
    positionest(1,index+1)=positionest(1,index)+deltan(1,1,index);
    positionest(2,index+1)=positionest(2,index)+deltan(2,1,index);
end
% positionest(:,9)=position(9,:);
for index=9:14
    positionest(1,index+1)=positionest(1,index)+deltan(1,1,index);
    positionest(2,index+1)=positionest(2,index)+deltan(2,1,index);
end
% positionest(:,15)=position(15,:);
for index=15:N-1
    positionest(1,index+1)=positionest(1,index)+deltan(1,1,index);
    positionest(2,index+1)=positionest(2,index)+deltan(2,1,index);
end
position1=zeros(N,2);
for i=1:N
    position1(i,1)=position(i,1);
    position1(i,2)=position(i,2);
end

plot(100*positionest(1,:),100*positionest(2,:),'-r*');
hold on;
plot(100*position1(:,1),100*position1(:,2),'-b*');
xlabel(' x/cm');
ylabel('y/cm');
title('blue=real,red=est');
