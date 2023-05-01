function [xpos,ypos]=led_range_even(arraysize)
if mod(arraysize,2)~=0
    error('矩阵阶数必须为偶数')
end
xpos=zeros(1,arraysize^2);
ypos=zeros(1,arraysize^2);
xpos(1)=(arraysize)/2;
ypos(1)=(arraysize)/2+1;

dx=1;
n=2;
while true
    for t=1:4
        if t==1
            for k=1:dx
               ypos(n)=ypos(n-1)-1;
               xpos(n)=xpos(n-1);
               n=n+1;
               if n==(arraysize^2+1)
                   break
               end
            end
        elseif t==2
            for k=1:dx
               ypos(n)=ypos(n-1);
               xpos(n)=xpos(n-1)+1;
               n=n+1;
               if n==(arraysize^2+1)
                   break
               end
            end
            dx=dx+1;
        elseif t==3
            for k=1:dx
               ypos(n)=ypos(n-1)+1;
               xpos(n)=xpos(n-1);
               n=n+1;
               if n==(arraysize^2+1)
                   break
               end
            end
        elseif t==4
            for k=1:dx
               ypos(n)=ypos(n-1);
               xpos(n)=xpos(n-1)-1;
               n=n+1;
               if n==(arraysize^2)
                   break
               end
            end
            dx=dx+1;
        end
        if n==(arraysize^2+1)
            break
        end
    end
    if n==(arraysize^2+1)
        break
    end
end


end