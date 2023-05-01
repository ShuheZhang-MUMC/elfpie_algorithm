%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calcute the step-size for the next iteration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate current cost function (it can also be incrementially
% accumulated without additional computation)

Err_now = 0;

for num = 1 : arraysize^2
    
    fxc = fxc0(1,num);
    fyc = fyc0(1,num);

    fxl=round(fxc-(pix_CCD-1)/2);fxh=round(fxc+(pix_CCD-1)/2);
    fyl=round(fyc-(pix_CCD-1)/2);fyh=round(fyc+(pix_CCD-1)/2);

    Subspecturm = F(fyl:fyh,fxl:fxh);
    Abbr_Subspecturm = Subspecturm.*Aperture_fun;
    
    Curr_lowres = (ifft2(fftshift(Abbr_Subspecturm)));
    Err_now = Err_now + sum(sum((abs(Curr_lowres)-sqrt(lowSeq(:,:,num))).^2));
    
end

if((Err_bef-Err_now)/Err_bef<0.0001)
    
    % Reduce the stepsize when no sufficient progress is made
    Alpha = Alpha/2;
    
    % Stop the iteration when Alpha is less than 0.001(convergenced)
    if(Alpha<0.001)
        Alpha = 0;
    end
    
end

Err_bef = Err_now;
