%% This script calculates phase amplitude coupling of a signal.
%%
%% Demonstrated functions:
%% generate_fake_signal, calculate_pac

warning('off')

addpath(['..' filesep 'data'])

% Generate two 1-dimensional siganals
% Signal specs
fs = 2000;  % sampling rate
T = 2;  % signal length in time [seconds]
freq = [4 10 20]; % frequencies of carrier signal
amp = [1 0 1]; % amplitude of carrier signal
mod = [.5 .5 0]; % modulation frequency and amplitude, and jitter amplitude
noise = {'pink', .1}; % noise type and amplitude
[signal, t] = generate_fake_signal(fs, T, freq, amp, mod, noise);

% Define the frequency bands of interest for phase and amplitude
phaseBand = [1 10]; % Hz
ampBand = [20 50]; % Hz

% Calculate PAC
[MI] = calculate_pac(signal, phaseBand, ampBand, fs);
