%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reconstruction by the Elfpie strategy (adaptive alpha)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

para_o.value = F;
para_o.mom1 = zeros(Hi_res_M,Hi_res_N);
para_o.mom2 = zeros(Hi_res_M,Hi_res_N);
para_o.grad = zeros(Hi_res_M,Hi_res_N);
para_o.step = 100;


mask = zeros(Hi_res_M,Hi_res_N);


r1 = 0.9;
r2 = 0.999;

nnn = [-1, 2,-1;
        2,-4, 2;
       -1, 2,-1];

TV_reg = 1/5*(pi/2)*mean(mean(mean(...
     abs(imfilter(sqrt(lowSeq),nnn))...
     )));
gamma = 1/2;

%% operator
Dx = @(x) imfilter(x,[0,-1,1],'circular');
Dy = @(x) imfilter(x,[0;-1;1],'circular');

DTx = @(x) imfilter(x,[0,-1,1],'circular','conv');
DTy = @(x) imfilter(x,[0;-1;1],'circular','conv');

fun_d = {Dx,DTx;
         Dy,DTy};

Total_iter_num = 40;

img_old = zeros(pix_CCD,pix_CCD,arraysize^2);
pupil = 1;

figure
for iter = 1:Total_iter_num
    
    % Reconstruction by one iteration of adaptive step-size strategy
    elfpie_core;
    F = para_o.value;
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
%     if(Alpha == 0) break; end
    
    pause(0.01);
end
Result_RS = Result;