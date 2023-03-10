function ffFPM_getSubimage_LEDpos()
%{
    FPM simulation 
    generate low resolution image
%}


%% read object imaging
pix = 513;
[x,y] = meshgrid(linspace(-1,1,pix));

I = double(imread(['resourse//5.3.01.tiff']))/255;
P = double(imread(['resourse//5.3.02.tiff']))/255;
I = imresize(I,[pix,pix]);
P = imresize(P,[pix,pix]);

mask = 1;%sqrt(x.^2+y.^2) < 0.99^2;

% figure(121);
% plot(P(256,:),'k','linewidth',2)
I = mat2gray(I);
P = mat2gray(P);

I = (0.9*I + 0.1);
P = (0.9*P + 0.1);
save('simulation//ground_truth.mat','I','P')
O = sqrt(I.*mask).*exp(1i*P); % complex amplitude of object
% imshow(angle(O),[])

%% initializing enviroment

% noise_group = [1e-5,1e-4,1e-3,1e-2];

LED_pos = 2;
[lambda,n_LED,CTF_object0,CTF_object,NA,...
                     pix_CCD,~,plane_wave,df,~] = ini_enviroment(LED_pos,1);

m_factor = (pix/pix_CCD);
                 

%% Simulation of the process of snapshot
F = fftshift(fft2(O));
I_camera = zeros(pix_CCD,pix_CCD,n_LED^2);

for con = 1:n_LED^2
    fxc = round((pix+1)/2+(plane_wave(1,con)/lambda)/df);
    fyc = round((pix+1)/2+(plane_wave(2,con)/lambda)/df);
    
    fxl=round(fxc-(pix_CCD-1)/2);fxh=round(fxc+(pix_CCD-1)/2);
    fyl=round(fyc-(pix_CCD-1)/2);fyh=round(fyc+(pix_CCD-1)/2);
    
    F_sub = F(fyl:fyh,fxl:fxh) .* CTF_object; 
    I_camera(:,:,con) = abs(ifft2(ifftshift(F_sub))).^2 .* mask;
    con
end

%% intensity in CCD

I_camera = I_camera - min(I_camera(:));
I_camera = I_camera / max(I_camera(:));



I_camera_noised = I_camera;


tic        
for con = 1:n_LED^2
    I_camera_noised(:,:,con) = imnoise(I_camera(:,:,con),'salt & pepper',0.01) + 0.00001*randn(pix_CCD);
    if con < 26
        imwrite(I_camera_noised(:,:,con),['rawimage//image_2_',num2str(con),'.png'])
    end
end
save('simulation//FPM_data_cube.mat','I_camera_noised')
toc

end

function out = add_poisson_noise(in,strength)
in = uint8(in * strength);
out = imnoise(in,'poisson');
out = double(out)/strength;

end