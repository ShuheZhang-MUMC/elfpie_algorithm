#### The parameters for toy image system is in funsets//init_enviroment.m <br>
<br>
<br>


#### 1. Run 'FPM_get_LowResImg.m' to generate toy FPM data cube. The cube will be saved in simulation folder. <br>

<img src="https://github.com/ShuheZhang-MUMC/elfpie_algorithm/blob/main/toy-experiment/figure_support/Fig1.png" width = "800" alt="" align=center />
</div>
The code generate FPM low-resolution images using the Forward model of FPM.

The code will generate FPM low-resolution images degraded by salt & pepper noise and Gaussian noise. <br>
There are also LED position shift, the amplitude of shift can be controlled by parameter named "LED_pos". <br>
The ideal LED positions as well as the shifted one will be shown in one Figure.

#### 2. Run 'elfpie_MM.m' for ELFPIE recontruction. <br>
