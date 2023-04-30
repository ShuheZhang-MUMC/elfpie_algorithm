clc
clear

if_gradient = 1;  
% = 1 using gradient-based fidelity; 
% = 0 using traditional FPM

gamma = 1/2;   
% Gamma correction on the intensity measurement             
% gamma = 1.0   using intensity measure fidelity,            
% gamma = 0.5   using amplitude

if_show_intermedia = 1;



load_data = load('simulation//FPM_data_cube.mat');

path = 'funsets//';
addpath(genpath(path));


nnn = [-1, 2,-1;
        2,-4, 2;
       -1, 2,-1];

TV_reg = 1/5*(pi/2)*mean(mean(mean(...
     abs(imfilter(sqrt(load_data.I_camera_noised),nnn))...
     ))); % = 1: using Hessian regularization for denoising



I_camera = load_data.I_camera_noised;

[lambda,n_LED,CTF_object0,~,NA,...
                     pix_CCD,plane_wave,~,df,~]=init_enviroment(0,0);
PIX = 513;
m_factor = (PIX/pix_CCD);

S = imresize(sqrt(mean(I_camera(:,:,1:9),3)),[PIX,PIX])/ m_factor^0;

pupil = 1;

fxc0 = round((PIX+1)/2+plane_wave(1,:)/lambda/df);
fyc0 = round((PIX+1)/2+plane_wave(2,:)/lambda/df);


para_o.value = fftshift(fft2(S));
para_o.mom1 = zeros(PIX,PIX);
para_o.mom2 = zeros(PIX,PIX);
para_o.grad = zeros(PIX,PIX);
para_o.step = 10;



r1 = 0.9;
r2 = 0.99;
% TV_reg = 0.1;

Dx = @(x) imfilter(x,[0,-1,1],'circular');
Dy = @(x) imfilter(x,[0;-1;1],'circular');

DTx = @(x) imfilter(x,[0,-1,1],'circular','conv');
DTy = @(x) imfilter(x,[0;-1;1],'circular','conv');

fun_d = {Dx,DTx;
         Dy,DTy};

img_old = zeros(pix_CCD,pix_CCD,n_LED^2);

for loop = 1:50
    
    tic

    temp_o = para_o.value;
    
    %% forward:
    for con = 1:n_LED^2
        fxc = fxc0(1,con);%round((PIX+1)/2+plane_wave(1,:)/lambda/df);
        fyc = fyc0(1,con);%round((PIX+1)/2+plane_wave(2,:)/lambda/df);
        
        fxl=round(fxc-(pix_CCD-1)/2);fxh=round(fxc+(pix_CCD-1)/2);
        fyl=round(fyc-(pix_CCD-1)/2);fyh=round(fyc+(pix_CCD-1)/2);
        
        CTF_system = pupil.*CTF_object0;   
        F_sub_old = temp_o(fyl:fyh,fxl:fxh) .* CTF_system;
        img_old(:,:,con) = ifft2(ifftshift(F_sub_old)) / m_factor^2;
    end

    if if_gradient
        im_hold = abs(img_old).^(2 * gamma) - (I_camera).^gamma;
        gr_hold = operator_w(im_hold,fun_d,'isotropic');
        img_new = img_old.*(abs(img_old) + eps).^(gamma - 1) .* (gr_hold); 
    else
        im_hold = abs(img_old) - sqrt(I_camera);
        img_new = exp(1i*angle(img_old)).*(im_hold);
    end
   
    temp_g = conj(CTF_system) .* fftshift(fftshift(fft2(img_new),1),2) * ...
                                 m_factor^2 ./max(max(abs(CTF_system).^2));
    for con = 1:n_LED^2
        fxc = fxc0(1,con);%round((PIX+1)/2+plane_wave(1,:)/lambda/df);
        fyc = fyc0(1,con);%round((PIX+1)/2+plane_wave(2,:)/lambda/df);
        
        fxl=round(fxc-(pix_CCD-1)/2);fxh=round(fxc+(pix_CCD-1)/2);
        fyl=round(fyc-(pix_CCD-1)/2);fyh=round(fyc+(pix_CCD-1)/2);    
        para_o.grad(fyl:fyh,fxl:fxh) = para_o.grad(fyl:fyh,fxl:fxh) + ...
                                                           temp_g(:,:,con);
    end
    
    %% Global Hessian 
    if TV_reg ~= 0
        temp_o = ifft2(ifftshift(para_o.value)); 
        out1 = get_Hessian(abs(temp_o));
        out2 = get_Hessian(angle(temp_o));
    
        TV_term = fftshift(fft2((exp(1i*angle(temp_o)).*out1) + ...
                (1i.*(temp_o)./(abs(temp_o).^2 + 1e-5).*out2)));
    
        para_o.grad = para_o.grad + TV_reg * TV_term ;
    else
        para_o.grad = para_o.grad;
    end

    %% backward
    para_o = optimizer_AdaBelifDelta(para_o,r1,r2,loop);
    para_o.grad = para_o.grad * 0; % set gradients to zeros
    
    %% show results
    if if_show_intermedia
        img = ifft2(ifftshift(para_o.value));
        ic = abs(img);

        figure(2022);
        subplot(1,3,1)
        imshow(log(abs((para_o.value)+1)),...
               [0, max(max(log(abs((para_o.value)+1))))/2]);
        title('Fourier spectrum');
    
        % Show the reconstructed amplitude
        subplot(1,3,2)
        imshow(ic,[]);
        title(['Iteration No. = ',int2str(loop),' amplitude']);
        drawnow;

        subplot(1,3,3)
        imshow(angle(img),[]);
        title(['Iteration No. = ',int2str(loop),' phase']);
        drawnow;
        dur = toc;
        disp(['at ',num2str(loop),'-th iter, duration = ',...
                        num2str(dur)]);
    end
end
% out = para_o.value;







