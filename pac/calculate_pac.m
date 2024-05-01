function [MI] = calculate_pac(signal, phaseBand, ampBand, fs)
%
% FILENAME: {file name, not function name}
% calculate_pac.m
%
% FUNCTIONS: {all functions defined in this file}
% self.
%
% DEPENDENCIES: {all dependencies including third party toolbox}
% Signal Processing Toolbox
% 
% DESCRIPTION: {What does this do?}
% This function calculate Phase-Amplitude Coupling using the modulation
% index (MI) as the Kullback-Leibler divergence between the normalized
% mean amplitude and a uniform distribution.
%
% INPUT: {What input arguments does this function take?}
% signal: signal
% phaseBand: phase band
% ampBand: amplitude band
% fs: sampling frequency
% 
% OUTPUT: {What output does this function make?}
% MI: modulation index
%
% AUTHOR: {Who wrote this code?}
% Jaejin Lee
%
% CONTACT: {preferred contact information}
% jaejin@umn.edu
%
% VERSION: {What is the curent version? Convention: major.minor.bugfixes}
% 0.1.1
%
% CREATED: {When was this code first created?}
% June, 2023
%
% UPDATED: {When was this code last updated?}
% June, 2023
%
% TAG: {What keywords can this be found with?}
% SPECTRAL
%
% REMARKS: {Any remarks to be noted to use this file}
% Reference paper:
% Check out Supporting Information for the following paper.
% Tort, A. B. L., Kramer, M. A., Thorn, C., Gibson, D. J., Kubota, Y., Graybiel,
% A. M., et al. (2008). "Dynamic cross-frequency couplings of local field potential
% oscillations in rat striatum and hippocampus during performance of a T-maze
% task." Proc. Natl. Acad. Sci. U.S.A. 105, 20517–20522. doi: 10.1073/pnas.
% 0810524105
%

    % Design bandpass filters for phase and amplitude components
    n = 30; % filter order
    b_phase = fir1(n,phaseBand/(fs/2)); % low-pass filter coefficients for phase
    b_amp = fir1(n,ampBand/(fs/2)); % high-pass filter coefficients for amplitude
    
    % Filter the signals to obtain the phase and amplitude components
    phase = filter(b_phase,1,signal); % low-pass filter for phase
    amp = filter(b_amp,1,signal); % high-pass filter for amplitude
    
    % Compute the analytic signals using the Hilbert transform
    phase = angle(hilbert(phase)); % phase of signal
    amp = abs(hilbert(amp)); % amplitude envelope of signal
    
    % Define the number of phase bins
    nPhaseBin = 18; % number of phase bins
    
    % Compute the mean amplitude in each phase bin
    bin_amp = zeros(nPhaseBin,1); % mean amplitude of signal in each bin
    bins = -pi:2*pi/nPhaseBin:pi; % phase bin edges
    
    for i = 1:nPhaseBin
        % Find the indices of the phase values that fall within the current bin
        idx = phase >= bins(i) & phase < bins(i+1);
    
        % Compute the mean amplitude for signal in the current bin
        bin_amp(i) = mean(amp(idx));
    end
    
    % Normalize the mean amplitude by its sum over all bins
    bin_amp = bin_amp/sum(bin_amp);
    
    % calculate modulation index (MI)
	Hp = -sum(bin_amp.*log(bin_amp)); % Shannon entropy
	KL = log(nPhaseBin) - Hp; % Kullback-Leibler
    MI = KL / log(nPhaseBin); % MI for signal
    
    % Plot the results as polar histograms
    figure;
    polarhistogram('BinEdges',bins,'BinCounts',bin_amp,'FaceColor','b');
    title(sprintf('Phase-Amplitude Coupling\nMI = %.3f',MI));
    
end
