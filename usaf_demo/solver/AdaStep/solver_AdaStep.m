%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reconstruction by the adaptive step-size strategy (adaptive alpha)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Total_iter_num = inf;
Aperture_fun = CTF_CCD;
Aperture = (CTF_CCD > 0);
% 
% % Reconstruction and display the result
figure
for iter = 1:Total_iter_num
    
    % Reconstruction by one iteration of adaptive step-size strategy
    eval AS;
    
    % Show the Fourier spectrum
    subplot(1,2,1)
    imshow(log(abs(F)+1),[0, max(max(log(abs(F)+1)))/2]);
    title('Fourier spectrum');
    
    % Show the reconstructed amplitude
    subplot(1,2,2)
    imshow((abs(Result)),[]);
    title(['Iteration No. = ',int2str(iter), '  \alpha = ',num2str(Alpha)]);
    drawnow;
    % Stop the iteration when the algorithm converges
    if(Alpha == 0) break; end
    
    pause(0.01);
end
Result = F;