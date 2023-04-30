#### The parameters for toy image system is in ini_enviroment.m <br>
<br>
<br>

#### 1. Run 'FPM_getSubimage_LEDpos.m' to generate toy FPM data cube. The cube will be saved in simulation folder. <br>

The code will generate FPM low-resolution images degraded by salt & pepper noise and Gaussian noise. <br>
There are also LED position shift, the amplitude of shift can be controlled by parameter named "LED_pos". <br>
The ideal LED positions as well as the shifted one will be shown in one Figure.

#### 2. Run 'EPRY_recovery_NAdam_MM.m' for ELFPIE recontruction. <br>
