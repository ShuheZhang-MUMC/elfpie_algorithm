# ELFPIE: an error-laxity Fourier ptychographic iterative engine
<br>
This is the MATLAB code for Fourier Ptychography reconstruction using ELFPIE.
<br>

We are happy that this [paper](https://doi.org/10.1016/j.sigpro.2023.109088) has been accepted and published on **Signal Processing** 

## USAGE
Simulation experiments are available in folder [toy-experiment](https://github.com/ShuheZhang-MUMC/elfpie_algorithm/tree/main/toy-experiment) . <br>
Experiment demo is available in folder [usaf_demo](https://github.com/ShuheZhang-MUMC/elfpie_algorithm/tree/main/usaf_demo)
<br>
<br>

## User-friendly FPM experiment
We present a simple but efficient and robust reconstruction algorithm for Fourier ptychographic microscopy, termed error-laxity Fourier ptychographic iterative engine (Elfpie), that is simultaneously robust to <br>
<br>
**(1) noise signal (including Gaussian, Poisson, and salt & pepper noises)** <br>
**(2) problematic background illumination** <br>
**(3) vignetting effects** <br>
**(4) misaligning of LED positions** <br>
**(5) without the need of calibrating or recovering these system errors** <br>
<br>
You don't have to worry about your raw data quality and system calibrations ! (^_^) <br>

<div align="center">
<img src="https://github.com/ShuheZhang-MUMC/elfpie_algorithm/blob/main/toy-experiment/figure_support/out1.png" width = "700" alt="" align=center />
</div>
<br>
<br>

## How does it works ?
In Elfpie, we embed the inverse problem of FPM under the framework of feature extraction/recovering and propose a new image gradient-based data fidelity cost function regularized by the global second-order total-variation regularization. The closed-form complex gradient for the cost function is derived and is back-propagated using the AdaBelief optimizer with an adaptive learning rate. 

<div align="center">
<img src="https://github.com/ShuheZhang-MUMC/elfpie_algorithm/blob/main/image/Fig2.png" width = "700" alt="" align=center />
</div>
<br>
<br>

## ELFPIE cost function
The cost function contains two parts: the fidelity term and penalty term.
$$\mathcal{L}_{ELFPIE} = \mathcal{L} _{Fidelty} + \mathcal{L} _{Penalty} $$
### Data-fidelity term: 
We use the gamma corrected intensity measurement in image gradient domian to be the data fidelity term. Since image gradient is sparse, we further use the L1-norm to achieve sparsity promotion

$$\mathcal{L} _{Fidelty}(\mathbf{\Psi},\mathbf{P})=\sum_{n=1}^{N}\left \|\right \| \bigtriangledown \mathbf{I} ^{\gamma}_{n} - \bigtriangledown\left | \mathbf{F} ^{\dagger}\mathbf{P} \mathbf{M} _{n}\mathbf{\Psi}  \right |^{2\gamma} \left \|\right \|_{1} ,   \mathbb{C}^{A}\longrightarrow \mathbb{R}$$

<br>

$\mathbf{I}_{n}$ denotes the n-th low-resolution image.

$\mathbf{F} ^{\dagger}$ denotes the inverse Fourier transfrom.

$\mathbf{P}$ denotes the pupil function of the image system.

$\mathbf{M}_{n}$ denotes the selection mask for n-th LED illumination.

### Penalty term: 
We use second-order total-variation (TV)-regularization imposed on both amplitude and phase of the recontructed high-resolution image as the penalty term to suppress the noise signal

$$\mathcal{L} _{Penalty}$$

#### The complex gradient of the cost function is calculated uisng the $\mathbb{C}\mathbb{R}-\mathbf{Calculus}$ [[paper]](http://dsp.ucsd.edu/~kreutz/PEI-05%20Support%20Files/complex_derivatives.pdf)
<br>
<br>

## Experiment using HOMEMADE FPM platform
### low-quality raw image data cube

We test the ELFPIE on the USAF resolution target using our **homemade** FPM platform. <br>
The raw image suffers from severe noises and vignetting effect. LED array is not well-calibrated also. <br>
All dark-field images were collected using the same camera setting (exposure time) as that of bright field images. 

<div align="center">
<img src="https://github.com/ShuheZhang-MUMC/elfpie_algorithm/blob/main/image/Demo_2.png" width = "400" alt="" align=center />
</div>
<br>

### high-quality reconstruction image

The recontructed image using elfpie shows its high-experiment robustness.
<div align="center">
<img src="https://github.com/ShuheZhang-MUMC/elfpie_algorithm/blob/main/image/Demo.png" width = "730" alt="" align=center />
</div>


