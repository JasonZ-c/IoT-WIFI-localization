daoa=abs(groundTruth(:,1)-aoaest(:,1));
[aaa]=Cdf(daoa);
function [middle]=Cdf(x)
    %Cumulative Distribution Function (CDF
    n=length(x);
    [y,index]=sort(x);
    for i=1:n
        index(i)=i/n;
    end
    y=log(y)/log(10);
    plot(y,index,'b');
    xlabel('lg(aoa)/degree');
    ylabel('precent');
    title('CDF');
    middle=y(int32(n/2));
end