%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Solving FPM reconstruction using momentum method

%{
    This is the implementation of the algorithm in from:

    https://github.com/SmartImagingLabUConn/Fourier-Ptychography

%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



T = 1;
alpha = 0.5;
beta = 1;
gamma_obj = 1;
gamma_p = 1;
eta_obj = 0.2;
eta_p = 0.2;

if_ic = 0; % LED intensity correction 

fmaskpro = CTF_CCD;

himFT = F;
vobj0 = zeros(Hi_res_M,Hi_res_N);
vp0 = zeros(M,N);
ObjT = himFT; 
PT = fmaskpro;
pupil_mask = abs(fmaskpro) > 0;

Total_iter_num = 50;

countimg = 0;
for loop = 1:Total_iter_num
    disp(['at ',num2str(loop),'-th iteration'])
    
    momFPIE;

    Result = ifft2(ifftshift(himFT));
    F = himFT;
    subplot(1,2,1)
    imshow(log(abs(F)+1),[0, max(max(log(abs(F)+1)))/2]);
    title('Fourier spectrum');
    
    % Show the reconstructed amplitude
    subplot(1,2,2)
    imshow((abs(Result)),[]);
    title(['Iteration No. = ',int2str(loop)]);
    drawnow;
 
end