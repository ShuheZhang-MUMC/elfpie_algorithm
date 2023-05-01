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

q_para = zeros(M,N,arraysize^2);
p_para = zeros(M,N,arraysize^2);
w_para = zeros(M,N,arraysize^2);
m_para = zeros(Hi_res_M,Hi_res_N);
s_para = zeros(Hi_res_M,Hi_res_N);

para_alpha = 0.5;
para_gamma = 0;
para_delta = 1;
para_eta = 1;
% 

Aperture_fun = CTF_CCD;
Aperture = (CTF_CCD > 0);


Total_iter_num = 60;
figure
for iter = 1:Total_iter_num
    s_para = s_para * 0;
    % Reconstruction by one iteration of adaptive step-size strategy

    ADMM_core;

    % Show the Fourier spectrum
    subplot(1,2,1)
    imshow(log(abs(F)+1),[0, max(max(log(abs(F)+1)))/2]);
    title('Fourier spectrum');
    
    % Show the reconstructed amplitude
    subplot(1,2,2)
    imshow((abs(Result)),[]);
    title(['Iteration No. = ',int2str(iter)]);
    drawnow;
    % Stop the iteration when the algorithm converges
    
    pause(0.01);
end
Result_RS = Result;
