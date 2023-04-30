function [xseq,yseq] = getoddseq(N)
if mod(N,2)==0
    error('N must be an odd integer');
end

num = N^2;
count = 1;
xseq = zeros(1,num);
yseq = zeros(1,num);
xseq(1,1) = (N+1)/2;
yseq(1,1) = (N+1)/2;
for n = 1:num
    if mod(n,2)==0
    for m = 1:n
        count = count + 1;
        xseq(1,count) = xseq(1,count-1);
        yseq(1,count) = yseq(1,count-1) -1;
        if count == num
            return;
        end
    end
    for m = 1:n
        count = count + 1;
        xseq(1,count) = xseq(1,count-1) -1;
        yseq(1,count) = yseq(1,count-1);
        if count == num
            return;
        end
    end
    else
        for m = 1:n
            count = count + 1;
            xseq(1,count) = xseq(1,count-1);
            yseq(1,count) = yseq(1,count-1) +1;
            if count == num
                return;
            end
        end
        for m = 1:n
            count = count + 1;
            xseq(1,count) = xseq(1,count-1) +1;
            yseq(1,count) = yseq(1,count-1);
            if count == num
                return;
            end
        end
    end
end

end