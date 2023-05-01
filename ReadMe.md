# ELFPIE: an error-laxity Fourier ptychographic iterative engine
<br>
<br>

This is the MATLAB code for Fourier Ptychography reconstruction using ELFPIE.

We are happy that this research has been accepted and published on **Signal Processing** https://doi.org/10.1016/j.cmpb.2022.107297

## User-friendly FPM experiment !
We present a simple but efficient and robust reconstruction algorithm for Fourier ptychographic microscopy, termed error-laxity Fourier ptychographic iterative engine (Elfpie), that is simultaneously robust to <br>
<br>
**(1) noise signal (including Gaussian, Poisson, and salt & pepper noises)** <br>
**(2) problematic background illumination** <br>
**(3) vignetting effects** <br>
**(4) misaligning of LED positions** <br>
**(5) without the need of calibrating or recovering these system errors** <br>
<br>
You don't have to worry about your raw data quality! <br>

## How does it works ?
In Elfpie, we embed the inverse problem of FPM under the framework of feature extraction/recovering and propose a new image gradient-based data fidelity cost function regularized by the global second-order total-variation regularization. The closed-form complex gradient for the cost function is derived and is back-propagated using the AdaBelief optimizer with an adaptive learning rate. 

## ELFPIE cost function

#### Data-fidelity term: We use the gamma corrected intensity measurement in image gradient domian to be the data fidelity term. Since image gradient is sparse, we further use the L1-norm to achieve sparsity promotion

<font size="10">$$\mathcal{L} _{Fidelty}(\mathbf{\Psi},\mathbf{P})=\sum_{n=1}^{N}\left \|\right \| \bigtriangledown \mathbf{I} ^{\gamma}_{n} - \bigtriangledown\left | \mathbf{F} ^{\dagger}\mathbf{P} \mathbf{M} _{n}\mathbf{\Psi}  \right |^{2\gamma} \left \|\right \|_{1} ,   \mathbb{C}^{A}\longrightarrow \mathbb{R}$$</font>


#### Penalty term: We use second-order total-variation (TV)-regularization imposed on both amplitude and phase of the recontructed high-resolution image as the penalty term to suppress the noise signal

$$\mathcal{L} _{Penalty}(\mathbf{\Psi})=\alpha \left \|\right \| \bigtriangledown\bigtriangledown\left | \mathbf{F} ^{\dagger}\mathbf{\Psi}  \right | \left \|\right \|_{1} +\beta\left \|\right \| \bigtriangledown\bigtriangledown \angle\mathbf{F}  ^{\dagger}\mathbf{\Psi}   \left \|\right \|_{1} ,   \mathbb{C}^{A}\longrightarrow \mathbb{R}$$


