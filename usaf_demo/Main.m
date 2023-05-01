

clc;
clear;
close all;

addpath(genpath('solver//'))
addpath(genpath('init_system//'))


%% Initialize experimental parameter and HR image
init_experimental_parameter;
init_image_num_index;
init_HR_image;


%% FPM reconstruction
algorithm = {'momFPIE',...
             'Gerchberg-Saxton',...
             'Adaptive-Stepsize',...
             'ADMM',...
             'ELF-PIE'};

use_algorithm = algorithm{5};

disp(['using ',use_algorithm,' for FPM reconstruction'])

switch use_algorithm
    case 'momFPIE'
        solver_momFPIE;
        results = F;
    case 'Gerchberg-Saxton'
        solver_GerchbergSaxton;
        results = F;
    case 'Adaptive-Stepsize'
        solver_AdaStep;
        results = F;
    case 'ADMM'
        solver_ADMM;
        results = F;
    case 'ELF-PIE'
        solver_Elfpie;
        results = F;
    otherwise
        warning('unexpected algorithm name')
end

rmpath(genpath('solver//'))
rmpath(genpath('init_system//'))