%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize HR image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Upsample the central low-resolution image
A = imresize(sqrt(lowSeq(:,:,1)),Mag_image);

% Rescale to image for energy conservation
scale = Mag_image.^2;
A = A / 1;
[Hi_res_M,Hi_res_N] = size(A);

% Initialize HR image use the amplitude of central low-resolution image
F = fftshift(fft2(A));


