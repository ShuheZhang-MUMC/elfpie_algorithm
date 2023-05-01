%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Adaptive step-size iteration (PIE with adpative alpha)

% Main file to implement the adaptive step-size strategy for Fourier
% ptychographic reconstruction algorithm
%
% Related Reference:
% Adaptive step-size strategy for noise-robust Fourier ptychographic microscopy
% C. Zuo, J. Sun, and Q Chen, submitted to Optics Express
%
% last modified on 03/08/2016
% by Chao Zuo (surpasszuo@163.com, zuochao@njust.edu.cn)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for num = 1 : arraysize^2
    
    % Calcute the step-size for the next iteration
    if(num ==1 && iter==1)
        Alpha = 1;
        Err_bef = inf;
    elseif(num ==1 && iter>1)
        Calc_stepsize;
    end
    
    % Get the subspecturm
    fxc = fxc0(1,num);
    fyc = fyc0(1,num);

    fxl=round(fxc-(pix_CCD-1)/2);fxh=round(fxc+(pix_CCD-1)/2);
    fyl=round(fyc-(pix_CCD-1)/2);fyh=round(fyc+(pix_CCD-1)/2);

    Subspecturm = F(fyl:fyh,fxl:fxh);
    Abbr_Subspecturm = Subspecturm.*Aperture_fun;
    
    % Real space modulus constraint
    Uold = ifft2(fftshift(Abbr_Subspecturm)) / scale;
    Unew = sqrt(lowSeq(:,:,num)).*(Uold./abs(Uold));
    
    % Fourier space constraint and object function update
    Abbr_Subspecturm_corrected = fftshift(fft2(Unew)) * scale;
    Subspecturm = F(fyl:fyh,fxl:fxh);
    
    W = Alpha*abs(Aperture_fun)./max(max(abs(Aperture_fun)));
    
    invP = conj(Aperture_fun)./((abs(Aperture_fun)).^2+eps.^2);
    Subspecturmnew = (W.*Abbr_Subspecturm_corrected + (1-W).*(Abbr_Subspecturm)).*invP;
    Subspecturmnew(Aperture==0) = Subspecturm(Aperture==0);
    
    % Fourier sperturm replacement
    F(fyl:fyh,fxl:fxh) = Subspecturmnew;
    
    % Inverse FT to get the reconstruction
    
end
Result = ifft2(fftshift(F));
