%% Forward 
temp_o = para_o.value;
for con = 1:arraysize^2
    fxc = fxc0(1,con);
    fyc = fyc0(1,con);
        
    fxl=round(fxc-(pix_CCD-1)/2);fxh=round(fxc+(pix_CCD-1)/2);
    fyl=round(fyc-(pix_CCD-1)/2);fyh=round(fyc+(pix_CCD-1)/2);
        
    CTF_system = pupil.*CTF_CCD;   
    F_sub_old = temp_o(fyl:fyh,fxl:fxh) .* CTF_system;
    img_old(:,:,con) = ifft2(ifftshift(F_sub_old)) / scale;
end

%% Fidelity-term
im_hold = abs(img_old).^(2 * gamma) - (lowSeq).^gamma;
gr_hold = operator_w(im_hold,fun_d,'isotropic');
img_new = img_old.*(abs(img_old) + eps).^(gamma - 1) .* (gr_hold); 

   
temp_g = conj(CTF_system) .* fftshift(fftshift(fft2(img_new),1),2) * ...
                                 scale ./max(max(abs(CTF_system).^2));
for con = 1:arraysize^2
    fxc = fxc0(1,con);
    fyc = fyc0(1,con);
        
    fxl=round(fxc-(pix_CCD-1)/2);fxh=round(fxc+(pix_CCD-1)/2);
    fyl=round(fyc-(pix_CCD-1)/2);fyh=round(fyc+(pix_CCD-1)/2);    
    para_o.grad(fyl:fyh,fxl:fxh) = para_o.grad(fyl:fyh,fxl:fxh) + ...
                                                       temp_g(:,:,con);
end
    
%% Global Hessian-term
if TV_reg ~= 0
    temp_o = ifft2(ifftshift(para_o.value)); 
    out1 = operator_Hessian(abs(temp_o));
    out2 = operator_Hessian(angle(temp_o));
    
    TV_term = fftshift(fft2((exp(1i*angle(temp_o)).*out1) + ...
                (1i.*(temp_o)./(abs(temp_o).^2 + 1e-5).*out2)));
    
    para_o.grad = para_o.grad + TV_reg * TV_term ;
else
    para_o.grad = para_o.grad;
end

%% backward
para_o = optimizer_AdaBelifDelta(para_o,r1,r2,iter);
para_o.grad = para_o.grad * 0; % set gradients to zeros
Result = ifft2(fftshift(para_o.value));

