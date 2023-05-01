    for i3 = 1:arraysize^2
        countimg=countimg+1; 

        fxc = fxc0(1,i3);
        fyc = fyc0(1,i3);

        fxl=round(fxc-(pix_CCD-1)/2);fxh=round(fxc+(pix_CCD-1)/2);
        fyl=round(fyc-(pix_CCD-1)/2);fyh=round(fyc+(pix_CCD-1)/2);

        O_j = himFT(fyl:fyh,fxl:fxh); 

        pupil_func = fmaskpro .* pupil_mask;
        lowFT = O_j.*pupil_func;
        im_lowFT = ifft2(ifftshift(lowFT));
    
        if if_ic   % LED intensity correction 
            tt(1,i3+(loop-1)*arraysize^2) = ...
                (mean(abs(im_lowFT(:))) / ...
                mean(mean(scale * abs(sqrt(lowSeq(:,:,i3))))));

            if loop > 2 
                lowSeq(:,:,i3) = lowSeq(:,:,i3) .* tt(1,i3+(loop-1)*arraysize^2).^2; 
            end     
        end

        updatetemp = scale * sqrt(lowSeq(:,:,i3));

        im_lowFT = updatetemp .* exp(1j.*angle(im_lowFT)); 
        lowFT_p = fftshift(fft2(im_lowFT));

        himFT(fyl:fyh,fxl:fxh) = himFT(fyl:fyh,fxl:fxh)+...
                      gamma_obj.*conj(pupil_func).*((lowFT_p-lowFT))./...
     ((1-alpha).*abs(pupil_func).^2 + alpha.*max(max(abs(pupil_func).^2)));

% updating for pupil function ↓    
%         fmaskpro=fmaskpro+gamma_p.*conj(O_j).*((lowFT_p-lowFT))./((1-beta).*abs(O_j).^2 + beta.*max(max(abs(O_j).^2)));            
       
        if countimg == T % momentum method
            vobj = eta_obj.*vobj0 + (himFT - ObjT);
            himFT = ObjT + vobj;
            vobj0 = vobj;                  
            ObjT = himFT;

% updating for pupil function ↓ 
%             vp = eta_p.*vp0 + (fmaskpro - PT);
%             fmaskpro = PT + vp;
%             vp0 = vp;
%             PT = fmaskpro;

            countimg = 0;
        end
    end