%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Gerchberg-Saxton FPM iteration (PIE with alpha =1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for num = 1 : arraysize^2
    
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
    
    W = abs(Aperture_fun)./max(max(abs(Aperture_fun)));
    
    invP = conj(Aperture_fun)./((abs(Aperture_fun)).^2+eps.^2);
    Subspecturmnew = (W.*Abbr_Subspecturm_corrected + (1-W).*(Abbr_Subspecturm)).*invP;
    Subspecturmnew(Aperture==0) = Subspecturm(Aperture==0);
    
    % Fourier sperturm replacement
    F(fyl:fyh,fxl:fxh) = Subspecturmnew;
    
    % Inverse FT to get the reconstruction
    
end

Result = ifft2(fftshift(F));

