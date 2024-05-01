function [plv] = calculate_plv(lfp, t, fs, phaseBand)
%
% FILENAME: {file name, not function name}
% calculate_plv.m
%
% FUNCTIONS: {all functions defined in this file}
% self.
%
% DEPENDENCIES: {all dependencies including third party toolbox}
% Signal Processing Toolbox
% 
% DESCRIPTION: {What does this do?}
% This function calculate Phase Locking Values for LFP data using
% filter-Hilbert.
%
% INPUT: {What input arguments does this function take?}
% lfp: multichannel(M), multi-trial(N) LFP data array
% t: time in seconds
% fs: sampling frequency
% phaseBand: phase band for filter
% 
% OUTPUT: {What output does this function make?}
% plv: phase locking values
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
% Refernce paper:
% Lachaux, J., Rodriguez, E., Martinerie, J., Varela, F., et al., 1999.
% "Measuring phase synchrony in brain signals." Hum. Brain Mapp. 8, 194–208
%

% Design a bandpass filter for phase component
n = 100; % filter order
phase_b = fir1(n,phaseBand/(fs/2)); % low-pass filter coefficients for phase

M = size(lfp,1);
N = size(lfp,3);

% Preallocate an array to store the phase locking values
plv = zeros(M,M,N);

% Loop over each trial
for n = 1:N
    % Preallocate a matrix to store the phase values of each channel
    phi = zeros(M,length(t));

    % Loop over each channel
    for m = 1:M
        % Filter the signal using FIR filter to obtain the phase component
        x_filt = filter(phase_b,1,squeeze(lfp(m,:,n))); % low-pass filter for phase

        % Compute the analytic signal using the Hilbert transform
        x_phase = angle(hilbert(x_filt)); % phase of x

        % Store the phase value in the matrix
        phi(m,:) = x_phase;
    end

    % Loop over each pair of channels
    %for i = 1:M-1
    for i = 1:M
        %for j = i+1:M
        for j = 1:M
            % Compute the phase locking value
            plv(i,j,n) = abs(sum(exp(1i*(phi(i,:)-phi(j,:)))))/length(t);
        end
    end
end

% Plot the mean phase locking values across trials using imagesc function
figure;
imagesc(mean(plv,3));
h_c = colorbar;
set(h_c, 'ylim', [0 1])
xticks(1:M)
xticklabels(1:M)
yticks(1:M)
yticklabels(1:M)
xlabel('Channel');
ylabel('Channel');
title('Mean Phase Locking Values');


