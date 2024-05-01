%% This script calculates coherence between two signals using wavelet.
%%
%% Demonstrated functions:
%% generate_fake_signal, calculate_wavelet_coherence

warning('off')

addpath(['..' filesep 'data'])

% Generate two 1-dimensional siganals
% Signal specs
fs = 2000;  % sampling rate
T = 2;  % signal length in time [seconds]
% signal 1
freq1 = [1 4 10]; % frequencies of carrier signal 1
amp1 = [.5 1 0]; % amplitude of carrier signal 2
mod1 = [.5 .2 0]; % modulation frequency and amplitude, and jitter amplitude
noise1 = {'pink', .1}; % noise type and amplitude
% signal 2
freq2 = [15 20 30]; % frequencies of carrier signal 1
amp2 = [.5 1 0]; % amplitude of carrier signal 2
mod2 = [.5 .2 0]; % modulation frequency and amplitude, and jitter amplitude
noise2 = {'pink', .1}; % noise type and amplitude

% Generate fake signals
[signal1, ~] = generate_fake_signal(fs, T, freq1, amp1, mod1, noise1);
[signal2, ~] = generate_fake_signal(fs, T, freq2, amp2, mod2, noise2);

% Calculate wavelet coherence
waveletName = 'morse';
plotType = 1; % 1: basic, 2: w/ phase arrows
calculate_wavelet_coherence(signal1, signal2, fs, waveletName, plotType );
