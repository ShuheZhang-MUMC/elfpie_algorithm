%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reconstruction by Gerchberg-Saxton (PIE with alpha =1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run for 8 itertions (which is sufficient to `converge')
Total_iter_num = 30;
Aperture_fun = CTF_CCD;
Aperture = (CTF_CCD > 0);

% Reconstruction and display the result
figure
for iter = 1:Total_iter_num
    
    % Reconstruction by one iteration of Gerchberg-Saxton
    GS;

    % Show the Fourier spectrum
    subplot(1,2,1)
    imshow(log(abs(F)+1),[0, max(max(log(abs(F)+1)))/2]);
    title('Fourier spectrum');
    
    % Show the reconstructed amplitude
    subplot(1,2,2)
    imshow((abs(Result)),[]);
    title(['Iteration No. = ',int2str(iter)]);
    drawnow;
    pause(0.01);
end