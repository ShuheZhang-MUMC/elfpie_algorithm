# ELFPIE: an error-laxity Fourier ptychographic iterative engine
<br>
<br>

This is the MATLAB code for Fourier Ptychography reconstruction using ELFPIE.

We are happy that this research has been accepted and published on **Signal Processing** https://doi.org/10.1016/j.cmpb.2022.107297

## Abstract
We present a simple but efficient and robust reconstruction algorithm for Fourier ptychographic microscopy, termed error-laxity Fourier ptychographic iterative engine (Elfpie), that **is simultaneously robust to (1) noise signal (including Gaussian, Poisson, and salt & pepper noises), (2) problematic background illumination problem, (3) vignetting effects and (4) misaligning of LED positions, without the need of calibrating or recovering these system errors.** <br>

In Elfpie, we embed the inverse problem of FPM under the framework of feature extraction/recovering and propose a new image gradient-based data fidelity cost function regularized by the global second-order total-variation regularization. The closed-form complex gradient for the cost function is derived and is back-propagated using the AdaBelief optimizer with an adaptive learning rate. The Elfpie was tested on both simulation and experimental data. In general, compared against SOTA methods, the Elfpie is robust to Gaussian noise with a 100 times larger noise, salt & pepper noise with 1000 times larger noise and Poisson noise with 10 times larger noise. The Elfpie is able to reconstruct high-fidelity samples under LED position misalignments up to 2 mm. It can also bypass the vignetting effect, for which all SOTA methods fail to reconstruct the sample pattern. 

$\sqrt{3x-1}+(1+x)^2$
