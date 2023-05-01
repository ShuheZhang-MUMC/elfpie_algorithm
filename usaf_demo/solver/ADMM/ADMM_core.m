%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Solving FPM reconstruction using ADMM method

%{
    This is the implementation of the algorithm in Ref:

    Wang A, Zhang Z, Wang S, Pan A, Ma C, Yao B. 
    Fourier Ptychographic Microscopy via Alternating Direction Method 
    of Multipliers, Cells (2022), 30;11(9):1512. 

    https://www.mdpi.com/2073-4409/11/9/1512
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for num = 1 : arraysize^2
    
    % Calcute the step-size for the next iteration

    
    % Get the subspecturm
    fxc = fxc0(1,num);
    fyc = fyc0(1,num);

    fxl=round(fxc-(pix_CCD-1)/2);fxh=round(fxc+(pix_CCD-1)/2);
    fyl=round(fyc-(pix_CCD-1)/2);fyh=round(fyc+(pix_CCD-1)/2);
    
    Subspecturm = F(fyl:fyh,fxl:fxh);
    
    F_sub_old = Subspecturm.*Aperture_fun;
    if iter == 1
        m_para(fyl:fyh,fxl:fxh) = m_para(fyl:fyh,fxl:fxh) + abs(Aperture_fun).^2;
    end
    % Real space modulus constraint
    temp_q = F_sub_old - w_para(:,:,num);
    
    img_old = ifft2(ifftshift(temp_q)) / scale;
    
    q_para(:,:,num) = temp_q + 1./(1 + para_alpha).*...
              fftshift(fft2(sqrt(lowSeq(:,:,num)).*exp(1i*angle(img_old)) - img_old)) * scale;
          
    s_para(fyl:fyh,fxl:fxh) = s_para(fyl:fyh,fxl:fxh) + ...
            (q_para(:,:,num) + w_para(:,:,num)).*conj(Aperture_fun);
    
end
fenzi = para_gamma * (para_delta/para_alpha) + s_para;
fenmu = para_gamma * (para_delta/para_alpha) + m_para;
F = fenzi./(fenmu + eps);

for num = 1:arraysize^2
    fxc = fxc0(1,num);
    fyc = fyc0(1,num);

    fxl=round(fxc-(pix_CCD-1)/2);fxh=round(fxc+(pix_CCD-1)/2);
    fyl=round(fyc-(pix_CCD-1)/2);fyh=round(fyc+(pix_CCD-1)/2);
       

    F_sub_old = F(fyl:fyh,fxl:fxh) .* Aperture_fun;
    
    w_para(:,:,num) = w_para(:,:,num) + para_eta.*...
            (q_para(:,:,num) - F_sub_old);
end

Result = ifft2(fftshift(F));