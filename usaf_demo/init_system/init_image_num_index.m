%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize image index (updating based on the NA order)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% initialize image index

[xsq,ysq] = led_range_even(arraysize);
pos = linspace(-(arraysize-1)*LEDlength/2,(arraysize-1)*LEDlength/2,arraysize);

imf_nc = zeros(2,arraysize^2); % 平面波的 照明频率
for n = 1:arraysize^2 % from top left to bottom right
    x = pos(xsq(n));y=pos(ysq(n));
    vector = [0,0,LEDheight] - [x,y,0];
    vector = vector/norm(vector); %照明方向

    imf_nc(1,n) =   vector(2)/lambda; 
    imf_nc(2,n) =  -vector(1)/lambda; 
end

fxc0 = round((newpix+1)/2 + imf_nc(1,:)/df);
fyc0 = round((newpix+1)/2 + imf_nc(2,:)/df);