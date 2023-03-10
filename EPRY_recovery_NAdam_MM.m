function EPRY_recovery_NAdam_MM()

if_gradient = 1;  %  = 1: using gradient-based fidelity 
if_intensity = 0; %  = 1: using intensity measure fidelity, =0 using amplitude

load_data = load('simulation//FPM_data_cube.mat');

%{
nnn = [-1, 2,-1;
        2,-4, 2;
       -1, 2,-1];

TV_reg = 1/5*(pi/2)*mean(mean(mean(...
     abs(imfilter(sqrt(load_data.I_camera_noised),nnn))...
     )));
%}

TV_reg = 0;
I_camera = load_data.I_camera_noised;

[lambda,n_LED,CTF_object0,~,NA,...
                     pix_CCD,plane_wave,~,df,~]=ini_enviroment(0,0);
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


Dx = @(x) imfilter(x,[-1,1],'symmetric');
Dy = @(x) imfilter(x,[-1;1],'symmetric');

DTx = @(x) imfilter(x,[1,-1,0],'symmetric');
DTy = @(x) imfilter(x,[1;-1;0],'symmetric');


img_old = zeros(pix_CCD,pix_CCD,n_LED^2);

for loop = 1:50
    
    tic

    temp_o = para_o.value;
    
    %% forward
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
        if ~if_intensity
            diff_ = abs(img_old) - sqrt(I_camera);
            gradient_x = Dx(diff_);
            gradient_y = Dy(diff_);
            den = sqrt(gradient_x.^2 + gradient_y.^2) + eps;
            gradient = DTx(gradient_x./den)+DTy(gradient_y./den);
            img_new = exp(1i*angle(img_old)) .* (gradient); 
        else
            diff_ = abs(img_old).^2 - sqrt(I_camera).^2;
            gradient_x = Dx(diff_);
            gradient_y = Dy(diff_);
            den = sqrt(gradient_x.^2 + gradient_y.^2) + eps;
            gradient = DTx(gradient_x./den)+DTy(gradient_y./den);
            img_new = img_old .* (gradient); 
        end
    else
        diff_ = abs(img_old) - sqrt(I_camera);
        img_new = exp(1i*angle(img_old)).*(diff_);
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
    
        para_o.grad = para_o.grad./(1 + eps) + TV_reg * TV_term ;
    else
        para_o.grad = para_o.grad./(1 + eps);
    end

    %% backward
    para_o = optimizer_AdaBelifDelta(para_o,r1,r2,loop);
    para_o.grad = para_o.grad * 0; % set gradients to zeros
    
    %% show results
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
% out = para_o.value;

end


function out = get_Hessian(temp_o)
%     g = fspecial('gaussian',[51,51],25);
    TV_xx = conv2(temp_o,[1,-2,1],'same');
    TV_yy = conv2(temp_o,[1;-2;1],'same');
    TV_xy = conv2(temp_o,[1,-1;-1,1],'same');
    
%     sss = sqrt(TV_xx.^2 + TV_yy.^2 + 2 * TV_xy.^2) + eps;
    out = conv2(sign(TV_xx),[1,-2,1],'same')+...
          conv2(sign(TV_yy),[1;-2;1],'same')+...
       2* conv2(sign(TV_xy),[0,0,0;0,1,-1;0,-1,1],'same');
end

% optimizer1 AdaBelif + Delta step size
function o_new = optimizer_AdaBelifDelta(o_old,r1,r2,loop)
    o_new = o_old;
    
    eps_ = 1e-5;

    o_new.mom1 = r1 * o_old.mom1 + (1 - r1) * o_old.grad;
    o_new.mom2 = r2 * o_old.mom2 + (1 - r2) * abs(o_old.mom1 - ...
                                                  o_old.grad).^2;
        
    m1 = o_new.mom1/(1 - r1^loop);
    m2 = o_new.mom2/(1 - r2^loop);
    new_grad =  (sqrt(o_old.step) + eps_)./ (sqrt(m2) + eps_) .*...
                                  (r1 * m1 + (1 - r1) * o_old.grad);

    o_new.value = o_old.value - new_grad; 

    o_new.step = r1 *o_old.step + (1 - r1) * abs(new_grad).^2;
end

% optimizer2 Adam
function o_new = optimizer_Adam(o_old,r1,r2,loop)
    o_new = o_old;
    
    eps_ = 1e-5;

    o_new.mom1 = r1 * o_old.mom1 + (1 - r1) * o_old.grad;
    o_new.mom2 = r2 * o_old.mom2 + (1 - r2) * abs(o_old.grad).^2;
        
    m1 = o_new.mom1/(1 - r1^loop);
    m2 = o_new.mom2/(1 - r2^loop);

    new_grad =  m1./ (sqrt(m2) + eps_);

    o_new.value = o_old.value - o_new.step .* new_grad; 
end

% optimizer3 SGD
function o_new = optimizer_SGD(o_old,r1,r2,loop)
    o_new = o_old;
    o_new.value = o_old.value - 0.001 .* o_old.grad; 
end
