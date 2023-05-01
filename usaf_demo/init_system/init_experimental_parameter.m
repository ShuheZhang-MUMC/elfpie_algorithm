%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize experimental parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load raw dataset (USAF target)
load lowSeqData260.mat;

% Raw image size
[M,N] = size(lowSeq(:,:,1));
pix_CCD = M; % image is squared, M = N

% LED number
arraysize = 8; % square-LED array, LED number in x-direction

Total_Led = arraysize * arraysize;
LED_center = (Total_Led + 1)/2;

% obj NA and magnification
NA = 0.1;
Mag = 3;

% System parameters
LEDheight = 180;
LEDlength = 8;
Pixel_size = 3.45/Mag;
lambda = 0.532;
k = 2*pi/lambda;
kmax = 1/lambda*NA;

% Upsampling ratio
Mag_image = 5;
% Pixel_size_image = Pixel_size/Mag_image;
% Pixel_size_image_freq = 1/Pixel_size_image/(M*Mag_image);


newpix = Mag_image * M;

% Create pupil mask
cutFeq = NA/lambda; 
fx_CCD = (-pix_CCD/2 : pix_CCD/2-1)/(Pixel_size * pix_CCD);
[fx0,fy0] = meshgrid(fx_CCD);
CTF_CCD = ((fx0.^2+fy0.^2) < cutFeq^2); 
df = fx0(1,2)-fx0(1,1);
