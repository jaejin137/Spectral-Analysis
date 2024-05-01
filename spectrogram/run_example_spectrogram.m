% This script plots spectrogram of a one dimensional fake signal.
%
% Demonstrated functions:
% generate_fake_signal, plot_spectrogram
% 
% Note:
% 

warning('off')

addpath(['..' filesep 'data'])

% Signal specs
fs = 2000;  % sampling rate
T = 2;  % signal length in time [seconds]
freq = [4 20 30]; % frequencies of carrier signal
amp = [1 1 0]; % amplitude of carrier signal
mod = [1 2 0]; % modulation frequency and amplitude, and jitter amplitude
noise = {'pink', .1}; % noise type and amplitude

% Generate a fake signal
[signal, t] = generate_fake_signal(fs, T, freq, amp, mod, noise);

% Plot spectrogram
hammLength = 256;
overlap = .5;  % overlap for spectrogram  
% plot_spectrogram(signal, fs, hammLength, overlap)
plot_spectrogram(signal, fs, hammLength, overlap)
ylim([0 150])
