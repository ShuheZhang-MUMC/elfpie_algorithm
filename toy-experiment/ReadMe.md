#### The parameters for toy image system is in funsets//init_enviroment.m <br>
<br>
<br>


#### 1. Run 'FPM_get_LowResImg.m' to generate toy FPM data cube. The cube will be saved in simulation folder. <br>

<img src="https://github.com/ShuheZhang-MUMC/elfpie_algorithm/blob/main/toy-experiment/figure_support/Fig1.png" width = "600" alt="" align=center /></div>


The code first generates FPM low-resolution images using the Forward model of FPM as shown in the above figure. <br>
The intensity of data cube is normalized and degraded by **salt & pepper noise** and **Gaussian noise**. <br>

There are also **LED position shift**. The amplitude of such shift can be controlled by parameter named "LED_pos (d, in mm)". <br>
The ideal LED positions as well as the shifted one will be shown in one Figure.

#### 2. Run 'elfpie_MM.m' for ELFPIE recontruction. <br>

One sample results are shown in the following figures. Where SNP noise strength is 0.03, Gaussian noise strength is 0,003.<br>
**The SNR of the data cube is -43.5688.**

<img src="https://github.com/ShuheZhang-MUMC/elfpie_algorithm/blob/main/toy-experiment/figure_support/out1.png" width = "600" alt="" align=center /></div>

